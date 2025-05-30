<?php

/**
 * NukeViet Content Management System
 * @version 5.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2025 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_IS_FILE_ADMIN')) {
    exit('Stop!!!');
}

$status = $nv_Request->get_int('active', 'post');
$listcid = $nv_Request->get_string('list', 'post');
$checkss = $nv_Request->get_string('checkss', 'post', '');
if ($checkss != md5(NV_CHECK_SESSION . '_' . $module_name . '_' . $admin_info['userid']) || empty($listcid)) {
    nv_jsonOutput(['status' => 'error', 'mess' => $nv_Lang->getGlobal('error_code_11')]);
}

$status = ($status == 1) ? 1 : 0;
$cid_array = explode(',', $listcid);
$cid_array = array_map('intval', $cid_array);
$listcid = implode(', ', $cid_array);

if (defined('NV_IS_SPADMIN')) {
    $db->query('UPDATE ' . NV_PREFIXLANG . '_' . $module_data . ' SET status=' . $status . ' WHERE cid IN (' . $listcid . ')');
} elseif (!empty($site_mod_comm)) {
    $array_mod_name = [];
    foreach ($site_mod_comm as $module_i => $row) {
        $array_mod_name[] = "'" . $module_i . "'";
    }
    $db->query('UPDATE ' . NV_PREFIXLANG . '_' . $module_data . ' SET status=' . $status . ' WHERE cid IN (' . $listcid . ') AND module IN (' . implode(', ', $array_mod_name) . ')');
} else {
    nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name);
}

if (!empty($cid_array) and $status == 1) {
    foreach ($cid_array as $cid) {
        nv_status_notification(NV_LANG_DATA, $module_name, 'comment_queue', $cid);
    }
}

$lang_enable = ($status == 1) ? $nv_Lang->getModule('enable') : $nv_Lang->getModule('disable');
nv_insert_logs(NV_LANG_DATA, $module_name, $nv_Lang->getModule('edit_active') . ': ' . $lang_enable, 'listcid: ' . $listcid, $admin_info['userid']);

// Xac dinh ID cac bai viet
$sql = 'SELECT DISTINCT id, module FROM ' . NV_PREFIXLANG . '_' . $module_data . ' WHERE cid in (' . $listcid . ')';
$query_comment = $db->query($sql);
while ($row = $query_comment->fetch()) {
    if (isset($site_mod_comm[$row['module']])) {
        $mod_info = $site_mod_comm[$row['module']];
        if (file_exists(NV_ROOTDIR . '/modules/' . $mod_info['module_file'] . '/comment.php')) {
            include NV_ROOTDIR . '/modules/' . $mod_info['module_file'] . '/comment.php';
            $nv_Cache->delMod($row['module']);
        }
    }
}
nv_jsonOutput(['status' => 'ok', 'mess' => $nv_Lang->getModule('update_success')]);
