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

$page_title = $nv_Lang->getModule('content_list');

// Khởi tạo các biến tìm kiếm
$stype = $nv_Request->get_string('stype', 'get', '-');
$catid = $nv_Request->get_int('catid', 'get', 0);
$from_time = $nv_Request->get_string('from', 'get', '');
$to_time = $nv_Request->get_string('to', 'get', '');
$per_page_old = $nv_Request->get_int('per_page', 'cookie', 50);
$per_page = $nv_Request->get_int('per_page', 'get', $per_page_old);

if ($per_page < 1 and $per_page > 500) {
    $per_page = 50;
}

if ($nv_Request->isset_request('action', 'post')) {
    $action = $nv_Request->get_string('action', 'post', '');
    $listid = $nv_Request->get_string('listid', 'post', '');
    

    if ($listid != "" and md5($global_config['sitekey'] . session_id()) == $checkss) {
        if ($action == 'delete') {
            $del_array = array_map("intval", explode(",", $listid));
            foreach ($del_array as $id) {
                if ($id > 0) {
                    $contents = nv_del_content_module($id);
                }
            }
            nv_insert_logs(NV_LANG_DATA, $module_name, 'log_del_product', "id " . $listid, $admin_info['userid']);
            nv_jsonOutput([
                'status' => 'OK',
                'message' => $nv_Lang->getModule('product_del_success')
            ]);
        } 
    } else {
        nv_jsonOutput([
            'status' => 'error',
            'message' => $nv_Lang->getModule('product_del_error')
        ]);
    }
}

if ($per_page_old != $per_page) {
    $nv_Request->set_Cookie('per_page', $per_page, NV_LIVE_COOKIE_TIME);
}

$q = $nv_Request->get_title('q', 'get', '');
$q = str_replace('+', ' ', $q);
$q = nv_substr($q, 0, NV_MAX_SEARCH_LENGTH);
$qhtml = nv_htmlspecialchars($q);
$ordername = $nv_Request->get_string('ordername', 'get', 'publtime');
$order = $nv_Request->get_string('order', 'get', 'desc');
$order = ($order == 'asc') ? 'asc' : ($order == 'desc' ? 'desc' : 'desc');

// Xây dựng URL cơ sở
$base_url = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op;
$base_url_params = [];

if (!empty($q)) {
    $base_url_params[] = 'q=' . urlencode($q);
}
if ($stype != '-') {
    $base_url_params[] = 'stype=' . $stype;
}
if ($catid > 0) {
    $base_url_params[] = 'catid=' . $catid;
}
if (!empty($from_time)) {
    $base_url_params[] = 'from=' . $from_time;
}
if (!empty($to_time)) {
    $base_url_params[] = 'to=' . $to_time;
}
if ($per_page != 50) {
    $base_url_params[] = 'per_page=' . $per_page;
}
if (!empty($base_url_params)) {
    $base_url .= '&amp;' . implode('&amp;', $base_url_params);
}
$base_url .= '&amp;checkss=' . NV_CHECK_SESSION;

// List pro_unit
$array_unit = array();
$sql = 'SELECT id, ' . NV_LANG_DATA . '_title FROM ' . $db_config['prefix'] . '_' . $module_data . '_units';
$result_unit = $db->query($sql);
if ($result_unit->rowCount() == 0) {
    nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=prounit');
} else {
    while ($row = $result_unit->fetch()) {
        $array_unit[$row['id']] = $row;
    }
}

$listcatid = $nv_Request -> get_int('listcatid', 'get');
$where = '';
if (! empty($listcatid)) {
    if (isset($global_array_shops_cat[ $listcatid ])) {
        $subcatid = $global_array_shops_cat[ $listcatid ]['subcatid'];
        $where = 'listcatid=' . $listcatid;
        if ($subcatid != 0) {
            $where .= ' or listcatid IN (' . $subcatid . ')';
        }
    }
}

