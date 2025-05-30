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

$page_title = $nv_Lang->getModule('order_title');
$table_name = $db_config['prefix'] . '_' . $module_data . '_orders';

$order_id = $nv_Request->get_int('order_id', 'post,get', 0);
$db->query('UPDATE ' . $table_name . ' SET order_view = 1 WHERE order_id=' . $order_id);

$save = $nv_Request->get_string('save', 'post', '');

$result = $db->query('SELECT * FROM ' . $table_name . ' WHERE order_id=' . $order_id);
$data_content = $result->fetch();

if (empty($data_content)) {
    nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=order');
}

if ($save == 1 and intval($data_content['transaction_status']) == - 1) {
    $order_id = $nv_Request->get_int('order_id', 'post', 0);
    $transaction_status = 0;
    $payment_id = 0;
    $payment_amount = 0;
    $payment_data = '';
    $payment = '';
    $userid = $admin_info['userid'];

    $transaction_id = $db->insert_id("INSERT INTO " . $db_config['prefix'] . "_" . $module_data . "_transaction (transaction_id, transaction_time, transaction_status, order_id, userid, payment, payment_id, payment_time, payment_amount, payment_data) VALUES (NULL, " . NV_CURRENTTIME . ", '" . $transaction_status . "', '" . $order_id . "', '" . $userid . "', '" . $payment . "', '" . $payment_id . "', " . NV_CURRENTTIME . ", '" . $payment_amount . "', '" . $payment_data . "')");

    if ($transaction_id > 0) {
        $db->query("UPDATE " . $db_config['prefix'] . "_" . $module_data . "_orders SET transaction_status=" . $transaction_status . " , transaction_id = " . $transaction_id . " WHERE order_id=" . $order_id);

        nv_insert_logs(NV_LANG_DATA, $module_name, 'log_process_product', "order_id " . $order_id, $admin_info['userid']);
    }

    $nv_Cache->delMod($module_name);
    nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=order');
}

$link = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=';

// Lấy các mặt hàng trong đơn hàng
$listid = $listnum = $listprice = $listgroup = $slistgroup = [];
$result = $db->query('SELECT * FROM ' . $db_config['prefix'] . '_' . $module_data . '_orders_id WHERE order_id=' . $order_id);
while ($row = $result->fetch()) {
    $listid[] = $row['proid'];
    $listnum[] = $row['num'];
    $listprice[] = $row['price'];

    $result_group = $db->query('SELECT group_id FROM ' . $db_config['prefix'] . '_' . $module_data . '_orders_id_group WHERE order_i=' . $row['id'] . ' ORDER BY group_id');
    $group = [];
    while (list($group_id) = $result_group->fetch(3)) {
        $group[] = $group_id;
    }
    $listgroup[] = $group;
    $slistgroup[] = implode(",", $group);
}

$data_pro = [];

/*
 * Nguyên tắc mỗi sản phẩm có một nhóm, do đó cần lặp mỗi sản phẩm và nhóm theo sản phẩm đó
 * Code hiện tại đang cho lặp nhóm rồi lại lấy tất cả sản phẩm? Dẫn tới nếu sản phẩm không có nhóm thì query như nhau cho ra rất nhiều sản phẩm trùng
 * Không hiểu tại sao ai viết thế
 * Note and fix by hoaquynhtim99
 */
