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

$page_title = $nv_Lang->getModule('block');
$set_active_op = 'blockcat';

$sql = 'SELECT bid, ' . NV_LANG_DATA . '_title FROM ' . $db_config['prefix'] . '_' . $module_data . '_block_cat ORDER BY weight ASC';
$result = $db->query($sql);

$array_block = [];
while (list($bid_i, $title_i) = $result->fetch(3)) {
    $array_block[$bid_i] = $title_i;
}

if (empty($array_block)) {
    nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=blockcat');
}

$cookie_bid = $nv_Request->get_int('int_bid', 'cookie', 0);
if (empty($cookie_bid) or !isset($array_block[$cookie_bid])) {
    $cookie_bid = 0;
}

$bid = $nv_Request->get_int('bid', 'get,post', $cookie_bid);
if (!in_array($bid, array_keys($array_block))) {
    $bid_array_id = array_keys($array_block);
    $bid = $bid_array_id[0];
}

if ($cookie_bid != $bid) {
    $nv_Request->set_Cookie('int_bid', $bid, NV_LIVE_COOKIE_TIME);
}
$page_title = $array_block[$bid];

// Cập nhập weight
if ($nv_Request->isset_request('change_weight', 'post')) {
    $id = $nv_Request->get_int('id', 'post', 0);
    $new_vid = $nv_Request->get_int('new_vid', 'post', 0);
    if (empty($id)) {
        nv_jsonOutput([
            'status' => 'error',
            'message' => $nv_Lang->getModule('no_id')
        ]);
    }
    if ($new_vid > 0) {
        $sql = 'SELECT * FROM ' . $db_config['prefix'] . '_' . $module_data . '_block WHERE bid=' . $bid . ' AND id=' . $id;
        $result = $db->query($sql);
        $numrows = $result->rowCount();
        if ($numrows != 1) {
            nv_jsonOutput([
                'status' => 'error',
                'message' => $nv_Lang->getModule('no_bid')
            ]);
        }

        $sql = 'SELECT bid FROM ' . $db_config['prefix'] . '_' . $module_data . '_block WHERE bid!=' . $bid . ' AND id!=' . $id . ' ORDER BY weight ASC';
        $result = $db->query($sql);
        $weight = 0;
        while ($row = $result->fetch()) {
            ++$weight;
            if ($weight == $new_vid) {
                ++$weight;
            }
            $sql = 'UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_block SET weight=' . $weight . ' WHERE bid=' . intval($row['bid']) . ' AND id=' . intval($id);
            $db->query($sql);
        }

        $sql = 'UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_block SET weight=' . $new_vid . ' WHERE bid=' . intval($bid) . ' AND id=' . intval($id);
        $db->query($sql);
        nv_jsonOutput([
            'status' => 'success',
            'message' => $nv_Lang->getModule('ok_bid')
        ]);
    }
}

// Xóa sản phẩm khỏi block
// if ($nv_Request->get_string('action', 'post') == 'delete') {
//     $bid = $nv_Request->get_int('bid', 'post', 0);
//     $mod = $nv_Request->get_string('mod', 'post', '');
//     $new_vid = $nv_Request->get_int('new_vid', 'post', 0);
//     if (empty($bid)) {
//         nv_jsonOutput([
//             'status' => 'error',
//             'message' => $nv_Lang->getModule('no_bid')
//         ]);
//     }
//     if ($mod == 'weight' and $new_vid > 0) {
//         $sql = 'SELECT * FROM ' . $db_config['prefix'] . '_' . $module_data . '_block_cat WHERE bid=' . $bid;
//         $result = $db->query($sql);
//         $numrows = $result->rowCount();
//         if ($numrows != 1) {
//             nv_jsonOutput([
//                 'status' => 'error',
//                 'message' => $nv_Lang->getModule('no_bid')
//             ]);
//         }
    
