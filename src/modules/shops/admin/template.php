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

if (!defined('NV_IS_SPADMIN')) {
    nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name);
}

$page_title = $nv_Lang->getModule('template');
$error = "";
$savecat = 0;

$data = array(
    "title" => "",
    'alias' => ""
);

$table_name = $db_config['prefix'] . '_' . $module_data . '_template';
$data['id'] = $nv_Request->get_int('id', 'post,get', 0);
$savecat = $nv_Request->get_int('savecat', 'post', 0);

// Thay đổi trạng thái
if ($nv_Request->isset_request('change_status', 'post')) {
    $id = $nv_Request->get_int('id', 'post', 0);
    $new_status = $nv_Request->get_int('new_status', 'post', 0);

    if (empty($id)) {
        nv_jsonOutput([
            'status' => 'ERR',
            'message' => $nv_Lang->getModule('template_error_status')
        ]);
    }
    
    $sql = 'UPDATE ' . $table_name . ' SET status=' . $new_status . ' WHERE id=' . $id;
    $db->query($sql);
    $nv_Cache->delMod($module_name);
    nv_jsonOutput([
        'status' => 'OK',
        'message' => $nv_Lang->getModule('template_success_status')
    ]);
}

// Thay đổi thứ tự
if ($nv_Request->isset_request('changeweight', 'post')) {
    $id = $nv_Request->get_int('id', 'post', 0);
    $new_weight = $nv_Request->get_int('new_weight', 'post', 0);

    if (empty($id) || empty($new_weight)) {
        nv_jsonOutput([
            'status' => 'ERR',
            'message' => $nv_Lang->getModule('template_error_weight')
        ]);
    }

    $sql = 'SELECT id FROM ' . $table_name . ' WHERE id!=' . $id . ' ORDER BY weight ASC';
    $result = $db->query($sql);

    $weight = 0;
    while ($row = $result->fetch()) {
        ++$weight;
        if ($weight == $new_weight) {
            ++$weight;
        }
        $sql = 'UPDATE ' . $table_name . ' SET weight=' . $weight . ' WHERE id=' . $row['id'];
        $db->query($sql);
    }

    $sql = 'UPDATE ' . $table_name . ' SET weight=' . $new_weight . ' WHERE id=' . $id;
    $db->query($sql);
    $nv_Cache->delMod($module_name);
    nv_jsonOutput([
        'status' => 'OK',
        'message' => $nv_Lang->getModule('template_success_weight')
    ]);
}

// Xóa template
if ($nv_Request->isset_request('del', 'post')) {
    $id = $nv_Request->get_int('id', 'post', 0);
    $listid = $nv_Request->get_string('listid', 'post', '');
    
    if (!empty($listid)) {
        $del_array = array_map('intval', explode(',', $listid));
    } else {
        $del_array = array($id);
    }

    if (empty($id) && empty($listid)) {
        nv_jsonOutput([
            'status' => 'ERR',
            'message' => $nv_Lang->getModule('template_error_del')
        ]);
    }
    
    foreach ($del_array as $id) {
        $db->query('DELETE FROM ' . $table_name . ' WHERE id = ' . $id);
    }
    $nv_Cache->delMod($module_name);
    nv_jsonOutput([
        'status' => 'OK',
        'message' => $nv_Lang->getModule('template_success_del')
    ]);

}

if ($nv_Request->isset_request('del_all', 'post')) {
    $listid = $nv_Request->get_string('listid', 'post', '');
    $del_array = array_map('intval', explode(',', $listid));
    if (empty($listid)) {
        nv_jsonOutput([
            'status' => 'ERR',
            'message' => $nv_Lang->getModule('template_error_del')
        ]);
    }
    
    foreach ($del_array as $id) {
        $db->query('DELETE FROM ' . $table_name . ' WHERE id = ' . $id);
    }
    $nv_Cache->delMod($module_name);
    nv_jsonOutput([
        'status' => 'OK',
        'message' => $nv_Lang->getModule('template_success_del')
    ]);
}

