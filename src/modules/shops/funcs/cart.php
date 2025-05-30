<?php

/**
 * @Project NUKEVIET 4.x
 * @Author VINADES.,JSC <contact@vinades.vn>
 * @Copyright (C) 2017 VINADES.,JSC. All rights reserved
 * @License GNU/GPL version 2 or any later version
 * @Createdate 04/18/2017 09:47
 */

if (!defined('NV_IS_MOD_SHOPS')) {
    die('Stop!!!');
}

$order_info = [];
$order_old = [];
$coupons_code = '';
$coupons_check = 0;

if (isset($_SESSION[$module_data . '_coupons']['code']) and isset($_SESSION[$module_data . '_coupons']['check'])) {
    $coupons_code = $_SESSION[$module_data . '_coupons']['code'];
    $coupons_check = $_SESSION[$module_data . '_coupons']['check'];
}
$link = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=';

// Coupons
if ($nv_Request->isset_request('coupons_check', 'post')) {
    $data_content = [];
    $coupons_code = $nv_Request->get_title('coupons_code', 'post', '');
    $contents = $error = '';
    if (empty($coupons_code)) {
        $error = $nv_Lang->getModule('coupons_empty');
    } else {
        $result = $db->query('SELECT * FROM ' . $db_config['prefix'] . '_' . $module_data . '_coupons WHERE code = ' . $db->quote($coupons_code));
        $num = $result->rowCount();
        $data_content = $result->fetch();
        if (empty($data_content)) {
            $error = $nv_Lang->getModule('coupons_no_exist');
        }
    }

    if (empty($error)) {
        $_SESSION[$module_data . '_coupons'] = array(
            'check' => $coupons_check,
            'code' => $coupons_code
        );
    }

    $contents = call_user_func('coupons_info', $data_content, $coupons_check, $error);

    include NV_ROOTDIR . '/includes/header.php';
    echo $contents;
    include NV_ROOTDIR . '/includes/footer.php';
    nv_htmlOutput('');
}

if ($nv_Request->isset_request('coupons_clear', 'post')) {
    unset($_SESSION[$module_data . '_coupons']);
    nv_htmlOutput('');
}
$page_url = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=cart';
$page = 1;
if ($page > 1) {
    $page_url .= '&amp;page-' . $page;
}
$canonicalUrl = getCanonicalUrl($page_url);

// Sửa đơn hàng
if (isset($_SESSION[$module_data . '_order_info']) and !empty($_SESSION[$module_data . '_order_info'])) {
    $order_info = $_SESSION[$module_data . '_order_info'];
    $result = $db->query('SELECT * FROM ' . $db_config['prefix'] . '_' . $module_data . '_orders WHERE order_id=' . $order_info['order_id']);

    if ($result->rowCount() == 0) {
        unset($_SESSION[$module_data . '_order_info']);
        nv_redirect_location(NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name, true);
    }

    if ($_SESSION[$module_data . '_order_info']['checked']) {
        $result = $db->query('SELECT * FROM ' . $db_config['prefix'] . '_' . $module_data . '_orders_id WHERE order_id=' . $order_info['order_id']);

        while ($row = $result->fetch()) {
            $array_group = [];
            $data_content = $db->query("SELECT * FROM " . $db_config['prefix'] . "_" . $module_data . "_rows WHERE id = " . $row['id'])->fetch();
            $result_group = $db->query("SELECT group_id FROM " . $db_config['prefix'] . "_" . $module_data . "_orders_id_group WHERE order_i = " . $row['id']);
            while (list ($group_id) = $result_group->fetch(3)) {
                $array_group[] = $group_id;
            }
            $array_group = !empty($array_group) ? implode(',', $array_group) : '';
            $order_old[$row['proid'] . '_' . $array_group] = array(
                'num' => $row['num'],
                'num_old' => $row['num'],
                'order' => 1,
                'price' => $row['price'],
                'money_unit' => $order_info['money_unit'],
                'group' => $array_group,
                'store' => $data_content['product_number'],
                'weight' => $data_content['product_weight'],
                'weight_unit' => $data_content['weight_unit']
            );
        }

        $shipping_old = [
            'ship_name' => '',
            'ship_phone' => '',
            'ship_location_id' => 0,
            'ship_address_extend' => '',
            'ship_shops_id' => 0,
            'ship_carrier_id' => 0,
            'order_shipping' => 0
        ];

        $result = $db->query('SELECT * FROM ' . $db_config['prefix'] . '_' . $module_data . '_orders_shipping WHERE order_id=' . $order_info['order_id']);
        if ($result->rowCount()) {
            $shipping_old = $result->fetch();
            $shipping_old['order_shipping'] = 1;
        }

        $_SESSION[$module_data . '_order_info']['checked'] = 0;
        $_SESSION[$module_data . '_order_info']['order_product'] = $order_old;
        $_SESSION[$module_data . '_order_info']['shipping'] = $shipping_old;
        $_SESSION[$module_data . '_cart'] = $order_old;
    }
}

