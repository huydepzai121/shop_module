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

$per_page = 20;
$page = $nv_Request->get_int('page', 'post,get', 1);
$array_search = array();
$array_search['keywords'] = $nv_Request->get_title('keywords', 'post,get', '');
$array_search['shops_id'] = $nv_Request->get_int('shops_id', 'post,get', 0);
$array_search['carrier_id'] = $nv_Request->get_int('carrier_id', 'post,get', 0);

$db->sqlreset()
    ->select('COUNT(*)')
    ->from($db_config['prefix'] . '_' . $module_data . '_orders_shipping t1')
    ->join('INNER JOIN ' . $db_config['prefix'] . '_' . $module_data . '_orders t2 ON t1.order_id = t2.order_id');

$where = '';
if (!empty($array_search['keywords'])) {
    $where .= ' AND ship_name LIKE :q_ship_name OR ship_phone LIKE :q_ship_phone OR ship_address_extend LIKE :q_ship_address_extend';
}
if (!empty($array_search['shops_id'])) {
    $where .= ' AND ship_shops_id = ' . $array_search['shops_id'];
}
if (!empty($array_search['carrier_id'])) {
    $where .= ' AND ship_carrier_id = ' . $array_search['carrier_id'];
}

if (! empty($where)) {
    $db->where('1=1' . $where);
}

$sth = $db->prepare($db->sql());

if (!empty($array_search['keywords'])) {
    $sth->bindValue(':q_ship_name', '%' . $array_search['keywords'] . '%');
    $sth->bindValue(':q_ship_phone', '%' . $array_search['keywords'] . '%');
    $sth->bindValue(':q_ship_address_extend', '%' . $array_search['keywords'] . '%');
}
$sth->execute();
$num_items = $sth->fetchColumn();

$db->select('t1.*, t2.order_id, t2.order_code')->order('id DESC')->limit($per_page)->offset(($page - 1) * $per_page);
$sth = $db->prepare($db->sql());

if (!empty($array_search['keywords'])) {
    $sth->bindValue(':q_ship_name', '%' . $array_search['keywords'] . '%');
    $sth->bindValue(':q_ship_phone', '%' . $array_search['keywords'] . '%');
    $sth->bindValue(':q_ship_address_extend', '%' . $array_search['keywords'] . '%');
}
$sth->execute();

$template = get_tpl_dir([$global_config['module_theme'], $global_config['admin_theme']], 'admin_future', '/modules/' . $module_file . '/content.tpl');
$tpl = new \NukeViet\Template\NVSmarty();
$tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $template . '/modules/' . $module_file);

$tpl->assign('LANG', $nv_Lang);
$tpl->assign('NV_LANG_VARIABLE', NV_LANG_VARIABLE);
$tpl->assign('NV_LANG_DATA', NV_LANG_DATA);
$tpl->assign('NV_BASE_ADMINURL', NV_BASE_ADMINURL);
$tpl->assign('NV_NAME_VARIABLE', NV_NAME_VARIABLE);
$tpl->assign('NV_OP_VARIABLE', NV_OP_VARIABLE);
$tpl->assign('MODULE_NAME', $module_name);
$tpl->assign('OP', $op);
$tpl->assign('SEARCH', $array_search);

$tpl->assign('LOCALTION_URL', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=location');
$tpl->assign('CARRIER_URL', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=carrier');
$tpl->assign('CONFIG_URL', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=carrier_config');
$tpl->assign('SHOPS_URL', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=shops');


$base_url = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op;
if (!empty($array_search['keywords'])) {
    $base_url .= '&keywords=' . $array_search['keywords'];
}
if (!empty($array_search['shops_id'])) {
    $base_url .= '&shops_id=' . $array_search['shops_id'];
}
if (!empty($array_search['carrier_id'])) {
    $base_url .= '&carrier_id=' . $array_search['carrier_id'];
}

$array_data = array();
while ($view = $sth->fetch()) {
    $view['ship_price'] = number_format($view['ship_price'], nv_get_decimals($view['ship_price_unit']));
    $view['ship_location_title'] = $array_location[$view['ship_location_id']]['title'];
    while ($array_location[$view['ship_location_id']]['parentid'] > 0) {
        $items = $array_location[$array_location[$view['ship_location_id']]['parentid']];
        $view['ship_location_title'] .= ', ' . $items['title'];
        $array_location[$view['ship_location_id']]['parentid'] = $items['parentid'];
    }
    $view['ship_shops_title'] = $array_shops[$view['ship_shops_id']]['name'];
    $view['ship_carrier_title'] = $array_carrier[$view['ship_carrier_id']]['name'];
    $view['order_view'] = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=or_view&amp;order_id=' . $view['order_id'];
    $array_data[] = $view;
}
$tpl->assign('DATA', $array_data);

$generate_page = nv_generate_page($base_url, $num_items, $per_page, $page);
if (!empty($generate_page)) {
    $tpl->assign('GENERATE_PAGE', $generate_page);
}

// Danh sách shops
$array_shops = array();
foreach ($array_shops as $shops) {
    $array_shops[] = array(
        'id' => $shops['id'],
        'name' => $shops['name'],
        'selected' => $array_search['shops_id'] == $shops['id'] ? 'selected="selected"' : ''
    );
}
$tpl->assign('SHOPS', $array_shops);

// Danh sách hãng vận chuyển
$array_carriers = array();
foreach ($array_carrier as $carrier) {
    $array_carriers[] = array(
        'id' => $carrier['id'],
        'name' => $carrier['name'],
        'selected' => $array_search['carrier_id'] == $carrier['id'] ? 'selected="selected"' : ''
    );
}
$tpl->assign('CARRIERS', $array_carriers);

$tpl->assign('main', true);
$contents = $tpl->fetch('shipping.tpl');

$page_title = $nv_Lang->getModule('carrier');

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
