<?php

/**
 * @Project NUKEVIET 4.x
 * @Author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2017 VINADES.,JSC. All rights reserved
 * @License GNU/GPL version 2 or any later version
 * @Createdate 04/18/2017 09:47
 */

if (! defined('NV_IS_FILE_ADMIN')) {
    die('Stop!!!');
}

$page_title = $nv_Lang->getModule('document_payment');

if (defined('NV_EDITOR')) {
    require_once NV_ROOTDIR . '/' . NV_EDITORSDIR . '/' . NV_EDITOR . '/nv.php';
}

$content_docpay_file = NV_ROOTDIR . '/' . NV_DATADIR . '/' . NV_LANG_DATA . '_' . $module_data . '_docpay_content.txt';
$content_order_file = NV_ROOTDIR . '/' . NV_DATADIR . '/' . NV_LANG_DATA . '_' . $module_data . '_order_content.txt';
$content_order_payment_file = NV_ROOTDIR . '/' . NV_DATADIR . '/' . NV_LANG_DATA . '_' . $module_data . '_order_payment_content.txt';
$content_docpay = '';
$content_order = '';
$content_order_payment = '';

if (file_exists($content_docpay_file)) {
    $content_docpay = file_get_contents($content_docpay_file);
}

if (file_exists($content_order_file)) {
    $content_order = file_get_contents($content_order_file);
    if (empty($content_order)) {
        require_once NV_ROOTDIR . '/modules/' . $module_file . '/language/' . NV_LANG_DATA . '.php';
        $content_order = $nv_Lang->getModule('order_payment_email');
    }
} else {
    require_once NV_ROOTDIR . '/modules/' . $module_file . '/language/' . NV_LANG_DATA . '.php';
    $content_order = $nv_Lang->getModule('order_payment_email');
}

if (file_exists($content_order_payment_file)) {
    $content_order_payment = file_get_contents($content_order_payment_file);
    if (empty($content_order_payment)) {
        $content_order_payment = $nv_Lang->getModule('order_email_payment');
    }
} else {
    $content_order_payment = $nv_Lang->getModule('order_email_payment');
}

if ($nv_Request->get_int('saveintro', 'post', 0) == 1) {
    $content_docpay = $nv_Request->get_string('content_docpay', 'post', '');
    $content_order = $nv_Request->get_string('content_order', 'post', '');
    $content_order_payment = $nv_Request->get_string('content_order_payment', 'post', '');

    if (defined('NV_EDITOR')) {
        $content_docpay = nv_nl2br($content_docpay, '');
        $content_order = nv_nl2br($content_order, '');
        $content_order_payment = nv_nl2br($content_order_payment, '');
    } else {
        $content_docpay = nv_nl2br(nv_htmlspecialchars(strip_tags($content_docpay)), '<br />');
        $content_order = nv_nl2br(nv_htmlspecialchars(strip_tags($content_order)), '<br />');
        $content_order_payment = nv_nl2br(nv_htmlspecialchars(strip_tags($content_order_payment)), '<br />');
    }
    file_put_contents($content_docpay_file, $content_docpay);
    file_put_contents($content_order_file, $content_order);
    file_put_contents($content_order_payment_file, $content_order_payment);
}

$content_docpay = htmlspecialchars(nv_editor_br2nl($content_docpay));
if (defined('NV_EDITOR') and function_exists('nv_aleditor')) {
    $content_docpay_edits = nv_aleditor('content_docpay', '100%', '300px', $content_docpay);
} else {
    $content_docpay_edits = "<textarea style=\"width: 100%\" name=\"content_docpay\" id=\"content_docpay\" cols=\"20\" rows=\"15\">" . $content_docpay . "</textarea>";
}

$content_order = htmlspecialchars(nv_editor_br2nl($content_order));
if (defined('NV_EDITOR') and function_exists('nv_aleditor')) {
    $content_order_edits = nv_aleditor('content_order', '100%', '300px', $content_order);
} else {
    $content_order_edits = "<textarea style=\"width: 100%\" name=\"content_order\" id=\"content_order\" cols=\"20\" rows=\"15\">" . $content_order . "</textarea>";
}

$content_order_payment = htmlspecialchars(nv_editor_br2nl($content_order_payment));
if (defined('NV_EDITOR') and function_exists('nv_aleditor')) {
    $content_order_payment_edits = nv_aleditor('content_order_payment', '100%', '300px', $content_order_payment);
} else {
    $content_order_payment_edits = "<textarea style=\"width: 100%\" name=\"content_order_payment\" id=\"content_order_payment\" cols=\"20\" rows=\"15\">" . $content_order_payment . "</textarea>";
}

$replace_order = array(
    'order_code' => $nv_Lang->getModule('order_code'),
    'order_name' => $nv_Lang->getModule('order_name'),
    'order_email' => $nv_Lang->getModule('order_email'),
    'order_phone' => $nv_Lang->getModule('order_phone'),
    'order_address' => $nv_Lang->getModule('order_address'),
    'order_note' => $nv_Lang->getModule('order_note'),
    'order_total' => $nv_Lang->getModule('order_total'),
    'unit_total' => $nv_Lang->getModule('unit_total'),
    'dateup' => $nv_Lang->getModule('dateup'),
    'moment' => $nv_Lang->getModule('moment'),
    'review_url' => $nv_Lang->getModule('review_url'),
    'table_product' => $nv_Lang->getModule('table_product'),
    'site_url' => $nv_Lang->getModule('site_url'),
    'site_name' => $nv_Lang->getModule('site_name'),
);
$template = get_tpl_dir([$global_config['module_theme'], $global_config['admin_theme']], 'admin_future', '/modules/' . $module_file . '/content.tpl');
$tpl = new \NukeViet\Template\NVSmarty();
$tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $template . '/modules/' . $module_file);

$tpl->assign('LANG', $nv_Lang);
$tpl->assign('MODULE_NAME', $module_name);
$tpl->assign('OP', $op);
$tpl->assign('CONTENT_DOCPAY', $content_docpay_edits);
$tpl->assign('CONTENT_ORDER', $content_order_edits);
$tpl->assign('CONTENT_ORDER_PAYMENT', $content_order_payment_edits);

$order_vars = [];
foreach ($replace_order as $key => $value) {
    $order_vars[] = array(
        'key' => $key,
        'value' => $value
    );
}
$tpl->assign('ORDER_VARS', $order_vars);

$contents = $tpl->fetch('docpay.tpl');

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
