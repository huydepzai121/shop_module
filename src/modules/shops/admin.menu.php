<?php

/**
 * @Project NUKEVIET 4.x
 * @Author VINADES.,JSC <contact@vinades.vn>
 * @Copyright (C) 2017 VINADES.,JSC. All rights reserved
 * @License GNU/GPL version 2 or any later version
 * @Createdate 04/18/2017 09:47
 */

if (! defined('NV_ADMIN')) {
    die('Stop!!!');
}

// Menu dọc
global $nv_Cache;
$shop_module_config = array();
$sql = "SELECT module, config_name, config_value FROM " . NV_CONFIG_GLOBALTABLE . " WHERE lang='" . NV_LANG_DATA . "' and module='" . $module_name . "'";
$list = $nv_Cache->db($sql, '', $module_name);
foreach ($list as $row) {
    $shop_module_config[$row['config_name']] = $row['config_value'];
}
$submenu['order'] = $nv_Lang->getModule('order_title');

if ($shop_module_config['use_shipping'] == '1') {
    $submenu['shipping'] = $nv_Lang->getModule('shipping');
}

$submenu['order_seller'] = $nv_Lang->getModule('order_seller');

if ($shop_module_config['review_active'] == '1') {
    $submenu['review'] = $nv_Lang->getModule('review');
}

if ($shop_module_config['active_warehouse']) {
    $submenu['warehouse_logs'] = $nv_Lang->getModule('warehouse_logs');
    $submenu['suppliers'] = $nv_Lang->getModule('suppliers');
}
$submenu_price=array();
$submenu_price['updateprice'] = $nv_Lang->getModule('updateprice');
$submenu['items'] = array( 'title' => $nv_Lang->getModule('content_add_items'), 'submenu' => $submenu_price );

//$submenu['items'] = $nv_Lang->getModule('content_add_items');
$submenu['content'] = $nv_Lang->getModule('content_add');
$submenu['discounts'] = $nv_Lang->getModule('discounts');
$submenu['guarantee'] = $nv_Lang->getModule('guarantee_list');

if ($shop_module_config['use_coupons']) {
    $submenu['coupons'] = $nv_Lang->getModule('coupons');
}

if ($shop_module_config['point_active']) {
    $submenu['point'] = $nv_Lang->getModule('point');
}

if ($shop_module_config['download_active']) {
    $submenu['download'] = $nv_Lang->getModule('download');
}

$submenu['tags'] = $nv_Lang->getModule('tags');

$menu_setting = array();
$menu_setting['cat'] = $nv_Lang->getModule('categories');
$menu_setting['group'] = $nv_Lang->getModule('group');
$menu_setting['blockcat'] = $nv_Lang->getModule('block');
$menu_setting['prounit'] = $nv_Lang->getModule('prounit');
$menu_setting['money'] = $nv_Lang->getModule('money');
$menu_setting['weight'] = $nv_Lang->getModule('weight_unit');
if (defined('NV_IS_SPADMIN')) {
    // if ($shop_module_config['template_active']) {
    //     $menu_setting['template'] = $nv_Lang->getModule('fields');
    // }
    $menu_setting['tabs'] = $nv_Lang->getModule('tabs');

    if ($shop_module_config['active_payment']) {
        $menu_setting['docpay'] = $nv_Lang->getModule('document_payment');
    }
}
$submenu['setting'] = array( 'title' => $nv_Lang->getModule('setting'), 'submenu' => $menu_setting );
