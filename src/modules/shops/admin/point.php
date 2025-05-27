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

if (!$pro_config['point_active']) {
    nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name);
}

$page_title = $nv_Lang->getModule('point');

$q = $nv_Request->get_title('q', 'post,get');
$per_page = 20;
$page = $nv_Request->get_int('page', 'post,get', 1);

$db->sqlreset()
    ->select('COUNT(*)')
    ->from(NV_USERS_GLOBALTABLE . ' t1')
    ->join('LEFT JOIN ' . $db_config['prefix'] . '_' . $module_data . '_point t2 ON t1.userid=t2.userid');

if (!empty($q)) {
    $db->where('username LIKE :q_username OR first_name LIKE :q_first_name OR last_name LIKE :q_last_name OR email LIKE :q_email');
}

$sth = $db->prepare($db->sql());

if (!empty($q)) {
    $sth->bindValue(':q_username', '%' . $q . '%');
    $sth->bindValue(':q_first_name', '%' . $q . '%');
    $sth->bindValue(':q_last_name', '%' . $q . '%');
    $sth->bindValue(':q_email', '%' . $q . '%');
}
$sth->execute();
$num_items = $sth->fetchColumn();

$db->select('t1.username, t1.first_name, t1.last_name, t1.email, t2.*')
    ->order('t1.userid DESC')
    ->limit($per_page)
    ->offset(($page - 1) * $per_page);

$sth = $db->prepare($db->sql());

if (!empty($q)) {
    $sth->bindValue(':q_username', '%' . $q . '%');
    $sth->bindValue(':q_first_name', '%' . $q . '%');
    $sth->bindValue(':q_last_name', '%' . $q . '%');
    $sth->bindValue(':q_email', '%' . $q . '%');
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
$tpl->assign('Q', $q);
$tpl->assign('money_unit', $pro_config['money_unit']);

$base_url = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op;
if (!empty($q)) {
    $base_url .= '&q=' . $q;
}
$generate_page = nv_generate_page($base_url, $num_items, $per_page, $page);
if (!empty($generate_page)) {
    $tpl->assign('GENERATE_PAGE', $generate_page);
}

$array_data = [];
while ($view = $sth->fetch()) {
    $view['full_name'] = nv_show_name_user($view['first_name'], $view['last_name']);
    $view['point_total'] = !empty($view['point_total']) ? $view['point_total'] : 0;
    $view['money'] = number_format($view['point_total'] * $pro_config['point_conversion'], nv_get_decimals($pro_config['money_unit']));
    $array_data[] = $view;
}
$tpl->assign('DATA', $array_data);

$tpl->assign('main', true);
$contents = $tpl->fetch('point.tpl');

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
