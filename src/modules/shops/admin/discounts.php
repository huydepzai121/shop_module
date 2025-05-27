<?php

/**
 * @Project NUKEVIET 4.x
 * @Author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2017 VINADES.,JSC. All rights reserved
 * @License GNU/GPL version 2 or any later version
 * @Createdate 04/18/2017 09:47
 */

if (!defined('NV_IS_FILE_ADMIN')) {
    die('Stop!!!');
}

$config_discount = array();

if ($nv_Request->isset_request('delete_did', 'get') and $nv_Request->isset_request('delete_checkss', 'get')) {
    $did = $nv_Request->get_int('delete_did', 'get');
    $delete_checkss = $nv_Request->get_string('delete_checkss', 'get');
    if ($did > 0 and $delete_checkss == md5($did . NV_CACHE_PREFIX . $client_info['session_id'])) {
        $db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_discounts  WHERE did = ' . $db->quote($did));
        nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op);
    }
}

$row = array();
$error = array();
$row['did'] = $nv_Request->get_int('did', 'post,get', 0);
if ($nv_Request->isset_request('submit', 'post')) {
    $row['title'] = $nv_Request->get_title('title', 'post', '');
    $row['detail'] = $nv_Request->get_int('detail', 'post', 0);
    if (preg_match('/^([0-9]{1,2})\/([0-9]{1,2})\/([0-9]{4})$/', $nv_Request->get_string('begin_time', 'post'), $m)) {
        $_hour = 0;
        $_min = 0;
        $row['begin_time'] = mktime($_hour, $_min, 0, $m[2], $m[1], $m[3]);
    } else {
        $row['begin_time'] = 0;
    }
    if (preg_match('/^([0-9]{1,2})\/([0-9]{1,2})\/([0-9]{4})$/', $nv_Request->get_string('end_time', 'post'), $m)) {
        $_hour = 23;
        $_min = 59;
        $_sec = 59;
        $row['end_time'] = mktime($_hour, $_min, $_sec, $m[2], $m[1], $m[3]);
    } else {
        $row['end_time'] = 0;
    }

    $config = $nv_Request->get_array('config', 'post');
    $sortArray = array();
    foreach ($config as $config_i) {
        $sortArray['discount_from'][] = intval($config_i['discount_from']);
        $sortArray['discount_to'][] = intval($config_i['discount_to']);
        $sortArray['discount_number'][] = floatval($config_i['discount_number']);
        $sortArray['discount_unit'][] = $config_i['discount_unit'];
    }
    array_multisort($sortArray['discount_from'], SORT_ASC, $config);

    foreach ($config as $key => $config_i) {
        $config_i['discount_from'] = intval($config_i['discount_from']);
        $config_i['discount_to'] = intval($config_i['discount_to']);
        $config_i['discount_number'] = floatval($config_i['discount_number']);
        $config_i['discount_unit'] = $config_i['discount_unit'];
        if ($config_i['discount_from'] > 0 and $config_i['discount_to'] >= $config_i['discount_from'] and $config_i['discount_number'] >= 0) {
            $config_discount[] = $config_i;
        }
    }
    $row['config'] = serialize($config_discount);

    // Thêm xử lý cateid
    $row['cateid'] = $nv_Request->get_typed_array('cateid', 'post', 'int', []);
    $row['cateid'] = !empty($row['cateid']) ? implode(',', $row['cateid']) : '';

    if (empty($row['title'])) {
        $error[] = $nv_Lang->getModule('error_required_title');
    } elseif (empty($row['begin_time'])) {
        $error[] = $nv_Lang->getModule('error_required_begin_time');
    }

    if (empty($error)) {
        try {
            if (empty($row['did'])) {
                $row['add_time'] = NV_CURRENTTIME;
                $row['edit_time'] = NV_CURRENTTIME;

                $stmt = $db->prepare('INSERT INTO ' . $db_config['prefix'] . '_' . $module_data . '_discounts (title, add_time, edit_time, begin_time, end_time, config, detail, cateid) VALUES (:title, :add_time, :edit_time, :begin_time, :end_time, :config, :detail, :cateid)');

                $stmt->bindParam(':add_time', $row['add_time'], PDO::PARAM_INT);
                $stmt->bindParam(':edit_time', $row['edit_time'], PDO::PARAM_INT);
            } else {
                $stmt = $db->prepare('UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_discounts SET title = :title, edit_time = ' . NV_CURRENTTIME . ', begin_time = :begin_time, end_time = :end_time, config = :config, detail = :detail, cateid = :cateid WHERE did=' . $row['did']);
            }
            $stmt->bindParam(':title', $row['title'], PDO::PARAM_STR);
            $stmt->bindParam(':begin_time', $row['begin_time'], PDO::PARAM_INT);
            $stmt->bindParam(':end_time', $row['end_time'], PDO::PARAM_INT);
            $stmt->bindParam(':detail', $row['detail'], PDO::PARAM_INT);
            $stmt->bindParam(':config', $row['config'], PDO::PARAM_STR, strlen($row['config']));
            $stmt->bindParam(':cateid', $row['cateid'], PDO::PARAM_STR);

            $exc = $stmt->execute();
            if ($exc) {
                $nv_Cache->delMod($module_name);
                nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op);
            }
        } catch (PDOException $e) {
            trigger_error($e->getMessage());
        }
    }
} elseif ($row['did'] > 0) {
    $row = $db->query('SELECT * FROM ' . $db_config['prefix'] . '_' . $module_data . '_discounts WHERE did=' . $row['did'])->fetch();
    if (empty($row)) {
        nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op);
    }
    if (!empty($row['config'])) {
        $config_discount = unserialize($row['config']);
    }
    // Chuyển cateid từ chuỗi thành mảng
    $row['cateid'] = !empty($row['cateid']) ? explode(',', $row['cateid']) : [];
} else {
    $row['did'] = 0;
    $row['title'] = '';
    $row['begin_time'] = NV_CURRENTTIME;
    $row['end_time'] = 0;
    $row['config'] = '';
    $row['detail'] = 0;
    $row['cateid'] = [];
    $config_discount[0] = array(
        'discount_from' => '1',
        'discount_to' => '',
        'discount_number' => '',
        'discount_unit' => 'p' // Mac dinh giam gia theo %
    );
}

