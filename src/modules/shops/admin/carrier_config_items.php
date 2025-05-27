<?php

/**
 * @Project NUKEVIET 4.x
 * @Author VINADES.,JSC <contact@vinades.vn>
 * @Copyright (C) 2017 VINADES.,JSC. All rights reserved
 * @License GNU/GPL version 2 or any later version
 * @Createdate 04/18/2017 09:47
 */

if (!defined('NV_IS_FILE_ADMIN')) {
    die('Stop!!!');
}

$page_title = $nv_Lang->getModule('carrier_config_config');
$cid = $nv_Request->get_int('cid', 'post,get', 0);

// Xử lý AJAX thay đổi thứ tự
if ($nv_Request->isset_request('ajax_action', 'post, get')) {
    $id = $nv_Request->get_int('id', 'post, get', 0);
    $new_vid = $nv_Request->get_int('new_vid', 'post, get', 0);
    
    if ($new_vid > 0) {
        $sql = 'SELECT id FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config_items WHERE id!=' . $id . ' and cid=' . $cid . ' ORDER BY weight ASC';
        $result = $db->query($sql);
        
        $weight = 0;
        while ($row = $result->fetch()) {
            ++$weight;
            if ($weight == $new_vid) {
                ++$weight;
            }
            $db->query('UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config_items SET weight=' . $weight . ' WHERE id=' . $row['id'] . ' AND cid=' . $cid);
        }
        
        $db->query('UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config_items SET weight=' . $new_vid . ' WHERE id=' . $id . ' AND cid=' . $cid);
        $nv_Cache->delMod($module_name);
        nv_jsonOutput([
            'status' => 'OK',
            'message' => $nv_Lang->getModule('update_success')
        ]);
    }
    nv_jsonOutput([
        'status' => 'ERR',
        'message' => $nv_Lang->getModule('error_update')
    ]);
}

if ($nv_Request->isset_request('delete', 'post,get')) {
    $id = $nv_Request->get_int('delete_id', 'post,get');
    $delete_checkss = $nv_Request->get_string('delete_checkss', 'post,get');
    
    if ($id > 0 && $delete_checkss == md5($id . NV_CACHE_PREFIX . $client_info['session_id'])) {
        $weight = $db->query('SELECT weight FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config_items WHERE id =' . $id)->fetchColumn();
        
        $db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config_items WHERE id = ' . $id);
        $db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config_location WHERE iid = ' . $id);
        $db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config_weight WHERE iid = ' . $id);
        
        if ($weight > 0) {
            $sql = 'SELECT id, weight FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config_items WHERE weight >' . $weight;
            $result = $db->query($sql);
            while (list($id, $weight) = $result->fetch(3)) {
                $weight--;
                $db->query('UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config_items SET weight=' . $weight . ' WHERE id=' . intval($id));
            }
        }
        $nv_Cache->delMod($module_name);
        nv_jsonOutput([
            'status' => 'OK',
            'message' => $nv_Lang->getModule('delete_success')
        ]);
    } else {
        nv_jsonOutput([
            'status' => 'ERR',
            'message' => $nv_Lang->getModule('error_delete')
        ]);
    }
}

$row = array();
$error = array();
$row['id'] = $nv_Request->get_int('id', 'post,get', 0);
$row['cid'] = $nv_Request->get_int('cid', 'post,get', 0);

if (empty($row['cid'])) {
    nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=carrier_config');
}
// Lấy thông tin khi sửa
if ($row['id'] > 0) {
    $row = $db->query('SELECT * FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config_items WHERE id=' . $row['id'])->fetch();
    if (empty($row)) {
        nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op);
    }

    // Lấy cấu hình khối lượng
    $row['config_weight'] = array();
    $result = $db->query('SELECT * FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config_weight WHERE iid=' . $row['id'] . ' ORDER BY weight');
    while ($weight = $result->fetch()) {
        $row['config_weight'][] = $weight;
    }

    // Lấy địa điểm
    $row['config_location'] = array();
    $result = $db->query('SELECT lid FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config_location WHERE iid=' . $row['id']);
    while ($location = $result->fetch()) {
        $row['config_location'][] = $location['lid'];
    }
    $config_location_old = $row['config_location'];
} else {
    $row['id'] = 0;
    $row['title'] = '';
    $row['description'] = '';
    $row['config_weight'] = array(array(
        'weight' => '',
        'weight_unit' => $pro_config['weight_unit'],
        'carrier_price' => '',
        'carrier_price_unit' => $pro_config['money_unit']
    ));
    $row['config_location'] = array();
    $config_location_old = array();
}

