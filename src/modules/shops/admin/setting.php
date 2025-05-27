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

if (defined('NV_EDITOR')) {
    require_once NV_ROOTDIR . '/' . NV_EDITORSDIR . '/' . NV_EDITOR . '/nv.php';
}

$currencies_array = nv_parse_ini_file(NV_ROOTDIR . '/includes/ini/currencies.ini', true);
$data = $module_config[$module_name];

if (!empty($data)) {
    $temp = explode("x", $data['image_size']);
    $data['homewidth'] = $temp[0];
    $data['homeheight'] = $temp[1];
}

$page_title = $nv_Lang->getModule('setting');

$savesetting = $nv_Request->get_int('savesetting', 'post', 0);
$error = "";

// Group custom
$groups_list = nv_groups_list();
unset($groups_list[4], $groups_list[5], $groups_list[6], $groups_list[7]);

// Group default
$groups_list_default = nv_groups_list();

if ($savesetting == 1) {
    $data['homewidth'] = $nv_Request->get_int('homewidth', 'post', 0);
    $data['homeheight'] = $nv_Request->get_int('homeheight', 'post', 0);
    $data['image_size'] = $data['homewidth'] . "x" . $data['homeheight'];
    $data['per_page'] = $nv_Request->get_int('per_page', 'post', 0);
    $data['per_row'] = $nv_Request->get_int('per_row', 'post', 0);
    $data['auto_check_order'] = $nv_Request->get_string('auto_check_order', 'post', 0);
    $data['post_auto_member'] = $nv_Request->get_string('post_auto_member', 'post', 0);
    $data['money_unit'] = $nv_Request->get_string('money_unit', 'post', "");
    $data['weight_unit'] = $nv_Request->get_string('weight_unit', 'post', "");
    $data['home_data'] = $nv_Request->get_title('home_data', 'post', 'all');
    $data['home_view'] = $nv_Request->get_title('home_view', 'post', 'viewgrid');
    $data['format_order_id'] = $nv_Request->get_string('format_order_id', 'post', '');
    $data['format_code_id'] = $nv_Request->get_string('format_code_id', 'post', '');
    $data['facebookappid'] = $nv_Request->get_string('facebookappid', 'post', '');
    $data['alias_lower'] = $nv_Request->get_int('alias_lower', 'post', 0);
    $data['active_order'] = $nv_Request->get_int('active_order', 'post', 0);
    $data['active_order_popup'] = $nv_Request->get_int('active_order_popup', 'post', 0);
    $data['active_order_non_detail'] = $nv_Request->get_int('active_order_non_detail', 'post', 0);
    $data['active_price'] = $nv_Request->get_int('active_price', 'post', 0);
    $data['active_order_number'] = $nv_Request->get_int('active_order_number', 'post', 0);
    $data['order_day'] = $nv_Request->get_int('order_day', 'post', 0);
    $data['active_payment'] = $nv_Request->get_int('active_payment', 'post', 0);
    $data['active_showhomtext'] = $nv_Request->get_int('active_showhomtext', 'post', 0);
    $_groups_notify = $nv_Request->get_array('groups_notify', 'post', array());
    $data['groups_notify'] = !empty($_groups_notify) ? implode(',', array_intersect($_groups_notify, array_keys($groups_list))) : '';
    $data['active_tooltip'] = $nv_Request->get_int('active_tooltip', 'post', 0);
    $data['show_product_code'] = $nv_Request->get_int('show_product_code', 'post', 0);
    $data['sortdefault'] = $nv_Request->get_int('sortdefault', 'post', 0);
    $data['show_compare'] = $nv_Request->get_int('show_compare', 'post', 0);
    $data['show_displays'] = $nv_Request->get_int('show_displays', 'post', 0);
    $data['use_shipping'] = $nv_Request->get_int('use_shipping', 'post', 0);
    $data['use_coupons'] = $nv_Request->get_int('use_coupons', 'post', 0);
    $data['active_guest_order'] = $nv_Request->get_int('active_guest_order', 'post', 0);
    $data['active_wishlist'] = $nv_Request->get_int('active_wishlist', 'post', 0);
    $data['active_gift'] = $nv_Request->get_int('active_gift', 'post', 0);
    $data['active_warehouse'] = $nv_Request->get_int('active_warehouse', 'post', 0);
    $data['tags_alias'] = $nv_Request->get_int('tags_alias', 'post', 0);
    $data['auto_tags'] = $nv_Request->get_int('auto_tags', 'post', 0);
    $data['tags_remind'] = $nv_Request->get_int('tags_remind', 'post', 0);

    $data['point_active'] = $nv_Request->get_int('point_active', 'post', 0);
    $data['point_conversion'] = $nv_Request->get_string('point_conversion', 'post', 0);
    $data['point_conversion'] = floatval(preg_replace('/[^0-9\.]/', '', $data['point_conversion']));
    $data['money_to_point'] = $nv_Request->get_string('money_to_point', 'post', 0);
    $data['money_to_point'] = floatval(preg_replace('/[^0-9\.]/', '', $data['money_to_point']));
    $data['point_new_order'] = $nv_Request->get_string('point_new_order', 'post', 0);

    $data['review_active'] = $nv_Request->get_int('review_active', 'post', 0);
    $data['review_check'] = $nv_Request->get_int('review_check', 'post', 0);
    $data['review_captcha'] = $nv_Request->get_int('review_captcha', 'post', 0);
    $data['group_price'] = $nv_Request->get_textarea('group_price', '', 'br');
    $data['template_active'] = $nv_Request->get_int('template_active', 'post', 0);
    $data['download_active'] = $nv_Request->get_int('download_active', 'post', 0);
    $data['saleprice_active'] = $nv_Request->get_int('saleprice_active', 'post', 0);
    $_dowload_groups = $nv_Request->get_array('download_groups', 'post', array());
    $data['download_groups'] = !empty($_dowload_groups) ? implode(',', nv_groups_post(array_intersect($_dowload_groups, array_keys($groups_list_default)))) : '';

    if ($error == '') {
        $sth = $db->prepare("UPDATE " . NV_CONFIG_GLOBALTABLE . " SET config_value = :config_value WHERE lang = '" . NV_LANG_DATA . "' AND module = :module_name AND config_name = :config_name");
        $sth->bindParam(':module_name', $module_name, PDO::PARAM_STR);
        foreach ($data as $config_name => $config_value) {
            $sth->bindParam(':config_name', $config_name, PDO::PARAM_STR);
            $sth->bindParam(':config_value', $config_value, PDO::PARAM_STR);
            $sth->execute();
        }

        $mid = intval($currencies_array[$data['money_unit']]['numeric']);

        $sql = "UPDATE " . $db_config['prefix'] . "_" . $module_data . "_money_" . NV_LANG_DATA . " SET exchange = '1' WHERE id = " . $mid;
        $db->query($sql);

        nv_insert_logs(NV_LANG_DATA, $module_name, $nv_Lang->getModule('setting'), "Setting", $admin_info['userid']);
        $nv_Cache->delMod('settings');
        $nv_Cache->delMod($module_name);

        nv_redirect_location(NV_BASE_ADMINURL . "index.php?" . NV_LANG_VARIABLE . "=" . NV_LANG_DATA . "&" . NV_NAME_VARIABLE . "=" . $module_name . "&" . NV_OP_VARIABLE . '=setting');
    }
}