$array_search = array(
    'product_code' => $nv_Lang->getModule('search_product_code'),
    'title' => $nv_Lang->getModule('search_title'),
    'bodytext' => $nv_Lang->getModule('search_bodytext'),
    'author' => $nv_Lang->getModule('search_author'),
    'admin_id' => $nv_Lang->getModule('search_admin')
);
$array_in_rows = array(
    'title',
    'bodytext'
);
$array_in_ordername = array(
    'title' => 1,
    'publtime' => 1,
    'exptime' => 1,
    'hitstotal' => 1,
    'product_number' => 1,
    'num_sell' => 1
);

if (!in_array($stype, array_keys($array_search))) {
    $stype = '-';
}
if (!isset($array_in_ordername[$ordername])) {
    $ordername = 'id';
}

$from = $db_config['prefix'] . '_' . $module_data . '_rows AS a LEFT JOIN ' . NV_USERS_GLOBALTABLE . ' AS b ON a.user_id=b.userid';

$page = $nv_Request->get_int('page', 'get', 1);

// Tim theo tu khoa
if ($stype == 'product_code') {
    $from .= " WHERE product_code LIKE '%" . $db->dblikeescape($q) . "%' ";
} elseif (in_array($stype, $array_in_rows) and !empty($q)) {
    $from .= " WHERE " . NV_LANG_DATA . "_" . $stype . " LIKE '%" . $db->dblikeescape($qhtml) . "%' ";
} elseif ($stype == 'admin_id' and !empty($q)) {
    $sql = "SELECT userid FROM " . NV_USERS_GLOBALTABLE . " WHERE userid IN (SELECT admin_id FROM " . NV_AUTHORS_GLOBALTABLE . ") AND username LIKE '%" . $db->dblikeescape($q) . "%' OR first_name LIKE '%" . $db->dblikeescape($q) . "%' OR last_name LIKE '%" . $db->dblikeescape($q) . "%'";
    $result = $db->query($sql);
    $array_admin_id = array();
    while (list($admin_id) = $result->fetch(3)) {
        $array_admin_id[] = $admin_id;
    }
    $from .= " WHERE admin_id IN (0," . implode(",", $array_admin_id) . ",0)";
} elseif (!empty($q)) {
    $sql = "SELECT userid FROM " . NV_USERS_GLOBALTABLE . " WHERE userid IN (SELECT admin_id FROM " . NV_AUTHORS_GLOBALTABLE . ") AND username LIKE '%" . $db->dblikeescape($q) . "%' OR first_name LIKE '%" . $db->dblikeescape($q) . "%'OR last_name LIKE '%" . $db->dblikeescape($q) . "%'";
    $result = $db->query($sql);

    $array_admin_id = array();
    while (list($admin_id) = $result->fetch(3)) {
        $array_admin_id[] = $admin_id;
    }

    $arr_from = array();
    $arr_from[] = "(product_code LIKE '%" . $db->dblikeescape($qhtml) . "%')";
    foreach ($array_in_rows as $val) {
        $arr_from[] = "(" . NV_LANG_DATA . "_" . $val . " LIKE '%" . $db->dblikeescape($qhtml) . "%')";
    }
    $from .= " WHERE ( " . implode(" OR ", $arr_from);
    if (!empty($array_admin_id)) {
        $from .= ' OR (admin_id IN (0,' . implode(',', $array_admin_id) . ',0))';
    }
    $from .= ' )';
}

// Tim theo loai san pham
if (!empty($catid)) {
    if (empty($q)) {
        $from .= ' WHERE';
    } else {
        $from .= ' AND';
    }

    if ($global_array_shops_cat[$catid]['numsubcat'] == 0) {
        $from .= ' listcatid=' . $catid;
    } else {
        $array_cat = array();
        $array_cat = GetCatidInParent($catid);
        $from .= ' listcatid IN (' . implode(',', $array_cat) . ')';
    }
}

