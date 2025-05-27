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

$id = $nv_Request->get_int('id', 'get', 0);
if (empty($id)) {
    nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=coupons');
}

if ($nv_Request->isset_request('coupons_history', 'post,get')) {
    $page = $nv_Request->get_int('page', 'get', 1);
    $per_page = 20;
    $base_url = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op . '&coupons_history=1&id=' . $id;

    $array_history = array();
    $template = get_tpl_dir([$global_config['module_theme'], $global_config['admin_theme']], 'admin_future', '/modules/' . $module_file . '/content.tpl');
    $tpl = new \NukeViet\Template\NVSmarty();
    $tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $template . '/modules/' . $module_file);

    $db->sqlreset()
      ->select('COUNT(*)')
      ->from($db_config['prefix'] . '_' . $module_data . '_coupons_history t1')
      ->join('INNER JOIN ' . $db_config['prefix'] . '_' . $module_data . '_orders t2 ON t1.order_id = t2.order_id')
      ->where('cid=' . $id);

    $all_page = $db->query($db->sql())->fetchColumn();

    $db->select('*')
      ->order('date_added DESC')
      ->limit($per_page)
      ->offset(($page - 1) * $per_page);

    $_query = $db->query($db->sql());
    while ($row = $_query->fetch()) {
        $row['date_added'] = nv_date('H:i d/m/Y', $row['date_added']);
        $row['order_view'] = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=or_view&order_id=' . $row['order_id'];
        $array_history[] = $row;
    }
    
    $generate_page = nv_generate_page($base_url, $all_page, $per_page, $page, true, true, 'nv_urldecode_ajax', 'coupons_history');

    $tpl->assign('LANG', $nv_Lang);
    $tpl->assign('MONEY_UNIT', $pro_config['money_unit']);
    $tpl->assign('HISTORY', $array_history);
    $tpl->assign('GENERATE_PAGE', $generate_page);

    $contents = $tpl->fetch('coupons_view_history.tpl');

    include NV_ROOTDIR . '/includes/header.php';
    echo nv_admin_theme($contents, false);
    include NV_ROOTDIR . '/includes/footer.php';
    die();
}
$template = get_tpl_dir([$global_config['module_theme'], $global_config['admin_theme']], 'admin_future', '/modules/' . $module_file . '/content.tpl');
$tpl = new \NukeViet\Template\NVSmarty();
$tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $template . '/modules/' . $module_file);
$array_data = array();
$result = $db->query('SELECT * FROM ' . $db_config['prefix'] . '_' . $module_data . '_coupons WHERE id = ' . $id);
$array_data = $result->fetch();

$result = $db->query('SELECT * FROM ' . $db_config['prefix'] . '_' . $module_data . '_coupons_product WHERE cid = ' . $array_data['id']);
$array_data['product'] = $result->fetch();

if (NV_CURRENTTIME >= $array_data['date_start'] and (empty($array_data['uses_per_coupon']) or $array_data['uses_per_coupon_count'] < $array_data['uses_per_coupon']) and (empty($array_data['date_end']) or NV_CURRENTTIME < $array_data['date_end'])) {
    $array_data['status'] = $lang_module['coupons_active'];
} else {
    $array_data['status'] = $lang_module['coupons_inactive'];
}

$array_data['discount_text'] = $array_data['type'] == 'p' ? '%' : ' ' . $pro_config['money_unit'];
$array_data['date_start'] = !empty($array_data['date_start']) ? nv_date('d/m/Y', $array_data['date_start']) : 'N/A';
$array_data['date_end'] = !empty($array_data['date_end']) ? nv_date('d/m/Y', $array_data['date_end']) : $lang_module['coupons_unlimit'];

$tpl->assign('LANG', $nv_Lang);
$tpl->assign('DATA', $array_data);
$tpl->assign('MONEY_UNIT', $pro_config['money_unit']);
$tpl->assign('CID', $id);

$contents = $tpl->fetch('coupons_view.tpl');

$page_title = $array_data['title'];

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
