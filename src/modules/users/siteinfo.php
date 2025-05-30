<?php

/**
 * NukeViet Content Management System
 * @version 5.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2025 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_IS_FILE_SITEINFO')) {
    exit('Stop!!!');
}

$_mod_table = ($mod_data == 'users') ? NV_USERS_GLOBALTABLE : $db_config['prefix'] . '_' . $mod_data;
$level = $admin_info['level'];

$_arr_siteinfo = [];
$cacheFile = 'siteinfo_' . NV_CACHE_PREFIX . '.cache';
$cacheTTL = 1800;

if (($cache = $nv_Cache->getItem($mod, $cacheFile, $cacheTTL)) != false) {
    $_arr_siteinfo = unserialize($cache);
    $access_admin = $_arr_siteinfo['access_admin'];
} else {
    if ($global_config['idsite'] > 0) {
        $site_condition = ' WHERE idsite=' . $global_config['idsite'];
        $active2step_request_condition = $site_condition . ' AND active2step=2';
    } else {
        $site_condition = '';
        $active2step_request_condition = ' WHERE active2step=2';
    }
    $_arr_siteinfo['number_user'] = $db->query('SELECT COUNT(*) FROM ' . $_mod_table . $site_condition)->fetchColumn();
    $_arr_siteinfo['number_user_reg'] = $db->query('SELECT COUNT(*) FROM ' . $_mod_table . '_reg' . $site_condition)->fetchColumn();
    $_arr_siteinfo['number_user_edit'] = $db->query('SELECT COUNT(*) FROM ' . $_mod_table . '_edit')->fetchColumn();
    $_arr_siteinfo['number_active2step_request'] = $db->query('SELECT COUNT(*) FROM ' . $_mod_table . $active2step_request_condition)->fetchColumn();

    $access_admin = $db->query('SELECT content FROM ' . $_mod_table . "_config WHERE config='access_admin'")->fetchColumn();
    $access_admin = unserialize($access_admin);
    $_arr_siteinfo['access_admin'] = $access_admin;

    $nv_Cache->setItem($mod, $cacheFile, serialize($_arr_siteinfo), $cacheTTL);
}

// Số thành viên
if ($_arr_siteinfo['number_user'] > 0) {
    $siteinfo[] = [
        'key' => $nv_Lang->getModule('siteinfo_user'),
        'value' => nv_number_format($_arr_siteinfo['number_user'])
    ];
}

// Số thành viên đợi kích hoạt
if ($_arr_siteinfo['number_user_reg'] > 0) {
    $pendinginfo[] = [
        'key' => $nv_Lang->getModule('siteinfo_waiting'),
        'value' => nv_number_format($_arr_siteinfo['number_user_reg']),
        'link' => NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $mod . '&amp;' . NV_OP_VARIABLE . '=user_waiting'
    ];
}

// Số thành viên chờ kiểm duyệt thông tin cá nhân
if (!empty($_arr_siteinfo['number_user_edit']) and isset($access_admin['access_editcensor'][$level]) and $access_admin['access_editcensor'][$level] == 1) {
    $pendinginfo[] = [
        'key' => $nv_Lang->getModule('siteinfo_editcensor'),
        'value' => nv_number_format($_arr_siteinfo['number_user_edit']),
        'link' => NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $mod . '&amp;' . NV_OP_VARIABLE . '=editcensor'
    ];
}

// Số thành viên đăng ký vào nhóm chờ kiểm duyệt
if (isset($access_admin['access_groups'][$level]) and $access_admin['access_groups'][$level] == 1) {
    $pending_lists = $group_ids = [];

    $sql = 'SELECT COUNT(*) num_users, group_id FROM ' . $_mod_table . '_groups_users WHERE approved = 0 GROUP BY group_id';
    $result = $db->query($sql);

    while ($row = $result->fetch()) {
        $row['title'] = 'N/A';
        $pending_lists[$row['group_id']] = $row;
        $group_ids[$row['group_id']] = $row['group_id'];
    }

    if (!empty($group_ids)) {
        $sql = 'SELECT g.group_id, d.title FROM ' . $_mod_table . '_groups AS g LEFT JOIN ' . $_mod_table . "_groups_detail d ON ( g.group_id = d.group_id AND d.lang='" . NV_LANG_DATA . "' ) WHERE g.group_id > 9 AND g.group_id IN(" . implode(',', $group_ids) . ')';
        $result = $db->query($sql);

        while ($row = $result->fetch()) {
            $pending_lists[$row['group_id']]['title'] = $row['title'];
        }
    }

    if (!empty($pending_lists)) {
        foreach ($pending_lists as $row) {
            $pendinginfo[] = [
                'key' => $nv_Lang->getModule('group_user_peding', $row['title']),
                'value' => nv_number_format($row['num_users'], 0, ',', '.'),
                'link' => NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $mod . '&amp;' . NV_OP_VARIABLE . '=groups&userlist=' . $row['group_id']
            ];
        }
    }
}

// Số yêu cầu tắt xác thực 2 bước
if (!empty($_arr_siteinfo['number_active2step_request'])) {
    $pendinginfo[] = [
        'key' => $nv_Lang->getModule('active2step_status2'),
        'value' => nv_number_format($_arr_siteinfo['number_active2step_request']),
        'link' => NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $mod . '&amp;active2step=request'
    ];
}