$data['point_conversion'] = number_format($data['point_conversion']);
$data['money_to_point'] = number_format($data['money_to_point']);

$template = get_tpl_dir([$global_config['module_theme'], $global_config['admin_theme']], 'admin_future', '/modules/' . $module_file . '/content.tpl');
$tpl = new \NukeViet\Template\NVSmarty();
$tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $template . '/modules/' . $module_file);

$tpl->assign('LANG', $nv_Lang);
$tpl->assign('DATA', $data);
$tpl->assign('MODULE_NAME', $module_name);

// Số sản phẩm hiển thị trên một dòng
$per_rows = [];
for ($i = 1; $i <= 10; $i++) {
    $per_rows[] = array(
        'value' => $i,
        'selected' => $data['per_row'] == $i
    );
}
$tpl->assign('PER_ROWS', $per_rows);

$array_home_view = array(
    'viewgrid' => $nv_Lang->getModule('viewcat_page_gird'),
    'viewlist' => $nv_Lang->getModule('viewcat_page_list')
);
$home_views = array();
foreach ($array_home_view as $index => $value) {
    $home_views[] = array(
        'index' => $index,
        'value' => $value,
        'selected' => $index == $data['home_view']
    );
}
$tpl->assign('HOME_VIEWS', $home_views);

$array_home_data = array(
    'all' => $nv_Lang->getModule('view_home_all'),
    'cat' => $nv_Lang->getModule('view_home_cat'),
    'group' => $nv_Lang->getModule('view_home_group'),
    'none' => $nv_Lang->getModule('view_home_none')
);
$home_data = array();
foreach ($array_home_data as $index => $value) {
    $home_data[] = array(
        'index' => $index,
        'value' => $value,
        'selected' => $index == $data['home_data']
    );
}
$tpl->assign('HOME_DATA', $home_data);

$select = '';
for ($i = 5; $i <= 50; $i = $i + 5) {
    $select .= "<option value=\"" . $i . "\"" . (($i == $data['per_page']) ? " selected=\"selected\"" : "") . ">" . $i . "</option>\n";
}

$tpl->assign('TAGS_ALIAS', $module_config[$module_name]['tags_alias'] ? ' checked="checked"' : '');
$tpl->assign('AUTO_TAGS', $module_config[$module_name]['auto_tags'] ? ' checked="checked"' : '');
$tpl->assign('TAGS_REMIND', $module_config[$module_name]['tags_remind'] ? ' checked="checked"' : '');

$check = ($data['active_order'] == '1') ? 'checked="checked"' : '';
$tpl->assign('ck_active_order', $check);