foreach ($listid as $dbkey => $proid) {
    $sql = 'SELECT t1.id, t1.listcatid, t1.product_code, t1.publtime, t1.' . NV_LANG_DATA . '_title,
    t1.' . NV_LANG_DATA . '_alias, t1.product_price,t2.' . NV_LANG_DATA . '_title
    FROM ' . $db_config['prefix'] . '_' . $module_data . '_units AS t2,
    ' . $db_config['prefix'] . '_' . $module_data . '_rows AS t1,
    ' . $db_config['prefix'] . '_' . $module_data . '_orders_id AS t3
    WHERE t1.product_unit = t2.id AND t1.id = t3.proid AND t1.id=' . $proid . '
    AND listgroupid=' . $db->quote($slistgroup[$dbkey]) . ' AND t3.order_id=' . $order_id.'
    AND t1.status =1 AND t1.publtime < ' . NV_CURRENTTIME . '
    AND (t1.exptime=0 OR t1.exptime>' . NV_CURRENTTIME . ')';
    $result = $db->query($sql);

    if ($result->rowCount()) {
        list($id, $_catid, $product_code, $publtime, $title, $alias, $product_price, $unit) = $result->fetch(3);
          $data_pro[] = [
            'id' => $id,
            'publtime' => $publtime,
            'title' => $title,
            'alias' => $alias,
            'product_price' => $listprice[$dbkey],
            'product_price_total' => $listprice[$dbkey] * $listnum[$dbkey],
            'product_code' => $product_code,
            'product_unit' => $unit,
            'link_pro' => $link . $global_array_shops_cat[$_catid]['alias'] . '/' . $alias . $global_config['rewrite_exturl'],
            'product_number' => $listnum[$dbkey],
            'product_group' => isset($listgroup[$dbkey]) ? $listgroup[$dbkey] : ''
        ];
    }
}

// Thong tin van chuyen
$result = $db->query('SELECT * FROM ' . $db_config['prefix'] . '_' . $module_data . '_orders_shipping WHERE order_id = ' . $order_id);
$data_shipping = $result->fetch();

if ($data_content['transaction_status'] == '4') {
    $nv_Lang->setModule('order_submit_pay_comfix', $nv_Lang->getModule('order_submit_unpay_comfix'));
}

$template = get_tpl_dir([$global_config['module_theme'], $global_config['admin_theme']], 'admin_default', '/modules/' . $module_file . '/or_view.tpl');
$tpl = new \NukeViet\Template\NVSmarty();
$tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $template . '/modules/' . $module_file);

// Gán các biến cho template
$tpl->assign('LANG', $nv_Lang);
$tpl->assign('dateup', date('d-m-Y', $data_content['order_time']));
$tpl->assign('moment', date('H:i', $data_content['order_time']));
$tpl->assign('DATA', $data_content);
$tpl->assign('order_id', $data_content['order_id']);
$tpl->assign('payment', $html_payment);

// Trạng thái đơn hàng
$tpl->assign('ORDER_STATUS', array(
    'is_processing' => $data_content['transaction_status'] == -1,
    'is_incomplete' => $data_content['transaction_status'] != 4,
    'is_paid' => $data_content['transaction_status'] == 4
));

// Gán dữ liệu sản phẩm và nhóm sản phẩm
$products = [];
foreach ($data_pro as $pdata) {
    $product = [
        'product_code' => $pdata['product_code'],
        'title' => $pdata['title'],
        'product_number' => $pdata['product_number'],
        'product_price' => number_format($pdata['product_price'], nv_get_decimals($pro_config['money_unit'])),
        'product_price_total' => number_format($pdata['product_price_total'], nv_get_decimals($pro_config['money_unit'])),
        'product_unit' => $pdata['product_unit'],
        'link_pro' => $pdata['link_pro'],
        'product_groups' => []
    ];

    // Xử lý nhóm thuộc tính sản phẩm
    if (!empty($pdata['product_group'])) {
        foreach ($pdata['product_group'] as $groupid) {
            $items = $global_array_group[$groupid];
            $items['parent_title'] = $global_array_group[$items['parentid']]['title'];
            $product['product_groups'][] = $items;
        }
    }
    $products[] = $product;
}
$tpl->assign('DATA_PRO', $products);

// Thông tin vận chuyển
if ($pro_config['use_shipping'] && $data_shipping) {
    $data_shipping['ship_price'] = number_format($data_shipping['ship_price'], nv_get_decimals($data_shipping['ship_price_unit']));
    $data_shipping['ship_location_title'] = $array_location[$data_shipping['ship_location_id']]['title'];
    while ($array_location[$data_shipping['ship_location_id']]['parentid'] > 0) {
        $items = $array_location[$array_location[$data_shipping['ship_location_id']]['parentid']];
        $data_shipping['ship_location_title'] .= ', ' . $items['title'];
        $array_location[$data_shipping['ship_location_id']]['parentid'] = $items['parentid'];
    }
    $data_shipping['ship_shops_title'] = $array_shops[$data_shipping['ship_shops_id']]['name'];
    $tpl->assign('DATA_SHIPPING', $data_shipping);
} else {
    $tpl->assign('order_address', true);
}

