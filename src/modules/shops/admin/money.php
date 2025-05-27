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

$page_title = $nv_Lang->getModule('money');

/**
 * Format exchange rate number
 * @param float $exchange Exchange rate
 * @return string Formatted exchange rate
 */
function format_exchange($exchange) {
    $exchange = floatval($exchange);
    if (intval($exchange) == $exchange || $exchange > 1000) {
        return number_format($exchange, 0);
    }
    if ($exchange > 1) {
        return number_format($exchange, 5);
    }
    if ($exchange > 0.001) {
        return number_format($exchange, 7);
    }
    if ($exchange > 0.00001) {
        return number_format($exchange, 9);
    }
    return number_format($exchange, 11);
}

/**
 * Format round number
 * @param float $round Round number
 * @return string Formatted round number
 */
function format_round($round) {
    return ($round >= 1) ? number_format($round) : number_format($round, strlen($round) - 2);
}

$currencies_array = nv_parse_ini_file(NV_ROOTDIR . '/includes/ini/currencies.ini', true);

if (!empty($pro_config['money_unit']) != '' and isset($currencies_array[$pro_config['money_unit']])) {
    $page_title .= ' ' . $nv_Lang->getModule('money_compare') . ' ' . $currencies_array[$pro_config['money_unit']]['currency'];
}

$error = '';
$savecat = 0;
$data = array( );

$table_name = $db_config['prefix'] . '_' . $module_data . '_money_' . NV_LANG_DATA;
$savecat = $nv_Request->get_int('savecat', 'post', 0);

$id = $nv_Request->get_int('id', 'get', 0);
if (!empty($savecat)) {
	    $data['id'] = $nv_Request->get_int('id', 'post');
	    $data['code'] = $nv_Request->get_title('code', 'post');
	    $data['currency'] = $nv_Request->get_title('currency', 'post', '', 1);
		$data['symbol'] = $nv_Request->get_title( 'symbol', 'post', '' );
	    $data['exchange'] = $nv_Request->get_title('exchange', 'post,get', 0);
	    $data['exchange'] = floatval(preg_replace('/[^0-9\.]/', '', $data['exchange']));
	    $data['round'] = $nv_Request->get_title('round', 'post,get', 0);
	    $data['round'] = floatval(preg_replace('/[^0-9\.]/', '', $data['round']));
	    $data['dec_point'] = $nv_Request->get_title('dec_point', 'post,get', ',');
	    $data['dec_point'] = preg_replace('/[^\,\.]/', ',', $data['dec_point']);
	    $data['thousands_sep'] = $nv_Request->get_title('thousands_sep', 'post,get', ',');
	    $data['thousands_sep'] = preg_replace('/[^\,\.]/', '.', $data['thousands_sep']);
	    $data['number_format'] = $data['dec_point'] . '||' . $data['thousands_sep'];
		    if (isset($currencies_array[$data['code']])) {
		        $numeric = intval($currencies_array[$data['code']]['numeric']);
		        if (!empty($pro_config['money_unit']) and $pro_config['money_unit'] == $data['code']) {
		            $data['exchange'] = 1;
		        }

		        $data['currency'] = (empty($data['currency'])) ? $currencies_array[$data['code']]['currency'] : $data['currency'];
				$data['symbol'] = (empty($data['symbol'])) ? $currencies_array[$data['code']]['symbol'] : $data['symbol'];
		        if (empty($data['id'])) {
		            $sql = 'INSERT INTO ' . $table_name . ' (id, code, currency,symbol, exchange, round, number_format) VALUES (' . $numeric . ', ' . $db->quote($data['code']) . ', ' . $db->quote($data['currency']) . ', '. $db->quote($data['symbol']) . ', ' . $db->quote($data['exchange']) . ', ' . $db->quote($data['round']) . ', ' . $db->quote($data['number_format']) . ')';
		        } else {
		            $sql = 'UPDATE ' . $table_name . ' SET code = ' . $db->quote($data['code']) . ', currency = ' . $db->quote($data['currency']) .', symbol = ' . $db->quote($data['symbol']) . ', exchange = ' . $db->quote($data['exchange']) . ', round = ' . $db->quote($data['round']) . ', number_format = ' . $db->quote($data['number_format']) . ' WHERE id = ' . $data['id'];
		        }

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
    $data['caption'] = $nv_Lang->getModule('money_edit');
}

if (empty($data)) {
    $data = array();
    $data['id'] = '';
    $data['code'] = '';
    $data['currency'] = '';
    $data['symbol'] = '';
    $data['exchange'] = 0;
    $data['round'] = 0.01;
    $data['dec_point'] = ',';
    $data['thousands_sep'] = '.';
    $data['caption'] = $nv_Lang->getModule('money_add');
} else {
    // Parse number_format
    $number_format = explode('||', $data['number_format']);
    $data['dec_point'] = $number_format[0];
    $data['thousands_sep'] = $number_format[1];
}

$template = get_tpl_dir([$global_config['module_theme'], $global_config['admin_theme']], 'admin_future', '/modules/' . $module_file . '/content.tpl');
$tpl = new \NukeViet\Template\NVSmarty();
$tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $template . '/modules/' . $module_file);
$tpl->registerPlugin('modifier', 'nv_number_format', 'nv_number_format');