$check = ($data['active_order_popup'] == '1') ? 'checked="checked"' : '';
$tpl->assign('ck_active_order_popup', $check);

$check = ($data['active_order_non_detail'] == '1') ? 'checked="checked"' : '';
$tpl->assign('ck_active_order_non_detail', $check);

$check = ($data['active_price'] == '1') ? 'checked="checked"' : '';
$tpl->assign('ck_active_price', $check);

$check = ($data['active_order_number'] == '1') ? 'checked="checked"' : '';
$tpl->assign('ck_active_order_number', $check);

$check = ($data['active_payment'] == '1') ? 'checked="checked"' : '';
$tpl->assign('ck_active_payment', $check);

$check = ($data['active_guest_order'] == '1') ? 'checked="checked"' : '';
$tpl->assign('ck_active_guest_order', $check);

$check = ($data['active_showhomtext'] == '1') ? 'checked="checked"' : '';
$tpl->assign('ck_active_showhomtext', $check);

$check = ($data['active_tooltip'] == '1') ? 'checked="checked"' : '';
$tpl->assign('ck_active_tooltip', $check);

$check = ($data['alias_lower'] == '1') ? 'checked="checked"' : '';
$tpl->assign('ck_alias_lower', $check);

$check = !empty($data['show_product_code']) ? 'checked="checked"' : '';
$tpl->assign('ck_show_product_code', $check);

$check = ($data['show_compare'] == '1') ? 'checked="checked"' : '';
$tpl->assign('ck_compare', $check);

$check = ($data['show_displays'] == '1') ? 'checked="checked"' : '';
$tpl->assign('ck_displays', $check);

$check = ($data['use_shipping'] == '1') ? 'checked="checked"' : '';
$tpl->assign('ck_shipping', $check);

$check = ($data['use_coupons'] == '1') ? 'checked="checked"' : '';
$tpl->assign('ck_coupons', $check);

$check = ($data['point_active'] == '1') ? 'checked="checked"' : '';
$tpl->assign('ck_active_point', $check);

$check = ($data['review_check'] == '1') ? 'checked="checked"' : '';
$tpl->assign('ck_review_check', $check);

$check = ($data['review_captcha'] == '1') ? 'checked="checked"' : '';
$tpl->assign('ck_review_captcha', $check);

$check = ($data['point_active'] == '1') ? 'checked="checked"' : '';
$tpl->assign('ck_active_point', $check);

$notify_groups = array();
foreach ($groups_list as $_group_id => $_title) {
    $notify_groups[] = array(
        'value' => $_group_id,
        'checked' => in_array($_group_id, explode(',', $data['groups_notify'])),
        'title' => $_title
    );
}
$tpl->assign('NOTIFY_GROUPS', $notify_groups);

// Tien te
$money_units = array();
$result = $db->query("SELECT code, currency FROM " . $db_config['prefix'] . "_" . $module_data . "_money_" . NV_LANG_DATA . " ORDER BY code DESC");
while (list ($code, $currency) = $result->fetch(3)) {
    $money_units[] = array(
        'value' => $code,
        'title' => $code . " - " . $currency,
        'selected' => $code == $data['money_unit']
    );
}
$tpl->assign('MONEY_UNITS', $money_units);

// Don vi khoi luong
$weight_units = array();
$result = $db->query("SELECT code, title FROM " . $db_config['prefix'] . "_" . $module_data . "_weight_" . NV_LANG_DATA . " ORDER BY code DESC");
while (list ($code, $title) = $result->fetch(3)) {
    $weight_units[] = array(
        'value' => $code,
        'title' => $code . " - " . $title,
        'selected' => $code == $data['weight_unit']
    );
}
$tpl->assign('WEIGHT_UNITS', $weight_units);

$download_groups_data = array();
foreach ($groups_list_default as $_group_id => $_title) {
    $download_groups_data[] = array(
        'value' => $_group_id,
        'checked' => in_array($_group_id, explode(',', $data['download_groups'])),
        'title' => $_title
    );
}
$tpl->assign('DOWNLOAD_GROUPS', $download_groups_data);
$tpl->assign('DOWNLOAD_ACTIVE', $data['download_active']);

$tpl->assign('per_page', $select);

if (!empty($error)) {
    $tpl->assign('error', $error);
    $tpl->parse('main.error');
}

$array_sortdefault = array(
    0 => $nv_Lang->getModule('setting_sortdefault_0'),
    1 => $nv_Lang->getModule('setting_sortdefault_1'),
    2 => $nv_Lang->getModule('setting_sortdefault_2')
);
$sort_defaults = array();
foreach ($array_sortdefault as $index => $value) {
    $sort_defaults[] = array(
        'index' => $index,
        'value' => $value,
        'selected' => $data['sortdefault'] == $index
    );
}
$tpl->assign('SORT_DEFAULTS', $sort_defaults);

$contents = $tpl->fetch('setting.tpl');
include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