if (!empty($data_content['order_note'])) {
    $tpl->assign('order_note', true);
}
$tpl->assign('order_total', number_format($data_content['order_total'], nv_get_decimals($pro_config['money_unit'])));
$tpl->assign('unit', $money_config[$data_content['unit_total']]['symbol']);

// transaction_status: Trang thai giao dich:
// -1 - Giao dich cho duyet
// 0 - Giao dich moi tao
// 1 - Chua thanh toan;
// 2 - Da thanh toan, dang bi tam giu;
// 3 - Giao dich bi huy;
// 4 - Giao dich da hoan thanh thanh cong (truong hop thanh toan ngay hoac thanh toan tam giu nhung nguoi mua da phe chuan)

if ($data_content['transaction_status'] == 4) {
    $html_payment = $nv_Lang->getModule('history_payment_yes');
} elseif ($data_content['transaction_status'] == 3) {
    $html_payment = $nv_Lang->getModule('history_payment_cancel');
} elseif ($data_content['transaction_status'] == 2) {
    $html_payment = $nv_Lang->getModule('history_payment_check');
} elseif ($data_content['transaction_status'] == 1) {
    $html_payment = $nv_Lang->getModule('history_payment_send');
} elseif ($data_content['transaction_status'] == 0) {
    $html_payment = $nv_Lang->getModule('history_payment_no');
} elseif ($data_content['transaction_status'] == - 1) {
    $html_payment = $nv_Lang->getModule('history_payment_wait');
} else {
    $html_payment = 'ERROR';
}

$tpl->assign('payment', $html_payment);

if ($data_content['transaction_status'] == - 1) {
    $tpl->assign('onsubmit', true);
}

$action_pay = '';
if ($data_content['transaction_status'] != '4') {
    $action_pay = '&action=pay';
    $tpl->assign('onpay', true);
} else {
    $nv_Lang->setModule('order_submit_pay_comfix', $nv_Lang->getModule('order_submit_unpay_comfix'));
    $tpl->assign('unpay', true);
    $action_pay = '&action=unpay';
}

