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

$page_title = $nv_Lang->getModule('weight_unit');

$error = '';
$savecat = 0;
$data = array( );

$table_name = $db_config['prefix'] . '_' . $module_data . '_weight_' . NV_LANG_DATA;
$savecat = $nv_Request->get_int('savecat', 'post', 0);

$id = $nv_Request->get_int('id', 'get', 0);
if (!empty($savecat)) {
    $data['code'] = $nv_Request->get_title('code', 'post');
    $data['title'] = $nv_Request->get_title('title', 'post', '', 1);
    $data['exchange'] = $nv_Request->get_title('exchange', 'post,get', 0);
    $data['exchange'] = floatval(preg_replace('/[^0-9\.]/', '', $data['exchange']));
    $data['round'] = $nv_Request->get_title('round', 'post,get', 0);
    $data['round'] = floatval(preg_replace('/[^0-9\.]/', '', $data['round']));

    if (empty($data['code'])) {
        $error = $nv_Lang->getModule('weight_error_empty_code');
    } elseif (empty($data['title'])) {
        $error = $nv_Lang->getModule('weight_error_empty_title');
    } elseif ($data['exchange'] === '') {
        $error = $nv_Lang->getModule('weight_error_empty_exchange');
    } else {
        if (!empty($pro_config['weight_unit']) and $pro_config['weight_unit'] == $data['code']) {
            $data['exchange'] = 1;
        }

        $sql = 'REPLACE INTO ' . $table_name . ' (code, title, exchange, round) VALUES (' . $db->quote($data['code']) . ', ' . $db->quote($data['title']) . ', ' . $db->quote($data['exchange']) . ', ' . $db->quote($data['round']) . ')';

        if ($db->exec($sql)) {
            $error = $nv_Lang->getModule('saveok');
            $nv_Cache->delMod($module_name);
            nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op);
        } else {
            $error = $nv_Lang->getModule('errorsave');
        }
    }
} elseif (!empty($id)) {
    $data = $db->query('SELECT * FROM ' . $table_name . ' WHERE id=' . $id)->fetch();
    $data['caption'] = $nv_Lang->getModule('weight_edit');
}

if (empty($data)) {
    $data = array( );
    $data['id'] = '';
    $data['code'] = '';
    $data['title'] = '';
    $data['exchange'] = 0;
    $data['round'] = 0.01;
    $data['caption'] = $nv_Lang->getModule('weight_add');
}
$template = get_tpl_dir([$global_config['module_theme'], $global_config['admin_theme']], 'admin_future', '/modules/' . $module_file . '/weight.tpl');
$tpl = new \NukeViet\Template\NVSmarty();
$tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $global_config['module_theme'] . '/modules/' . $module_file);
    
// Gán các biến cơ bản
$tpl->assign('LANG', $nv_Lang);
$tpl->assign('MODULE_NAME', $module_name);
$tpl->assign('OP', $op);
$tpl->assign('WEIGHT_UNIT', $pro_config['weight_unit']);

$count = 0;
$array_code_exit = array();
$rows = [];
$result = $db->query('SELECT id, code, title, exchange, round FROM ' . $table_name . ' ORDER BY code DESC');
while ($row = $result->fetch()) {
    $array_code_exit[] = $row['code'];
    $row['link_edit'] = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op . '&id=' . $row['id'];
    $row['link_del'] = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=delweight&id=' . $row['id'];

    $row['exchange'] = floatval($row['exchange']);
    if (intval($row['exchange']) == $row['exchange'] or $row['exchange'] > 1000) {
        $row['exchange'] = number_format($row['exchange'], 0);
    } elseif ($row['exchange'] > 1) {
        $row['exchange'] = number_format($row['exchange'], 5);
    } elseif ($row['exchange'] > 0.001) {
        $row['exchange'] = number_format($row['exchange'], 7);
    } elseif ($row['exchange'] > 0.00001) {
        $row['exchange'] = number_format($row['exchange'], 9);
    } else {
        $row['exchange'] = number_format($row['exchange'], 11);
    }
    $row['round'] = ($row['round'] >= 1) ? number_format($row['round']) : number_format($row['round'], strlen($row['round']) - 2);
    $rows[] = $row;
    ++$count;
}

$tpl->assign('ROWS', $rows);
$tpl->assign('HAS_DATA', $count > 0);

$tpl->assign('URL_DEL', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=delweight');
$tpl->assign('URL_DEL_BACK', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op);

$data['exchange'] = floatval($data['exchange']);
if (intval($data['exchange']) == $data['exchange'] or $data['exchange'] > 1000) {
    $data['exchange'] = number_format($data['exchange'], 0);
} elseif ($data['exchange'] > 1) {
    $data['exchange'] = number_format($data['exchange'], 5);
} elseif ($data['exchange'] > 0.001) {
    $data['exchange'] = number_format($data['exchange'], 7);
} elseif ($data['exchange'] > 0.00001) {
    $data['exchange'] = number_format($data['exchange'], 9);
} else {
    $data['exchange'] = number_format($data['exchange'], 11);
}

$tpl->assign('DATA', $data);

$round_options = [];
for ($i = -5; $i < 5; $i++) {
    $round1 = pow(10, $i);
    if ($i < 1) {
        $round1 = $round2 = number_format($round1, - $i);
    } else {
        $round2 = number_format($round1);
    }

    $round_options[] = array(
        'round1' => $round1,
        'round2' => $round2,
        'selected' => ($round1 == $data['round']) ? 'selected="selected"' : ''
    );
}
$tpl->assign('ROUND_OPTIONS', $round_options);

if (! empty($error)) {
    $tpl->assign('ERROR', $error);
}

$contents = $tpl->fetch('weight.tpl');

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