if (!empty($savecat)) {
    $data['title'] = nv_substr($nv_Request->get_title('title', 'post', ''), 0, 50);
    $data['alias'] = strtolower(change_alias($data['title']));

    if (empty($data['title'])) {
        $error = $nv_Lang->getModule('template_error_name');
    } else {
        if ($data['id'] == 0) {
            $weight = $db->query("SELECT MAX(weight) FROM " . $table_name)->fetchColumn();
            $weight = intval($weight) + 1;

            $sql = "INSERT INTO " . $table_name . " (
                status, " . NV_LANG_DATA . "_title, alias, weight
            ) VALUES (
                1, :title, :alias, " . $weight . "
            )";
            
            $data_insert = array();
            $data_insert['title'] = $data['title'];
            $data_insert['alias'] = $data['alias'];
            
            $new_id = $db->insert_id($sql, 'id', $data_insert);
            if ($new_id) {
                $nv_Cache->delMod($module_name);
                nv_redirect_location(NV_BASE_ADMINURL . "index.php?" . NV_LANG_VARIABLE . "=" . NV_LANG_DATA . "&" . NV_NAME_VARIABLE . "=" . $module_name . "&" . NV_OP_VARIABLE . "=" . $op);
            }
        } else {
            $stmt = $db->prepare("UPDATE " . $table_name . " SET " . NV_LANG_DATA . "_title = :title WHERE id = " . $data['id']);
            $stmt->bindParam(':title', $data['title'], PDO::PARAM_STR);
            if ($stmt->execute()) {
                $nv_Cache->delMod($module_name);
                nv_redirect_location(NV_BASE_ADMINURL . "index.php?" . NV_LANG_VARIABLE . "=" . NV_LANG_DATA . "&" . NV_NAME_VARIABLE . "=" . $module_name . "&" . NV_OP_VARIABLE . "=" . $op);
            }
        }
    }
} else {
    if ($data['id'] > 0) {
        $data = $db->query("SELECT * FROM " . $table_name . " WHERE id=" . $data['id'])->fetch();
        $data['title'] = $data[NV_LANG_DATA . '_title'];
    }
}

// Fetch template list
$array_data = array();
$result = $db->query("SELECT id, " . NV_LANG_DATA . "_title title, alias, status, weight FROM " . $table_name . " ORDER BY weight ASC");
while ($row = $result->fetch()) {
    $row['link_field_tab'] = NV_BASE_ADMINURL . "index.php?" . NV_LANG_VARIABLE . "=" . NV_LANG_DATA . "&" . NV_NAME_VARIABLE . "=" . $module_name . "&" . NV_OP_VARIABLE . "=field_tab&template=" . $row['id'];
    $row['link_edit'] = NV_BASE_ADMINURL . "index.php?" . NV_LANG_VARIABLE . "=" . NV_LANG_DATA . "&" . NV_NAME_VARIABLE . "=" . $module_name . "&" . NV_OP_VARIABLE . "=" . $op . "&id=" . $row['id'];
    
    // Weight options
    $row['weight_options'] = array();
    for ($i = 1; $i <= $result->rowCount(); $i++) {
        $row['weight_options'][] = array(
            'key' => $i,
            'title' => $i,
            'selected' => $i == $row['weight'] ? ' selected="selected"' : ''
        );
    }
    $array_data[] = $row;
}

$template = get_tpl_dir([$global_config['module_theme'], $global_config['admin_theme']], 'admin_future', '/modules/' . $module_file . '/content.tpl');
$tpl = new \NukeViet\Template\NVSmarty();
$tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $template . '/modules/' . $module_file);

$tpl->assign('LANG', $nv_Lang);
$tpl->assign('DATA', $data);
$tpl->assign('DATA_LIST', $array_data);
$tpl->assign('CAPTION', empty($data['id']) ? $nv_Lang->getModule('template_add') : $nv_Lang->getModule('template_edit'));
$tpl->assign('TEM_ADD', NV_BASE_ADMINURL . "index.php?" . NV_LANG_VARIABLE . "=" . NV_LANG_DATA . "&" . NV_NAME_VARIABLE . "=" . $module_name . "&" . NV_OP_VARIABLE . "=template#add");
$tpl->assign('FIELD_ADD', NV_BASE_ADMINURL . "index.php?" . NV_LANG_VARIABLE . "=" . NV_LANG_DATA . "&" . NV_NAME_VARIABLE . "=" . $module_name . "&" . NV_OP_VARIABLE . "=fields#ffields");
$tpl->assign('URL_DEL', NV_BASE_ADMINURL . "index.php?" . NV_LANG_VARIABLE . "=" . NV_LANG_DATA . "&" . NV_NAME_VARIABLE . "=" . $module_name . "&" . NV_OP_VARIABLE . "=detemplate");
$tpl->assign('URL_DEL_BACK', NV_BASE_ADMINURL . "index.php?" . NV_LANG_VARIABLE . "=" . NV_LANG_DATA . "&" . NV_NAME_VARIABLE . "=" . $module_name . "&" . NV_OP_VARIABLE . "=" . $op);

if (!empty($error)) {
    $tpl->assign('ERROR', $error);
}

$tpl->assign('main', true);
$contents = $tpl->fetch('template.tpl');

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