// Tim theo ngay thang
if (!empty($from_time)) {
    if (empty($q) and empty($catid)) {
        $from .= ' WHERE';
    } else {
        $from .= ' AND';
    }

    if (!empty($from_time) and preg_match('/^([0-9]{1,2})\/([0-9]{1,2})\/([0-9]{4})$/', $from_time, $m)) {
        $time = mktime(0, 0, 0, $m[2], $m[1], $m[3]);
    } else {
        $time = NV_CURRENTTIME;
    }

    $from .= ' publtime >= ' . $time . '';
}

if (!empty($to_time)) {
    if (empty($q) and empty($catid) and empty($from_time)) {
        $from .= ' WHERE';
    } else {
        $from .= ' AND';
    }

    if (!empty($to_time) and preg_match('/^([0-9]{1,2})\/([0-9]{1,2})\/([0-9]{4})$/', $to_time, $m)) {
        $to = mktime(23, 59, 59, $m[2], $m[1], $m[3]);
    } else {
        $to = NV_CURRENTTIME;
    }
    $from .= ' publtime <= ' . $to . '';
}

if (!empty($where)) {
    if (strpos($from, 'WHERE') === false) {
        $from .= ' WHERE ' . $where;
    } else {
        $from .= ' AND ' . $where;
    }
}

$num_items = $db->query('SELECT COUNT(*) FROM ' . $from)->fetchColumn();

$template = get_tpl_dir([$global_config['module_theme'], $global_config['admin_theme']], 'admin_default', '/modules/' . $module_file . '/items.tpl');
$tpl = new \NukeViet\Template\NVSmarty();
$tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $template . '/modules/' . $module_file);
$tpl->assign('LANG', $nv_Lang);
$tpl->assign('MODULE_NAME', $module_name);
$tpl->assign('OP', $op);

// Loai san pham
$search_cat = [];
foreach ($global_array_shops_cat as $cat) {
    if ($cat['catid'] > 0) {
        $xtitle_i = '';
        if ($cat['lev'] > 0) {
            $xtitle_i .= '&nbsp;&nbsp;&nbsp;|';
            for ($i = 1; $i <= $cat['lev']; ++$i) {
                $xtitle_i .= '---';
            }
            $xtitle_i .= '>&nbsp;';
        }
        $xtitle_i .= $cat['title'];
        $cat['title'] = $xtitle_i;

        $cat['selected'] = $cat['catid'] == $catid ? ' selected="selected"' : '';
        $search_cat[] = $cat;
    }
}
$tpl->assign('SEARCH_CAT', $search_cat);

// Kieu tim kiem
$search_type = [];
foreach ($array_search as $key => $val) {
    $search_type[$key] = $val;
}
$tpl->assign('SEARCH_TYPE', $search_type);
$tpl->assign('SEARCH', [
    'stype' => $stype,
    'q' => $q,
    'catid' => $catid,
    'from' => $from_time,
    'to' => $to_time
]);

$tpl->assign('PER_PAGE', $per_page);

// Thay thế các parse() bằng assign() cho các biến điều kiện sắp xếp
$tpl->assign('ARRAY_ORDER', [
    'field' => $ordername,
    'value' => $order
]);

// Tạo URL cơ sở cho các cột sắp xếp
$base_url_name = $base_url . '&amp;ordername=title&amp;order=' . ($ordername == 'title' ? ($order == 'desc' ? 'asc' : 'desc') : 'desc');
$base_url_publtime = $base_url . '&amp;ordername=publtime&amp;order=' . ($ordername == 'publtime' ? ($order == 'desc' ? 'asc' : 'desc') : 'desc');
$base_url_hitstotal = $base_url . '&amp;ordername=hitstotal&amp;order=' . ($ordername == 'hitstotal' ? ($order == 'desc' ? 'asc' : 'desc') : 'desc');
$base_url_product_number = $base_url . '&amp;ordername=product_number&amp;order=' . ($ordername == 'product_number' ? ($order == 'desc' ? 'asc' : 'desc') : 'desc');
$base_url_num_sell = $base_url . '&amp;ordername=num_sell&amp;order=' . ($ordername == 'num_sell' ? ($order == 'desc' ? 'asc' : 'desc') : 'desc');