if (empty($row['begin_time'])) {
    $row['begin_time'] = '';
} else {
    $row['begin_time'] = date('d/m/Y', $row['begin_time']);
}

if (empty($row['end_time'])) {
    $row['end_time'] = '';
} else {
    $row['end_time'] = date('d/m/Y', $row['end_time']);
}

// Fetch Limit
$show_view = false;
if (!$nv_Request->isset_request('id', 'post,get')) {
    $show_view = true;
    $per_page = 10;
    $page = $nv_Request->get_int('page', 'post,get', 1);

    $db->sqlreset()->select('COUNT(*)')->from('' . $db_config['prefix'] . '_' . $module_data . '_discounts');
    $sth = $db->prepare($db->sql());
    $sth->execute();
    $num_items = $sth->fetchColumn();

    $db->select('*')->order('add_time DESC')->limit($per_page)->offset(($page - 1) * $per_page);
    $sth = $db->prepare($db->sql());
    $sth->execute();
}

$row['detail_ck'] = $row['detail'] ? 'checked="checked"' : '';

$template = get_tpl_dir([$global_config['module_theme'], $global_config['admin_theme']], 'admin_default', '/modules/' . $module_file . '/discounts.tpl');
$tpl = new \NukeViet\Template\NVSmarty();
$tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $template . '/modules/' . $module_file);

$tpl->assign('LANG', $nv_Lang);
$tpl->assign('NV_BASE_ADMINURL', NV_BASE_ADMINURL);
$tpl->assign('NV_NAME_VARIABLE', NV_NAME_VARIABLE);
$tpl->assign('NV_OP_VARIABLE', NV_OP_VARIABLE);
$tpl->assign('MODULE_NAME', $module_name);
$tpl->assign('OP', $op);
$tpl->assign('ROW', $row);
$tpl->assign('CAPTION', ($row['did']) ? $nv_Lang->getModule('discount_edit') : $nv_Lang->getModule('discount_add'));

if ($show_view) {
    $base_url = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op;
    $generate_page = nv_generate_page($base_url, $num_items, $per_page, $page);
    
    $tpl->assign('GENERATE_PAGE', $generate_page);

    $array_data = [];
    while ($view = $sth->fetch()) {
        $view['begin_time'] = (empty($view['begin_time'])) ? '' : nv_date('d/m/Y', $view['begin_time']);
        $view['end_time'] = (empty($view['end_time'])) ? '' : nv_date('d/m/Y', $view['end_time']);
        $view['detail'] = $view['detail'] ? $nv_Lang->getGlobal('yes') : $nv_Lang->getGlobal('no');
        $view['link_edit'] = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op . '&amp;did=' . $view['did'];
        $view['link_delete'] = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op . '&amp;delete_did=' . $view['did'] . '&amp;delete_checkss=' . md5($view['did'] . NV_CACHE_PREFIX . $client_info['session_id']);

        if (!empty($view['config'])) {
            $config_discount_i = unserialize($view['config']);
            $view['discounts'] = [];
            foreach ($config_discount_i as $discount) {
                if ($discount['discount_unit'] == 'p') {
                    $discount['discount_unit'] = '%';
                } else {
                    $discount['discount_number'] = number_format($discount['discount_number'], nv_get_decimals($pro_config['money_unit']));
                    $discount['discount_unit'] = ' ' . $pro_config['money_unit'];
                }
                $view['discounts'][] = $discount;
            }
        }
        
        if (!empty($view['cateid'])) {
            $view['categories'] = [];
            $cats = explode(',', $view['cateid']);
            foreach ($cats as $catid) {
                $cat = $db->query('SELECT ' . NV_LANG_DATA . '_title as title FROM ' . $db_config['prefix'] . '_' . $module_data . '_catalogs WHERE catid = ' . intval($catid))->fetch();
                if ($cat) {
                    $view['categories'][] = $cat['title'];
                }
            }
        }
        
        $array_data[] = $view;
    }
    $tpl->assign('DATA', $array_data);
}

// Xử lý config_discount
$config_discount[] = array(
    'discount_from' => '',
    'discount_to' => '',
    'discount_number' => '',
    'discount_unit' => 'p'
);

$config_unit = array(
    'p' => $nv_Lang->getModule('coupons_type_percentage'),
    'f' => $nv_Lang->getModule('coupons_type_fixed_amount')
);

$array_config = [];
$i = 0;
foreach ($config_discount as $config) {
    $config['id'] = $i;
    $config['units'] = [];
    foreach ($config_unit as $key => $unit) {
        $config['units'][] = array(
            'key' => $key,
            'value' => $unit,
            'selected' => $config['discount_unit'] == $key ? 'selected="selected"' : ''
        );
    }
    $array_config[] = $config;
    ++$i;
}
$tpl->assign('CONFIG', $array_config);

// Thêm vào phần assign dữ liệu cho template
$tpl->assign('CATALOG_LINK', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=getcatalog&pid=0&cid=' . nv_base64_encode(serialize($row['cateid'])));

$contents = $tpl->fetch('discounts.tpl');

$page_title = $nv_Lang->getModule('discounts');

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
