<?php

/**
 * @Project NUKEVIET 4.x
 * @Author VINADES.,JSC <contact@vinades.vn>
 * @Copyright (C) 2017 VINADES.,JSC. All rights reserved
 * @License GNU/GPL version 2 or any later version
 * @Createdate 04/18/2017 09:47
 */

if (! defined('NV_IS_MOD_SHOPS')) {
    die('Stop!!!');
}

// Chặn lập chỉ mục tìm kiếm
$nv_BotManager->setPrivate();

$id = $nv_Request->get_int('id', 'get,post', 0);

$result = $db->query("SELECT * FROM " . $db_config['prefix'] . "_" . $module_data . "_rows WHERE status=1 AND id = " . $id);
$data_content = $result->fetch();
if (empty($data_content)) {
    nv_info_die($nv_Lang->getGlobal('error_404_title'), $nv_Lang->getGlobal('error_404_title'), $nv_Lang->getGlobal('error_404_content'), 404);
}

$page_url = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op . '&amp;id=' . $id;
$canonicalUrl = getCanonicalUrl($page_url);

$catid = $data_content['listcatid'];

$result = $db->query("SELECT * FROM " . $db_config['prefix'] . "_" . $module_data . "_units WHERE id = " . $data_content['product_unit']);
$data_unit = $result->fetch();
$data_unit['title'] = $data_unit[NV_LANG_DATA . '_title'];

$homeimgfile = $data_content['homeimgfile'];
if ($data_content['homeimgthumb'] == 1) {//image thumb
    $data_content['homeimgthumb'] = NV_BASE_SITEURL . NV_FILES_DIR . '/' . $module_upload . '/' . $homeimgfile;
    $data_content['homeimgfile'] = NV_BASE_SITEURL . NV_UPLOADS_DIR . '/' . $module_upload . '/' . $homeimgfile;
} elseif ($data_content['homeimgthumb'] == 2) {//image file
    $data_content['homeimgthumb'] = $data_content['homeimgfile'] = NV_BASE_SITEURL . NV_UPLOADS_DIR . '/' . $module_upload . '/' . $homeimgfile;
} elseif ($data_content['homeimgthumb'] == 3) {//image url
    $data_content['homeimgthumb'] = $data_content['homeimgfile'] = $homeimgfile;
} else {//no image
    $data_content['homeimgthumb'] = $data_content['homeimgfile'] = NV_BASE_SITEURL . "themes/" . $module_info['template'] . "/images/" . $module_file . "/no-image.jpg";
}

$page_title = $data_content[NV_LANG_DATA . '_title'];

$contents = print_product($data_content, $data_unit, $page_title);

include NV_ROOTDIR . '/includes/header.php';
echo nv_site_theme($contents, false);
include NV_ROOTDIR . '/includes/footer.php';