// Gán các biến cho template
$tpl->assign('LANG', $nv_Lang);
$tpl->assign('MODULE_NAME', $module_name);
$tpl->assign('OP', $op);
$tpl->assign('MONEY_UNIT', $pro_config['money_unit']);

// Gán lỗi nếu có
if (!empty($error)) {
    $tpl->assign('ERROR', $error);
}

$rows = [];
$array_code_exit = [];
$result = $db->query('SELECT id, code,symbol, currency, exchange, round FROM ' . $table_name . ' ORDER BY code DESC');
while ($row = $result->fetch()) {
    $array_code_exit[] = $row['code'];
    $exchange = floatval($row['exchange']); 
    if (intval($exchange) == $exchange || $exchange > 1000) {
        $exchange = number_format($exchange, 0);
    } elseif ($exchange > 1) {
        $exchange = number_format($exchange, 5);
    } elseif ($exchange > 0.001) {
        $exchange = number_format($exchange, 7);
    } elseif ($exchange > 0.00001) {
        $exchange = number_format($exchange, 9);
    } else {
        $exchange = number_format($exchange, 11);
    }

    $round = ($row['round'] >= 1) ? number_format($row['round']) : number_format($row['round'], strlen($row['round']) - 2);

    $rows[] = [
        'id' => $row['id'],
        'code' => $row['code'],
        'currency' => $row['currency'],
        'symbol' => $row['symbol'],
        'exchange' => $exchange,
        'round' => $round,
        'link_edit' => NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op . '&id=' . $row['id'],
        'link_del' => NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=delmoney&id=' . $row['id']
    ];
}
$tpl->assign('ROWS', $rows);

$tpl->assign('URL_DEL', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=delmoney');
$tpl->assign('URL_DEL_BACK', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op);

$money_options = [];
foreach ($currencies_array as $code => $value) {
    if (!in_array($code, $array_code_exit) or $code == $data['code']) {
        $money_options[] = [
            'value' => $code,
            'title' => $code . ' - ' . $value['currency']. ' - ' .$value['symbol'],
            'selected' => $value['numeric'] == $data['id']
        ];
    }
}
$tpl->assign('MONEY_OPTIONS', $money_options);

$round_options = [];
for ($i = -5; $i < 5; $i++) {
    $round1 = pow(10, $i);
    if ($i < 1) {
        $round1 = $round2 = number_format($round1, - $i);
    } else {
        $round2 = number_format($round1);
    }
    $round_options[] = [
        'round1' => $round1,
        'round2' => $round2,
        'selected' => $round1 == $data['round']
    ];
}
$tpl->assign('ROUND_OPTIONS', $round_options);

$tpl->assign('DATA', $data);
$contents = $tpl->fetch('money.tpl');

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
