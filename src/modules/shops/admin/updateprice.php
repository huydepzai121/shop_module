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

$row = array();
$error = array();
$row['id'] = $nv_Request->get_int('id', 'post,get', 0);

if ($nv_Request->isset_request('submit', 'post')) {
    $row['catid'] = $nv_Request->get_int('catid', 'post', 0);
    $row['newprice'] = $nv_Request->get_string('newprice', 'post', 0);
    $row['newprice'] = floatval(preg_replace('/[^0-9\.]/', '', $row['newprice']));

    $_sql = 'SELECT * FROM ' . $db_config['prefix'] . '_' . $module_data . '_catalogs where catid=' . $row['catid'];
    $_query = $db->query($_sql);
    while ($row1 = $_query->fetch()) {
        $_sql1 = 'UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_rows
             SET product_price=' . $db->quote($row['newprice']) . ' where listcatid=' . $row1['catid'];
        if ($row1['subcatid'] != 0) {
            $_sql1 .= ' OR listcatid IN (' . $row1['subcatid'] . ')';
        }
        $execute = $db->query($_sql1);
        if ($execute) {
            nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=items&listcatid=' . $row1['catid']);
        }
    }
} else {
    $row['id'] = 0;
    $row['catid'] = 0;
    $row['newprice'] = 0;
}

$template = get_tpl_dir([$global_config['module_theme'], $global_config['admin_theme']], 'admin_future', '/modules/' . $module_file . '/updateprice.tpl');
$tpl = new \NukeViet\Template\NVSmarty();
$tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $template . '/modules/' . $module_file);

// Gán các biến cho template
$tpl->assign('LANG', $nv_Lang);
$tpl->assign('MODULE_NAME', $module_name);
$tpl->assign('OP', $op);
$tpl->assign('ROW', $row);

// Xử lý lỗi nếu có
if (!empty($error)) {
    $tpl->assign('ERROR', implode('<br />', $error));
}

// Xử lý danh sách danh mục
$categories = array();
foreach ($global_array_shops_cat as $catid_i => $rowscat) {
    $xtitle_i = '';
    if ($rowscat['lev'] > 0) {
        for ($i = 1; $i <= $rowscat['lev']; $i++) {
            $xtitle_i .= '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
        }
    }
    $categories[] = array(
        'key' => $rowscat['catid'],
        'title' => $xtitle_i . $rowscat['title'],
        'selected' => $catid_i == $row['catid']
    );
}
$tpl->assign('CATEGORIES', $categories);

// Render template
$contents = $tpl->fetch('updateprice.tpl');

$page_title = $nv_Lang->getModule('updateprice');

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