//         $sql = 'SELECT bid FROM ' . $db_config['prefix'] . '_' . $module_data . '_block_cat WHERE bid!=' . $bid . ' ORDER BY weight ASC';
//         $result = $db->query($sql);
//         $weight = 0;
//         while ($row = $result->fetch()) {
//             ++$weight;
//             if ($weight == $new_vid) {
//                 ++$weight;
//             }
//             $sql = 'UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_block_cat SET weight=' . $weight . ' WHERE bid=' . intval($row['bid']);
//             $db->query($sql);
//         }
    
//         $sql = 'UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_block_cat SET weight=' . $new_vid . ' WHERE bid=' . intval($bid);
//         $db->query($sql);
//         nv_jsonOutput([
//             'status' => 'success',
//             'message' => $nv_Lang->getModule('ok_bid')
//         ]);
//     } elseif ($mod == 'adddefault' and $bid > 0) {
//         $new_vid = (intval($new_vid) == 1) ? 1 : 0;
//         $sql = 'UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_block_cat SET adddefault=' . $new_vid . ' WHERE bid=' . intval($bid);
//         $db->query($sql);
//         nv_jsonOutput([
//             'status' => 'success',
//             'message' => $nv_Lang->getModule('ok_bid')
//         ]);
//     }
// }

if ($nv_Request->isset_request('checkss,idcheck', 'post') and $nv_Request->get_string('checkss', 'post') == md5(session_id())) {
    $id_array = array_map('intval', $nv_Request->get_array('idcheck', 'post'));
    foreach ($id_array as $id) {
        $db->query("INSERT IGNORE INTO " . $db_config['prefix'] . "_" . $module_data . "_block (bid, id, weight) VALUES ('" . $bid . "', '" . $id . "', '0')");
    }
    nv_news_fix_block($bid);
    $nv_Cache->delMod($module_name);
    nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op . '&bid=' . $bid);
}

$template = get_tpl_dir([$global_config['module_theme'], $global_config['admin_theme']], 'admin_future', '/modules/' . $module_file . '/block.tpl');
$tpl = new \NukeViet\Template\NVSmarty();
$tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $template . '/modules/' . $module_file);
$tpl->assign('LANG', $nv_Lang);
$tpl->assign('NV_BASE_ADMINURL', NV_BASE_ADMINURL);
$tpl->assign('NV_NAME_VARIABLE', NV_NAME_VARIABLE);
$tpl->assign('NV_OP_VARIABLE', NV_OP_VARIABLE);
$tpl->assign('MODULE_NAME', $module_name);
$tpl->assign('OP', $op);
$tpl->assign('CHECKSESS', md5(session_id()));
$tpl->assign('BLOCK_LIST', nv_show_block_list($bid));
$id_array = [];
$listid = $nv_Request->get_string('listid', 'get', '');

if ($listid == '') {
    $db->sqlreset()->select('id, ' . NV_LANG_DATA . '_title')->from($db_config['prefix'] . '_' . $module_data . '_rows')->where('inhome=1 AND id NOT IN(SELECT id FROM ' . $db_config['prefix'] . '_' . $module_data . '_block WHERE bid=' . $bid . ')')->order('id DESC')->limit(20);
    $sql = $db->sql();
} else {
    $id_array = array_map('intval', explode(',', $listid));
    $sql = 'SELECT id, ' . NV_LANG_DATA . '_title FROM ' . $db_config['prefix'] . '_' . $module_data . '_rows WHERE inhome=1 AND id IN (' . implode(',', $id_array) . ') ORDER BY id DESC';
}

$result = $db->query($sql);
$array_data = [];
if ($result->rowCount()) {
    while (list($id, $title) = $result->fetch(3)) {
        $array_data[] = [
            'id' => $id,
            'checked' => in_array($id, $id_array) ? ' checked="checked"' : '',
            'title' => $title
        ];
    }
}

$array_bid = [];
foreach ($array_block as $xbid => $blockname) {
    $array_bid[] = [
        'key' => $xbid,
        'title' => $blockname,
        'selected' => ($xbid == $bid) ? ' selected="selected"' : ''
    ];
}
$tpl->assign('DATA', $array_data);
$tpl->assign('BID', $array_bid);

$contents = $tpl->fetch('block.tpl');

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