// Xử lý submit form
if ($nv_Request->isset_request('submit', 'post')) {
    $row['title'] = $nv_Request->get_title('title', 'post', '');
    $row['cid'] = $nv_Request->get_int('cid', 'post', 0);
    $row['description'] = $nv_Request->get_textarea('description', '', NV_ALLOWED_HTML_TAGS);
    $row['config_location'] = $nv_Request->get_array('config_location', 'post', array());
    $row['config_weight'] = $nv_Request->get_array('config_weight', 'post', array());

    // Lọc bỏ các cấu hình trọng lượng trống
    foreach ($row['config_weight'] as $key => $array) {
        if (empty($array['weight']) || empty($array['carrier_price'])) {
            unset($row['config_weight'][$key]);
        }
    }

    // Sắp xếp cấu hình trọng lượng
    $sortArray = array();
    foreach ($row['config_weight'] as $config_i) {
        $sortArray['weight'][] = $config_i['weight'];
        $sortArray['weight_unit'][] = $config_i['weight_unit'];
        $sortArray['carrier_price'][] = floatval($config_i['carrier_price']);
        $sortArray['carrier_price_unit'][] = $config_i['carrier_price_unit'];
    }
    array_multisort($sortArray['weight'], empty($row['id']) ? SORT_ASC : SORT_DESC, $row['config_weight']);

    if (empty($row['title'])) {
        $error[] = $nv_Lang->getModule('carrier_config_error_required_name');
    }

    if (empty($error)) {
        try {
            if (empty($row['id'])) {
                $weight = $db->query('SELECT max(weight) FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config_items WHERE cid=' . $row['cid'])->fetchColumn();
                $weight = intval($weight) + 1;

                $stmt = $db->prepare('INSERT INTO ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config_items 
                    (cid, title, description, weight, add_time) 
                    VALUES (:cid, :title, :description, :weight, ' . NV_CURRENTTIME . ')');
                $stmt->bindParam(':weight', $weight, PDO::PARAM_INT);
            } else {
                $stmt = $db->prepare('UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config_items SET 
                    cid = :cid, title = :title, description = :description 
                    WHERE id=' . $row['id']);
            }

            $stmt->bindParam(':cid', $row['cid'], PDO::PARAM_INT);
            $stmt->bindParam(':title', $row['title'], PDO::PARAM_STR);
            $stmt->bindParam(':description', $row['description'], PDO::PARAM_STR);

            $exc = $stmt->execute();
            if ($exc) {
                $item_id = empty($row['id']) ? $db->lastInsertId() : $row['id'];

                // Cập nhật cấu hình khối lượng
                if (!empty($row['config_weight'])) {
                    $db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config_weight WHERE iid=' . $item_id);
                    foreach ($row['config_weight'] as $config) {
                        $config['carrier_price'] = floatval(preg_replace('/[^0-9\.]/', '', $config['carrier_price']));
                        $sql = 'INSERT INTO ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config_weight 
                            (iid, weight, weight_unit, carrier_price, carrier_price_unit) 
                            VALUES (' . $item_id . ', ' . $config['weight'] . ', ' . $db->quote($config['weight_unit']) . ', 
                            ' . $config['carrier_price'] . ', ' . $db->quote($config['carrier_price_unit']) . ')';
                        $db->query($sql);
                    }
                }

                // Cập nhật địa điểm
                if ($row['config_location'] != $config_location_old) {
                    $db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config_location WHERE iid=' . $item_id);
                    foreach ($row['config_location'] as $location_id) {
                        $sql = 'INSERT INTO ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config_location 
                            (cid, iid, lid) VALUES (' . $row['cid'] . ', ' . $item_id . ', ' . $location_id . ')';
                        $db->query($sql);
                    }
                }

                $nv_Cache->delMod($module_name);
                nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op . '&cid=' . $row['cid']);
            }
        } catch (PDOException $e) {
            trigger_error($e->getMessage());
            $error[] = $nv_Lang->getModule('error_save');
        }
    }
}

// Fetch danh sách
$array_data = array();
$per_page = 20;
$page = $nv_Request->get_int('page', 'post,get', 1);

$db->sqlreset()
    ->select('COUNT(*)')
    ->from($db_config['prefix'] . '_' . $module_data . '_carrier_config_items')
    ->where('cid=' . $row['cid']);
$num_items = $db->query($db->sql())->fetchColumn();

$db->select('*')
    ->order('weight ASC')
    ->limit($per_page)
    ->offset(($page - 1) * $per_page);

$result = $db->query($db->sql());
while ($view = $result->fetch()) {
    $view['link_edit'] = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op . '&amp;id=' . $view['id'] . '&amp;cid=' . $row['cid'];
    $view['link_delete'] = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op . '&amp;cid=' . $row['cid'] . '&amp;delete_id=' . $view['id'] . '&amp;delete_checkss=' . md5($view['id'] . NV_CACHE_PREFIX . $client_info['session_id']);
    $view['delete_checkss'] = md5($view['id'] . NV_CACHE_PREFIX . $client_info['session_id']);
    // Weight options
    $view['weight_options'] = array();
    for ($i = 1; $i <= $num_items; ++$i) {
        $view['weight_options'][] = array(
            'key' => $i,
            'title' => $i,
            'selected' => $i == $view['weight'] ? ' selected="selected"' : ''
    );
}
$array_data[] = $view;
}

// Lấy danh sách địa điểm
$array_location_list = array();
if (!empty($row['id'])) {
    $sql = "SELECT id, title, lev FROM " . $db_config['prefix'] . '_' . $module_data . "_location WHERE id NOT IN ( SELECT lid FROM " . $db_config['prefix'] . "_" . $module_data . "_carrier_config_location WHERE cid = " . $row['cid'] . " ) OR id IN ( SELECT lid FROM " . $db_config['prefix'] . '_' . $module_data . "_carrier_config_location WHERE iid = " . $row['id'] . " ) ORDER BY sort ASC";
} else {
    $sql = "SELECT id, title, lev FROM " . $db_config['prefix'] . '_' . $module_data . "_location WHERE id NOT IN ( SELECT lid FROM " . $db_config['prefix'] . "_" . $module_data . "_carrier_config_location WHERE cid = " . $row['cid'] . " ) ORDER BY sort ASC";
}
$result = $db->query($sql);
while (list($id_i, $title_i, $lev_i) = $result->fetch(3)) {
    $xtitle_i = '';
    if ($lev_i > 0) {
        $xtitle_i .= '&nbsp;';
        for ($i = 1; $i <= $lev_i; $i++) {
            $xtitle_i .= '&nbsp;&nbsp;&nbsp;';
        }
    }
    $xtitle_i .= $title_i;
    $array_location_list[] = array(
        'id' => $id_i,
        'title' => $xtitle_i,
        'selected' => in_array($id_i, $row['config_location']) ? ' selected="selected"' : ''
    );
}

// Lấy danh sách cấu hình
$array_config_list = array();
$result = $db->query('SELECT id, title FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config ORDER BY id DESC');
while ($config = $result->fetch()) {
    $array_config_list[] = array(
        'id' => $config['id'],
        'title' => $config['title'],
        'selected' => $config['id'] == $row['cid'] ? ' selected="selected"' : ''
    );
}
$template = get_tpl_dir([$global_config['module_theme'], $global_config['admin_theme']], 'admin_future', '/modules/' . $module_file . '/carrier_config_items.tpl');
$tpl = new \NukeViet\Template\NVSmarty();
$tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $template . '/modules/' . $module_file);
$tpl->assign('LANG', $nv_Lang);
$tpl->assign('MODULE_NAME', $module_name);
$tpl->assign('OP', $op);
$tpl->assign('ROW', $row);
$tpl->assign('CAPTION', $row['id'] ? $nv_Lang->getModule('carrier_config_items_edit') : $nv_Lang->getModule('carrier_config_items_add'));
$tpl->assign('DATA', $array_data);
$tpl->assign('LOCATIONS', $array_location_list);
$tpl->assign('CONFIGS', $array_config_list);
$tpl->assign('WEIGHT_CONFIG', $weight_config);
$tpl->assign('MONEY_CONFIG', $money_config);

$tpl->assign('LOCALTION_URL', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=location');
$tpl->assign('CARRIER_URL', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=carrier');
$tpl->assign('CONFIG_URL', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=carrier_config');
$tpl->assign('SHOPS_URL', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=shops');

// Generate page
$base_url = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op . '&amp;cid=' . $row['cid'];
$generate_page = nv_generate_page($base_url, $num_items, $per_page, $page);
if (!empty($generate_page)) {
    $tpl->assign('GENERATE_PAGE', $generate_page);
}

if (!empty($error)) {
    $tpl->assign('ERROR', implode('<br />', $error));
}

$contents = $tpl->fetch('carrier_config_items.tpl');

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