// Assign các biến khác
$tpl->assign('BASE_URL_NAME', $base_url_name);
$tpl->assign('BASE_URL_PUBLTIME', $base_url_publtime);
$tpl->assign('BASE_URL_HITSTOTAL', $base_url_hitstotal);
$tpl->assign('BASE_URL_PNUMBER', $base_url_product_number);
$tpl->assign('BASE_URL_NUM_SELL', $base_url_num_sell);

$ord_sql = ($ordername == 'title' ? NV_LANG_DATA . '_title' : $ordername) . ' ' . $order;
$db->sqlreset()
    ->select('a.id, a.listcatid, a.user_id, a.homeimgfile, a.homeimgthumb, ' . NV_LANG_DATA . '_title, ' . NV_LANG_DATA . '_alias, a.hitstotal, a.status, a.edittime, a.publtime, a.exptime, a.product_number, a.money_unit, a.product_unit, a.num_sell, a.discount_id, a.product_price')
    ->from($db_config['prefix'] . '_' . $module_data . '_rows AS a')
    ->order($ord_sql);

$result = $db->query($db->sql());

$theme = $site_mods[$module_name]['theme'] ? $site_mods[$module_name]['theme'] : $global_config['site_theme'];
$a = 0;
$array_data = [];

while (list($id, $listcatid, $admin_id, $homeimgfile, $homeimgthumb, $title, $alias, $hitstotal, $status, $edittime, $publtime, $exptime, $product_number, $money_unit, $product_unit, $num_sell, $discount_id, $product_price) = $result->fetch(3)) {
    $publtime = nv_date('H:i d/m/y', $publtime);
    $edittime = nv_date('H:i d/m/y', $edittime);
    $title = nv_clean60($title);
    // Tính toán giảm giá nếu có
    $discount_amount = 0;
    $discount_percent = 0;
    $final_price = $product_price;
    if (!empty($discount_id)) {
        // Lấy thông tin giảm giá từ bảng discount
        $discount = $db->query('SELECT config FROM ' . $db_config['prefix'] . '_' . $module_data . '_discounts WHERE did = ' . $discount_id)->fetchColumn();
        if (!empty($discount)) {
            $discount_config = unserialize($discount);
            if (!empty($discount_config)) {
                // Duyệt qua từng khoảng giảm giá
                foreach ($discount_config as $dc) {
                    if ($num_sell == 0 || ($num_sell >= $dc['discount_from'] && $num_sell <= $dc['discount_to'])) {
                        if ($dc['discount_unit'] == 'p') {
                            // Giảm giá theo phần trăm
                            $discount_percent = $dc['discount_number'];
                            $discount_amount = ($product_price * $discount_percent) / 100;
                        } else {
                            $discount_amount = $dc['discount_number'];
                            $discount_percent = round(($discount_amount / $product_price) * 100, 2);
                        }
                        // Đảm bảo giá sau giảm không âm
                        $discount_amount = min($discount_amount, $product_price);
                        $final_price = max(0, $product_price - $discount_amount);
                        break;
                    }
                }
            }
        }
    }

    $catid_i = 0;
    if ($catid > 0) {
        $catid_i = $catid;
    } else {
        $catid_i = $listcatid;
    }

    // Xac dinh anh nho
    if ($homeimgthumb == 1) {
        //image thumb
        $thumb = NV_BASE_SITEURL . NV_FILES_DIR . '/' . $module_upload . '/' . $homeimgfile;
        $imghome = NV_BASE_SITEURL . NV_UPLOADS_DIR . '/' . $module_upload . '/' . $homeimgfile;
    } elseif ($homeimgthumb == 2) {
        //image file
        $imghome = $thumb = NV_BASE_SITEURL . NV_UPLOADS_DIR . '/' . $module_upload . '/' . $homeimgfile;
    } elseif ($homeimgthumb == 3) {
        //image url
        $imghome = $thumb = $homeimgfile;
    } elseif (file_exists(NV_ROOTDIR . '/themes/' . $theme . '/images/' . $module_file . '/no-image.jpg')) {
        $imghome = $thumb = NV_STATIC_URL . 'themes/' . $theme . '/images/' . $module_file . '/no-image.jpg';
    } else {
        $imghome = $thumb = NV_STATIC_URL . 'themes/default/images/' . $module_file . '/no-image.jpg';
    }

    $array_data[] = array(
        'id' => $id,
        'link' => NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $global_array_shops_cat[$catid_i]['alias'] . '/' . $alias . $global_config['rewrite_exturl'],
        'link_seller' => NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=seller&amp;pro_id=' . $id . '&amp;nv_redirect=' . nv_redirect_encrypt(str_replace('&amp;', '&', $base_url)),
        'link_copy' => NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=content&amp;copy=1&amp;id=' . $id,
        'link_warehouse' => NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=warehouse&amp;listid=' . $id . '&amp;checkss=' . md5($global_config['sitekey'] . session_id()),
        'title' => $title,
        'publtime' => $publtime,
        'edittime' => $edittime,
        'hitstotal' => (float)$hitstotal,
        'num_sell' => (float)$num_sell,
        'product_unit' => isset($array_unit[$product_unit]) ? $array_unit[$product_unit][NV_LANG_DATA . '_title'] : '',
        'status' => $nv_Lang->existsModule('status_' . $status) ? $nv_Lang->getModule('status_' . $status) : '',
        'admin_id' => !empty($admin_id) ? $admin_id : '',
        'product_number' => (float)$product_number,
        'product_price' => (float)$product_price,
        'discount_amount' => (float)$discount_amount,
        'discount_percent' => (float)$discount_percent,
        'discount_unit' => isset($dc['discount_unit']) ? $dc['discount_unit'] : '',
        'discount_from' => isset($dc['discount_from']) ? (int)$dc['discount_from'] : 0,
        'discount_to' => isset($dc['discount_to']) ? (int)$dc['discount_to'] : 0,
        'final_price' => (float)$final_price,
        'money_unit' => $money_unit,
        'thumb' => $thumb,
        'imghome' => $imghome,
        'imghome_info' => nv_is_image(NV_ROOTDIR . '/' . $imghome),
        'link_edit' => nv_link_edit_page($id),
        'link_delete' => nv_link_delete_page($id),
        'has_seller' => ($num_sell > 0),
        'show_warehouse' => $pro_config['active_warehouse']
    );

    ++$a;
}

$tpl->assign('DATA', $array_data);

$array_list_action = array(
    'delete' => $nv_Lang->getGlobal('delete'),
    'publtime' => $nv_Lang->getModule('publtime'),
    'exptime' => $nv_Lang->getModule('exptime'),
    'addtoblock' => $nv_Lang->getModule('addtoblock')
);

if ($pro_config['active_warehouse']) {
    $array_list_action['warehouse'] = $nv_Lang->getModule('warehouse');
}

// Assign các action
$actions = [];
foreach ($array_list_action as $key => $title) {
    $actions[] = [
        'key' => $key,
        'title' => $title  
    ];
}
$tpl->assign('ACTIONS', $actions);

// Assign các biến khác
$tpl->assign('CHECKSESS', md5(session_id()));
$tpl->assign('ACTION_CHECKSESS', md5($global_config['sitekey'] . session_id()));

$generate_page = nv_generate_page($base_url, $num_items, $per_page, $page);
$tpl->assign('GENERATE_PAGE', $generate_page);

$tpl->assign('WAREHOUSE_ACTIVE', $pro_config['active_warehouse']);

$contents = $tpl->fetch('items.tpl');

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