$tpl->assign('LINK_PRINT', NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=print&order_id=' . $data_content['order_id'] . '&checkss=' . md5($data_content['order_id'] . $global_config['sitekey'] . session_id()));
$tpl->assign('URL_ACTIVE_PAY', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=active_pay&order_id=' . $order_id . $action_pay);
$tpl->assign('URL_BACK', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=or_view&order_id=' . $order_id);

$array_data_payment = [];

// Cập nhật lại trạng thái đơn hàng từ wallet
if ($nv_Request->isset_request('checkpayment', 'post')) {
    $json = array(
        'status' => 'NOCHANGE',
        'message' => $nv_Lang->getModule('no_update_order')
    );

    $sql = "SELECT * FROM " . $db_config['prefix'] . "_" . $module_data . "_transaction WHERE transaction_id=" . $data_content['transaction_id'];
    $transaction_data = $db->query($sql)->fetch();
    if (!empty($transaction_data) and isset($site_mods['wallet']) and file_exists(NV_ROOTDIR . '/modules/wallet/wallet.class.php')) {
        require_once NV_ROOTDIR . '/modules/wallet/wallet.class.php';
        $wallet = new nukeviet_wallet();

        $data = array(
            'modname' => $module_name, // Module thanh toán
            'id' => $data_content['transaction_id'] // ID đơn hàng
        );
        $checkPayment = $wallet->checkInfoPayment($data);
        if ($checkPayment['status'] == 'SUCCESS') {
            // Chuẩn hóa status theo phong cách của shops
            $nv_transaction_status = 1; // Đang thực hiện giao dịch
            if ($checkPayment['data'][0] == 0) {
                $nv_transaction_status = 1;
            } elseif ($checkPayment['data'][0] == 1) {
                $nv_transaction_status = 1;
            } elseif ($checkPayment['data'][0] == 2) {
                $nv_transaction_status = 2;
            } elseif ($checkPayment['data'][0] == 3) {
                $nv_transaction_status = 3;
            } elseif ($checkPayment['data'][0] == 4) {
                $nv_transaction_status = 4;
            }

            if ($nv_transaction_status != $transaction_data['transaction_status']) {
                $json['status'] = 'CHANGED';
                $json['message'] = $nv_Lang->getModule('update_order');

                // Cập nhật giao dịch
                $check = $db->exec("UPDATE " . $db_config['prefix'] . "_" . $module_data . "_transaction SET
                    transaction_status=" . $nv_transaction_status . ",
                    payment_time=" . $checkPayment['data'][1] . "
                WHERE transaction_id=" . $data_content['transaction_id']);

                // Cập nhật đơn hàng
                $check = $db->exec("UPDATE " . $db_config['prefix'] . "_" . $module_data . "_orders SET
                    transaction_status=" . $nv_transaction_status . ",
                    transaction_id=" . $data_content['transaction_id'] . "
                WHERE order_id=" . $order_id);

                if ($nv_transaction_status == 4) {
                    // Cập nhật điểm tích lũy
                    UpdatePoint($data_content);
                }
                $nv_Cache->delMod($module_name);
            }
        }
    }

    nv_jsonOutput($json);
}

$a = 1;
$array_transaction = [];
$result = $db->query('SELECT * FROM ' . $db_config['prefix'] . '_' . $module_data . '_transaction WHERE order_id=' . $order_id . ' ORDER BY transaction_id ASC');

if ($result->rowCount()) {
    $array_payment = [];
    while ($row = $result->fetch()) {
        $row['a'] = $a++;
        $row['transaction_time'] = nv_date('H:i:s d/m/y', $row['transaction_time']);
        $row['order_id'] = (!empty($row['order_id'])) ? $row['order_id'] : '';
        $row['payment_time'] = (!empty($row['payment_time'])) ? nv_date('H:i:s d/m/y', $row['payment_time']) : '';
        $row['payment_id'] = (!empty($row['payment_id'])) ? $row['payment_id'] : '';

        if (!empty($row['payment_id'])) {
            $array_payment[] = $row['payment_id'];
        }

        $row['payment_amount'] = number_format($row['payment_amount'], nv_get_decimals($pro_config['money_unit']));

        if ($row['transaction_status'] == 4) {
            $row['transaction'] = $nv_Lang->getModule('history_payment_yes');
        } elseif ($row['transaction_status'] == 3) {
            $row['transaction'] = $nv_Lang->getModule('history_payment_cancel');
        } elseif ($row['transaction_status'] == 2) {
            $row['transaction'] = $nv_Lang->getModule('history_payment_check');
        } elseif ($row['transaction_status'] == 1) {
            $row['transaction'] = $nv_Lang->getModule('history_payment_send');
        } elseif ($row['transaction_status'] == 0) {
            $row['transaction'] = $nv_Lang->getModule('history_payment_no');
        } elseif ($row['transaction_status'] == - 1) {
            $row['transaction'] = $nv_Lang->getModule('history_payment_wait');
        } else {
            $row['transaction'] = 'ERROR';
        }
        if ($row['userid'] > 0) {
            $username = $db->query('SELECT username FROM ' . NV_USERS_GLOBALTABLE . ' WHERE userid=' . $row['userid'])->fetchColumn();
            $row['payment'] = $username;
            $row['link_user'] = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=users&' . NV_OP_VARIABLE . '=edit&userid=' . $row['userid'];
        } elseif (isset($array_data_payment[$row['payment']])) {
            $row['link_user'] = $array_data_payment[$row['payment']]['domain'];
            $row['payment'] = $array_data_payment[$row['payment']]['paymentname'];
        } else {
            $row['link_user'] = '#';
        }

        $tpl->assign('DATA_TRANS', $row);
        $tpl->assign('transaction.looptrans', true);
    }

    if (!empty($array_payment) or 1) {
        $tpl->assign('transaction.checkpayment', true);
    }

    $tpl->assign('transaction', true);
}

$tpl->assign('main', true);
$contents = $tpl->fetch('or_view.tpl');

$set_active_op = 'order';

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
