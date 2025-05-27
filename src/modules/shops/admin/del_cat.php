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

$catid = $nv_Request->get_int('catid', 'post', 0);
$action = $nv_Request->get_int('action', 'post', 0);
$catidnews = $nv_Request->get_int('catidnews', 'post', 0);

if (empty($catid)) {
    nv_jsonOutput([
        'error' => 1,
        'msg' => $nv_Lang->getModule('error_cat_not_exist')
    ]);
}

list($catid, $parentid, $title) = $db->query('SELECT catid, parentid, ' . NV_LANG_DATA . '_title FROM ' . $db_config['prefix'] . '_' . $module_data . '_catalogs WHERE catid=' . $catid)->fetch(3);

// Kiểm tra có danh mục con
$check_subcats = $db->query('SELECT COUNT(*) FROM ' . $db_config['prefix'] . '_' . $module_data . '_catalogs WHERE parentid = ' . $catid)->fetchColumn();
if ($check_subcats > 0) {
    nv_jsonOutput([
        'error' => 1,
        'msg' => sprintf($nv_Lang->getModule('delcat_msg_cat'), $check_subcats)
    ]);
}

// Kiểm tra có sản phẩm
$check_products = $db->query('SELECT COUNT(*) FROM ' . $db_config['prefix'] . '_' . $module_data . '_rows WHERE listcatid=' . $catid)->fetchColumn();

if ($check_products > 0) {
    if (empty($action)) {
        // Trả về thông tin có sản phẩm để hiển thị confirm
        $sql = 'SELECT catid, ' . NV_LANG_DATA . '_title title FROM ' . $db_config['prefix'] . '_' . $module_data . '_catalogs WHERE catid !=' . $catid . ' ORDER BY sort ASC';
        $result = $db->query($sql);
        $array_cats = [];
        while ($row = $result->fetch()) {
            $array_cats[] = $row;
        }

        nv_jsonOutput([
            'error' => 2, // Có sản phẩm
            'msg' => sprintf($nv_Lang->getModule('delcat_msg_rows'), $check_products),
            'title' => $title,
            'cats' => $array_cats
        ]);
    }

    if ($action == 1 && $catidnews > 0) {
        // Di chuyển sản phẩm
        $db->query('UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_rows SET listcatid=' . $catidnews . ' WHERE listcatid=' . $catid);
    } elseif ($action == 2) {
        // Xóa sản phẩm
        $result = $db->query('SELECT id FROM ' . $db_config['prefix'] . '_' . $module_data . '_rows WHERE listcatid=' . $catid);
        while ($row = $result->fetch()) {
            nv_del_content_module($row['id']);
        }
    } else {
        nv_jsonOutput([
            'error' => 1,
            'msg' => $nv_Lang->getModule('error_cat_delete_action')
        ]);
    }
}

// Xóa danh mục
$db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_catalogs WHERE catid=' . $catid);
nv_fix_cat_order();
$nv_Cache->delMod($module_name);

nv_insert_logs(NV_LANG_DATA, $module_name, 'log_del_catalog', 'ID ' . $catid, $admin_info['userid']);

nv_jsonOutput([
    'error' => 0,
    'msg' => $nv_Lang->getModule('success_cat_delete'),
    'parentid' => $parentid
]);