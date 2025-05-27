<?php

/**
 * @Project NUKEVIET 4.x
 * @Author VINADES.,JSC <contact@vinades.vn>
 * @Copyright (C) 2017 VINADES.,JSC. All rights reserved
 * @License GNU/GPL version 2 or any later version
 * @Createdate 04/18/2017 09:47
 */

if (! defined('NV_IS_FILE_ADMIN')) {
    die('Stop!!!');
}

$page_title = $nv_Lang->getModule('location');

$table_name = $db_config['prefix'] . '_' . $module_data . '_location';
$error = '';
$data = array(
    'id' => 0,
    'parentid' => 0,
    'title' => '',
    'parentid_old' => 0
);

$page = $nv_Request->get_int('page', 'get', 1);
$per_page = 20;
$base_url = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=location';

// Đổi weight
if ($nv_Request->get_title('mod', 'post', '') == 'weight') {
    $locationid = $nv_Request->get_int('locationid', 'post', 0);
    $mod = $nv_Request->get_string('mod', 'post', '');
    $new_vid = $nv_Request->get_int('new_vid', 'post', 0);
    $parentid = $nv_Request->get_int('parentid', 'post', 0);
    if (empty($locationid) || empty($mod) || empty($new_vid)) {
        nv_jsonOutput([
            'status' => 'error',
            'mess' => $nv_Lang->getModule('location_name_empty')
        ]);
    }
    
    try {
        if ($mod == 'weight' and $new_vid > 0) {
            $sql = 'SELECT id FROM ' . $db_config['prefix'] . '_' . $module_data . '_location WHERE id!=' . $locationid . ' AND parentid=' . $parentid . ' ORDER BY weight ASC';
            $result = $db->query($sql);
    
            $weight = 0;
            while ($row = $result->fetch()) {
                ++$weight;
                if ($weight == $new_vid) {
                    ++$weight;
                }
                $sql = 'UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_location SET weight=' . $weight . ' WHERE id=' . $row['id'];
                $db->query($sql);
            }
    
            $sql = 'UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_location SET weight=' . $new_vid . ' WHERE id=' . $locationid;
            $db->query($sql);
            $nv_Cache->delMod($module_name);
            nv_fix_location_order();
            nv_jsonOutput([
                'status' => 'OK',
                'message' => $nv_Lang->getModule('location_weight_success')
            ]);
        }
    } catch (PDOException $e) {
        pr($e);
    }
}

// Lưu dữ liệu
if ($nv_Request->isset_request('savelocation', 'post')) {
    $data['id'] = $nv_Request->get_int('id', 'post', 0); 
    $data['parentid_old'] = $nv_Request->get_int('parentid_old', 'post', 0);
    $data['parentid'] = $nv_Request->get_int('parentid', 'post', 0);
    $data['title'] = nv_substr($nv_Request->get_title('title', 'post', '', 1), 0, 255);

    if (empty($data['title'])) {
        $error = $nv_Lang->getModule('location_name_empty');
    }

    if (empty($error)) {
        if ($data['id'] == 0) {
            // Thêm mới
            $weight = $db->query('SELECT max(weight) FROM ' . $table_name . ' WHERE parentid=' . $data['parentid'])->fetchColumn();
            $weight = intval($weight) + 1;
            
            $sql = "INSERT INTO " . $table_name . " (parentid, title, weight, sort, lev, numsub, subid) 
                    VALUES (" . $data['parentid'] . ", :title, " . $weight . ", '0', '0', '0', '')";
            
            $data_insert = array();
            $data_insert['title'] = $data['title'];
            
            $new_id = $db->insert_id($sql, 'id', $data_insert);
            if ($new_id > 0) {
                nv_fix_location_order();
                $nv_Cache->delMod($module_name);
                nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op . '&parentid=' . $data['parentid']);
            } else {
                $error = $nv_Lang->getModule('errorsave');
            }
        } else {
            // Cập nhật
            try {
                $stmt = $db->prepare('UPDATE ' . $table_name . ' SET parentid=:parentid, title=:title WHERE id=' . $data['id']);
                $stmt->bindParam(':parentid', $data['parentid'], PDO::PARAM_INT);
                $stmt->bindParam(':title', $data['title'], PDO::PARAM_STR);
                
                if ($stmt->execute()) {
                    if ($data['parentid'] != $data['parentid_old']) {
                        $weight = $db->query('SELECT max(weight) FROM ' . $table_name . ' WHERE parentid=' . $data['parentid'])->fetchColumn();
                        $weight = intval($weight) + 1;
                        $sql = 'UPDATE ' . $table_name . ' SET weight=' . $weight . ' WHERE id=' . intval($data['id']);
                        $db->query($sql);
                        nv_fix_location_order();
                    }
                    
                    $nv_Cache->delMod($module_name);
                    nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op . '&parentid=' . $data['parentid']);
                }
            } catch (PDOException $e) {
                $error = $nv_Lang->getModule('errorsave');
            }
        }
    }
}