if ($nv_Request->get_int('save', 'post', 0) == 1 || $nv_Request->isset_request('update_cart', 'post')) {
    // Set cart to order
    $listproid = $nv_Request->get_array('listproid', 'post', '');
    $coupons_code = $nv_Request->get_title('coupons_code', 'post', '');
    if (!empty($listproid)) {
        foreach ($listproid as $pro_id => $number) {
            if (!empty($_SESSION[$module_data . '_cart'][$pro_id]) and $number >= 0) {
                $_SESSION[$module_data . '_cart'][$pro_id]['num'] = $number;
            }
        }
    }
}

$data_content = [];
$array_error_product_number = [];
$weight_total = 0;

if (!empty($_SESSION[$module_data . '_cart'])) {
    $arrayid = [];
    foreach ($_SESSION[$module_data . '_cart'] as $pro_id => $pro_info) {
        $array = explode('_', $pro_id);
        if (isset($array[1]) and (empty($array[1]) or preg_match('/^[0-9\,]+$/', $array[1]))) {
            $array[0] = intval($array[0]);
            if (empty($array[1]) || !empty($pro_config['active_order_number'])) {
                // Sản phẩm không có nhóm hoặc ứng dụng đã được cấu hình đăng ký không giới hạn số lượng
                $sql = "SELECT t1.id, t1.listcatid, t1.publtime, t1." . NV_LANG_DATA . "_title, t1." . NV_LANG_DATA . "_alias, t1." . NV_LANG_DATA . "_hometext,
                t1.homeimgalt, t1.homeimgfile, t1.homeimgthumb, t1.product_number, t1.product_price, t2." . NV_LANG_DATA . "_title, t1.money_unit, t1.product_weight, t1.weight_unit
                FROM " . $db_config['prefix'] . "_" . $module_data . "_rows AS t1, " . $db_config['prefix'] . "_" . $module_data . "_units AS t2
                WHERE t1.product_unit = t2.id AND t1.id IN ('" . $array[0] . "') AND t1.status =1";
            } else {
                // Sản phẩm có theo nhóm
                $sql = "SELECT t1.id, t1.listcatid, t1.publtime, t1." . NV_LANG_DATA . "_title, t1." . NV_LANG_DATA . "_alias, t1." . NV_LANG_DATA . "_hometext,
                t1.homeimgalt, t1.homeimgfile, t1.homeimgthumb, t1.product_number, t1.product_price, t2." . NV_LANG_DATA . "_title, t1.money_unit, t1.product_weight, t1.weight_unit FROM " . $db_config['prefix'] . "_" . $module_data . "_rows AS t1,
                " . $db_config['prefix'] . "_" . $module_data . "_units AS t2,
                " . $db_config['prefix'] . "_" . $module_data . "_group_quantity t3
                WHERE t1.product_unit = t2.id AND t1.id = t3.pro_id AND  t3.listgroup=" . $db->quote($array[1]) . " AND t1.id IN ('" . $array[0] . "') AND t1.status =1";
            }

            $result = $db->query($sql);

            // Nếu tìm không ra sản phẩm thì loại khỏi session
            if (!$result->rowCount()) {
                unset($_SESSION[$module_data . '_cart'][$pro_id]);
            }

            while (list($id, $listcatid, $publtime, $title, $alias, $hometext, $homeimgalt, $homeimgfile, $homeimgthumb, $product_number, $product_price, $unit, $money_unit, $product_weight, $weight_unit) = $result->fetch(3)) {
                if ($homeimgthumb == 1) {
                    //image thumb
                    $thumb = NV_BASE_SITEURL . NV_FILES_DIR . '/' . $module_upload . '/' . $homeimgfile;
                } elseif ($homeimgthumb == 2) {
                    //image file
                    $thumb = NV_BASE_SITEURL . NV_UPLOADS_DIR . '/' . $module_upload . '/' . $homeimgfile;
                } elseif ($homeimgthumb == 3) {
                    //image url
                    $thumb = $homeimgfile;
                } else {
                    //no image
                    $thumb = NV_STATIC_URL . 'themes/' . $module_info['template'] . '/images/' . $module_file . '/no-image.jpg';
                }

                $group = $_SESSION[$module_data . '_cart'][$id . '_' . $array[1]]['group'];
                $number = $_SESSION[$module_data . '_cart'][$id . '_' . $array[1]]['num'];

                if (!empty($order_info)) {
                    $product_number = $product_number + (isset($_SESSION[$module_data . '_cart'][$id . '_' . $array[1]]['num_old']) ? $_SESSION[$module_data . '_cart'][$id . '_' . $array[1]]['num_old'] : $_SESSION[$module_data . '_cart'][$id . '_' . $array[1]]['num']);
                }

                if (!empty($group) and $pro_config['active_warehouse']) {
                    $group = explode(',', $group);
                    asort($group);
                    $group = implode(',', $group);
                    $product_number = 1;
                    $_result = $db->query('SELECT quantity FROM ' . $db_config['prefix'] . '_' . $module_data . '_group_quantity WHERE pro_id = ' . $id . ' AND listgroup="' . $group . '"');
                    if ($_result->rowCount() > 0) {
                        $product_number = $_result->fetchColumn();
                    }
                }

                if ($number > $product_number and $number > 0 and empty($pro_config['active_order_number'])) {
                    $number = $_SESSION[$module_data . '_cart'][$id . '_' . $array[1]]['num'] = $product_number;
                    $array_error_product_number[] = sprintf($nv_Lang->getModule('product_number_max'), $title, $product_number);
                }

                if ($pro_config['active_price'] == '0') {
                    $product_price = 0;
                }

                $data_content[] = array(
                    'id' => $id,
                    'listcatid' => $listcatid,
                    'publtime' => $publtime,
                    'title' => $title,
                    'alias' => $alias,
                    'hometext' => $hometext,
                    'homeimgalt' => $homeimgalt,
                    'homeimgthumb' => $thumb,
                    'product_price' => $product_price,
                    'product_unit' => $unit,
                    'money_unit' => $money_unit,
                    'group' => $group,
                    'link_pro' => $link . $global_array_shops_cat[$listcatid]['alias'] . '/' . $alias . $global_config['rewrite_exturl'],
                    'num' => $number,
                    'link_remove' => $link . 'remove&id=' . $id . '&group=' . $group,
                );

                $weight_total += nv_weight_conversion($product_weight, $weight_unit, $pro_config['weight_unit'], $number);
                $_SESSION[$module_data . '_cart'][$id . '_' . $array[1]]['order'] = 1;
            }
            if (empty($array_error_product_number) and $nv_Request->isset_request('cart_order', 'post')) {
                nv_htmlOutput(1);

                // nv_redirect_location(NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=order', true);
            }
        }
    }
} else {
    nv_redirect_location(NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name, true);
}