// Xóa địa điểm
if ($nv_Request->get_title('mod', 'post', '') == 'del') {
    $locationid = $nv_Request->get_int('locationid', 'post', 0);
    $parentid = $nv_Request->get_int('parentid', 'post', 0);
    $mod = $nv_Request->get_string('mod', 'post', '');
    if (empty($locationid) || empty($mod)) {
        nv_jsonOutput([
            'status' => 'error',
            'mess' => $nv_Lang->getModule('location_name_empty')
        ]);
    }

    try {
        $sql = 'DELETE FROM ' . $table_name . ' WHERE id=' . $locationid;
        $db->query($sql);
        nv_fix_location_order();
        nv_jsonOutput([
            'status' => 'OK',
            'message' => $nv_Lang->getModule('location_delete_success')
        ]);
    } catch (PDOException $e) {
        nv_jsonOutput([
            'status' => 'error',
            'mess' => $nv_Lang->getModule('errorsave')
        ]);
    }
}

// Lấy thông tin để sửa
$data['parentid'] = $nv_Request->get_int('parentid', 'get,post', 0);
$data['id'] = $nv_Request->get_int('id', 'get', 0);

if ($data['id'] > 0) {
    list($data['id'], $data['parentid'], $data['title']) = $db->query('SELECT id, parentid, title FROM ' . $table_name . ' where id=' . $data['id'])->fetch(3);
    $caption = $nv_Lang->getModule('location_edit');
} else {
    $caption = $nv_Lang->getModule('location_add');
}

// Danh sách các địa điểm cha
$sql = "SELECT id, title, lev FROM " . $table_name . " WHERE id !='" . $data['id'] . "' ORDER BY sort ASC";
$result = $db->query($sql);
$array_location_list = array();
$array_location_list[0] = array('0', $nv_Lang->getModule('location_not_in'));

while (list($id_i, $title_i, $lev_i) = $result->fetch(3)) {
    $xtitle_i = '';
    if ($lev_i > 0) {
        $xtitle_i .= '&nbsp;';
        for ($i = 1; $i <= $lev_i; $i++) {
            $xtitle_i .= '---';
        }
    }
    $xtitle_i .= $title_i;
    $array_location_list[] = array($id_i, $xtitle_i);
}

$template = get_tpl_dir([$global_config['module_theme'], $global_config['admin_theme']], 'admin_future', '/modules/' . $module_file . '/content.tpl');
$tpl = new \NukeViet\Template\NVSmarty();
$tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $template . '/modules/' . $module_file);

$tpl->assign('LANG', $nv_Lang);
$tpl->assign('CAPTION', $caption);
$tpl->assign('DATA', $data);
$tpl->assign('LOCATION_LIST', shops_show_location_list($data['parentid'], $page, $per_page, $base_url));
$tpl->assign('FORM_ACTION', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op . '&amp;id=' . $data['id'] . '&amp;parentid=' . $data['parentid']);

$tpl->assign('LOCALTION_URL', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=location');
$tpl->assign('CARRIER_URL', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=carrier');
$tpl->assign('CONFIG_URL', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=carrier_config');
$tpl->assign('SHOPS_URL', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=shops');
// Danh sách địa điểm cha
$array_parent_list = array();
foreach ($array_location_list as $rows_i) {
    $sl = ($rows_i[0] == $data['parentid']) ? ' selected="selected"' : '';
    $array_parent_list[] = array(
        'id' => $rows_i[0],
        'title' => $rows_i[1],
        'selected' => $sl
    );
}
$tpl->assign('parent_list', $array_parent_list);

if (!empty($error)) {
    $tpl->assign('error', $error);
}

$tpl->assign('main', true);
$contents = $tpl->fetch('location.tpl');

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