if (empty($data_content)) {
    nv_redirect_location(NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name, true);
}

$page_title = $nv_Lang->getModule('cart_title');

$data_order = [
    'user_id' => isset($user_info['userid']) ? $user_info['userid'] : 0,
    'order_name' => isset($user_info['full_name']) ? $user_info['full_name'] : '',
    'order_email' => isset($user_info['email']) ? $user_info['email'] : '',
    'order_phone' => '',
    'order_note' => '',
    'admin_id' => 0,
    'shop_id' => 0,
    'who_is' => 0,
    'unit_total' => $pro_config['money_unit'],
    'order_total' => 0,
    'order_time' => NV_CURRENTTIME,
    'order_shipping' => 0,
    'shipping' => [
        'ship_name' => '',
        'ship_phone' => '',
        'ship_location_id' => 0,
        'ship_address_extend' => '',
        'ship_shops_id' => 0,
        'ship_carrier_id' => 0,
        'weight' => 0,
        'weight_unit' => 'g'
    ]
];

// Lấy thông tin đặt hàng đã điền ở SESSION trước đó
if (isset($_SESSION[$module_data . '_order_info']) and ! empty($_SESSION[$module_data . '_order_info'])) {
    $order_info = $_SESSION[$module_data . '_order_info'];
    $data_order = [
        'order_name' => $order_info['order_name'],
        'order_email' => $order_info['order_email'],
        'order_address' => $order_info['order_address'],
        'order_phone' => $order_info['order_phone'],
        'order_note' => $order_info['order_note'],
        'unit_total' => $order_info['unit_total'],
        'order_shipping' => $order_info['shipping']['order_shipping'],
        'shipping' => $order_info['shipping']
    ];
}

// Lay dia diem
$sql = "SELECT id, parentid, title, lev FROM " . $db_config['prefix'] . '_' . $module_data . "_location ORDER BY sort ASC";
$result = $db->query($sql);
while (list ($id_i, $parentid_i, $title_i, $lev_i) = $result->fetch(3)) {
    $xtitle_i = '';
    if ($lev_i > 0) {
        $xtitle_i .= '&nbsp;';
        for ($i = 1; $i <= $lev_i; $i ++) {
            $xtitle_i .= '&nbsp;&nbsp;&nbsp;';
        }
    }
    $xtitle_i .= $title_i;
    $shipping_data['list_location'][$id_i] = [
        'id' => $id_i,
        'parentid' => $parentid_i,
        'title' => $xtitle_i
    ];
}
$shipping_data['list_carrier'] = $array_carrier;
$shipping_data['list_shops'] = $array_shops;
$data_order['weight_total'] = $weight_total;

$contents = call_user_func('cart_product', $data_content, $coupons_code, $order_info, $array_error_product_number, $data_order, $shipping_data);

include NV_ROOTDIR . '/includes/header.php';
echo nv_site_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
