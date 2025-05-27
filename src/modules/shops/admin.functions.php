<?php

/**
 * @Project NUKEVIET 4.x
 * @Author VINADES.,JSC <contact@vinades.vn>
 * @Copyright (C) 2017 VINADES.,JSC. All rights reserved
 * @License GNU/GPL version 2 or any later version
 * @Createdate 04/18/2017 09:47
 */
if (!defined('NV_ADMIN') or !defined('NV_MAINFILE') or !defined('NV_IS_MODADMIN')) {
    die('Stop!!!');
}

$allow_func = array(
    'main',
    'alias',
    'items',
    'exptime',
    'publtime',
    'setting',
    'content',
    'custom_form',
    'keywords',
    'del_content',
    'cat',
    'change_cat',
    'list_cat',
    'del_cat',
    'block',
    'blockcat',
    'del_block_cat',
    'list_block_cat',
    'chang_block_cat',
    'change_block',
    'list_block',
    'prounit',
    'delunit',
    'order',
    'or_del',
    'or_view',
    'money',
    'delmoney',
    'group',
    'del_group',
    'list_group',
    'change_group',
    'getcatalog',
    'getgroup',
    'discounts',
    'view',
    'tags',
    'tagsajax',
    'seller',
    'copy_product',
    'order_seller',
    'coupons',
    'coupons_view',
    'point',
    'weight',
    'delweight',
    'location',
    'change_location',
    'list_location',
    'del_location',
    'carrier',
    'carrier_config',
    'carrier_config_items',
    'shipping',
    'shops',
    'getprice',
    'review',
    'warehouse',
    'warehouse_logs',
    'download',
    'updateprice',
    'guarantee',
    'import',
    'suppliers',
);

if (defined('NV_IS_SPADMIN')) {
    $allow_func[] = 'setting';
    $allow_func[] = 'fields';
    $allow_func[] = 'tabs';
    $allow_func[] = 'field_tab';
    $allow_func[] = 'template';
    $allow_func[] = 'detemplate';
    $allow_func[] = 'active_pay';
    $allow_func[] = 'docpay';
}

$array_viewcat_full = array(
    'view_home_cat' => $nv_Lang->getModule('view_home_cat'),
    'viewlist' => $nv_Lang->getModule('viewcat_page_list'),
    'viewgrid' => $nv_Lang->getModule('viewcat_page_gird')
);
$array_viewcat_nosub = array(
    'viewlist' => $nv_Lang->getModule('viewcat_page_list'),
    'viewgrid' => $nv_Lang->getModule('viewcat_page_gird')
);

// Tài liệu hướng dẫn
$array_url_instruction['carrier_config_items'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:shipping_config';
$array_url_instruction['carrier_config'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:shipping_config';
$array_url_instruction['carrier'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:shipping_config';
$array_url_instruction['shops'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:shipping_config';
$array_url_instruction['shipping_config'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:shipping_config';
$array_url_instruction['shipping'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:shipping';

$array_url_instruction['coupons'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:coupons';
$array_url_instruction['coupons_view'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:coupons';

$array_url_instruction['template'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:template';
$array_url_instruction['template'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:template';

$array_url_instruction['warehouse'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:warehouse';
$array_url_instruction['warehouse_logs'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:warehouse';

$array_url_instruction['order'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:order';
$array_url_instruction['order_view'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:order';

$array_url_instruction['content'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:content';
$array_url_instruction['cat'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:cat';
$array_url_instruction['discount'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:discount';
$array_url_instruction['docpay'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:docpay';
$array_url_instruction['download'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:download';
$array_url_instruction['group'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:group';
$array_url_instruction['items'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:list';
$array_url_instruction['money'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:money';
$array_url_instruction['point'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:point';
$array_url_instruction['unit'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:unit';
$array_url_instruction['review'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:review';
$array_url_instruction['setting'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:setting';
$array_url_instruction['tabs'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:tabs';
$array_url_instruction['tags'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:tags';
$array_url_instruction['weight'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:weight';
$array_url_instruction['block'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:block';
$array_url_instruction['discounts'] = 'http://wiki.nukeviet.vn/nukeviet4:admin:shops:discount';

define('NV_IS_FILE_ADMIN', true);

require_once NV_ROOTDIR . '/modules/' . $module_file . '/global.functions.php';
require_once NV_ROOTDIR . '/modules/' . $module_file . '/site.functions.php';

/**
 * nv_fix_cat_order()
 *
 * @param integer $parentid
 * @param integer $order
 * @param integer $lev
 * @return
 */
function nv_fix_cat_order($parentid = 0, $order = 0, $lev = 0)
{
    global $db, $db_config, $module_data;

    $sql = 'SELECT catid, parentid FROM ' . $db_config['prefix'] . '_' . $module_data . '_catalogs WHERE parentid=' . $parentid . ' ORDER BY weight ASC';
    $result = $db->query($sql);
    $array_cat_order = array();
    while ($row = $result->fetch()) {
        $array_cat_order[] = $row['catid'];
    }
    $result->closeCursor();
    $weight = 0;

    if ($parentid > 0) {
        ++$lev;
    } else {
        $lev = 0;
    }

    foreach ($array_cat_order as $catid_i) {
        ++$order;
        ++$weight;
        $sql = 'UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_catalogs SET weight=' . $weight . ', sort=' . $order . ', lev=' . $lev . ' WHERE catid=' . $catid_i;
        $db->query($sql);
        $order = nv_fix_cat_order($catid_i, $order, $lev);
    }

    $numsubcat = $weight;
    if ($parentid > 0) {
        $_view_cat_check = $db->query('SELECT viewcat FROM ' . $db_config['prefix'] . '_' . $module_data . '_catalogs WHERE catid=' . $parentid)->fetch();
        $sql = 'UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_catalogs SET numsubcat=' . $numsubcat;
        if ($numsubcat == 0 && $_view_cat_check['viewcat'] == 'view_home_cat') {
            $sql .= ", subcatid='', viewcat='viewlist'";
        } else {
            $sql .= ", subcatid='" . implode(",", $array_cat_order) . "'";
        }
        $sql .= ' WHERE catid=' . $parentid;
        $db->query($sql);
    }
    return $order;
}

/**
 * nv_fix_block_cat()
 *
 * @return
 */
function nv_fix_block_cat()
{
    global $db, $db_config, $module_data;

    $sql = 'SELECT bid FROM ' . $db_config['prefix'] . '_' . $module_data . '_block_cat ORDER BY weight ASC';
    $weight = 0;
    $result = $db->query($sql);
    while ($row = $result->fetch()) {
        ++$weight;
        $sql = 'UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_block_cat SET weight=' . $weight . ' WHERE bid=' . $row['bid'];
        $db->query($sql);
    }
    $result->closeCursor();
}

/**
 * nv_news_fix_block()
 *
 * @param mixed $bid
 * @param bool $repairtable
 * @return
 */
function nv_news_fix_block($bid, $repairtable = true)
{
    global $db, $db_config, $module_data;

    $bid = intval($bid);

    if ($bid > 0) {
        $sql = 'SELECT id FROM ' . $db_config['prefix'] . '_' . $module_data . '_block WHERE bid=' . $bid . ' ORDER BY weight ASC';
        $result = $db->query($sql);
        $weight = 0;
        while ($row = $result->fetch()) {
            ++$weight;
            if ($weight <= 500) {
                $sql = 'UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_block SET weight=' . $weight . ' WHERE bid=' . $bid . ' AND id=' . $row['id'];
            } else {
                $sql = 'DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_block WHERE bid=' . $bid . ' AND id=' . $row['id'];
            }
            $db->query($sql);
        }
        $result->closeCursor();

        if ($repairtable) {
            $db->query('REPAIR TABLE ' . $db_config['prefix'] . '_' . $module_data . '_block');
        }
    }
}

/**
 * shops_show_cat_list()
 *
 * @param integer $parentid
 * @return
 */
function shops_show_cat_list($parentid = 0)
{
    global $db, $db_config, $module_name, $nv_Request, $module_data, $op, $array_viewcat_full, $array_viewcat_nosub, $global_config, $module_file, $nv_Lang, $global_array_shops_cat;

    $tpl = new \NukeViet\Template\NVSmarty();
    $tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $global_config['module_theme'] . '/modules/' . $module_file);
    // Gán các biến cơ bản cho template
    $tpl->assign('LANG', $nv_Lang);
    $tpl->assign('NV_BASE_ADMINURL', NV_BASE_ADMINURL);
    $tpl->assign('NV_LANG_VARIABLE', NV_LANG_VARIABLE);
    $tpl->assign('NV_LANG_DATA', NV_LANG_DATA);
    $tpl->assign('NV_NAME_VARIABLE', NV_NAME_VARIABLE);
    $tpl->assign('NV_OP_VARIABLE', NV_OP_VARIABLE);
    $tpl->assign('MODULE_NAME', $module_name);
    $tpl->assign('OP', $op);

    $array_cat_list = [];
    $current_catid = $nv_Request->get_int('catid', 'get,post', 0);

    foreach ($global_array_shops_cat as $catid_i => $rowscat) {
        if ($catid_i != $current_catid) {
            $xtitle_i = '';
            if ($rowscat['lev'] > 0) {
                for ($i = 1; $i <= $rowscat['lev']; $i++) {
                    $xtitle_i .= '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
                }
            }
            $array_cat_list[] = array(
                'catid' => $catid_i,
                'title' => $xtitle_i . $rowscat['title'],
                'lev' => $rowscat['lev']
            );
        }
    }
    $tpl->assign('CATS', $array_cat_list);

    // Xử lý breadcrumb cho danh mục
    if ($parentid > 0) {
        $parentid_i = $parentid;
        $array_cat_title = array();
        $a = 0;

        while ($parentid_i > 0) {
            list ($catid_i, $parentid_i, $title_i) = $db->query('SELECT catid, parentid, ' . NV_LANG_DATA . '_title FROM ' . $db_config['prefix'] . '_' . $module_data . '_catalogs WHERE catid=' . intval($parentid_i))->fetch(3);

            $array_cat_title[] = "<a href=\"" . NV_BASE_ADMINURL . "index.php?" . NV_LANG_VARIABLE . "=" . NV_LANG_DATA . "&" . NV_NAME_VARIABLE . "=" . $module_name . "&" . NV_OP_VARIABLE . "=cat&amp;parentid=" . $catid_i . "\"><strong>" . $title_i . "</strong></a>";

            ++$a;
        }

        for ($i = $a - 1; $i >= 0; $i--) {
            $tpl->assign('CAT_NAV', $array_cat_title[$i] . ($i > 0 ? " &raquo; " : ""));
            $tpl->append('CATNAV', array('title' => $array_cat_title[$i], 'separator' => ($i > 0 ? " &raquo; " : "")));
        }
    }

    $sql = 'SELECT catid, parentid, ' . NV_LANG_DATA . '_title, weight, viewcat, numsubcat, inhome, numlinks, newday FROM ' . $db_config['prefix'] . '_' . $module_data . '_catalogs WHERE parentid=' . $parentid . ' ORDER BY weight ASC';
    $result = $db->query($sql);
    $num = $result->rowCount();

    if ($num > 0) {
        $array_inhome = array(
            $nv_Lang->getModule('yes'),
            $nv_Lang->getModule('no')
        );

        $array_data = array();
        while (list ($catid, $parentid, $title, $weight, $viewcat, $numsubcat, $inhome, $numlinks, $newday) = $result->fetch(3)) {
            $array_viewcat = ($numsubcat > 0) ? $array_viewcat_full : $array_viewcat_nosub;
            if (!array_key_exists($viewcat, $array_viewcat)) {
                $viewcat = 'viewlist';
                $stmt = $db->prepare('UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_catalogs SET viewcat= :viewcat WHERE catid=' . $catid);
                $stmt->bindParam(':viewcat', $viewcat, PDO::PARAM_STR);
                $stmt->execute();
            }

            $row = array(
                'catid' => $catid,
                'cat_link' => NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=cat&amp;parentid=' . $catid,
                'title' => $title,
                'numsubcat' => $numsubcat > 0 ? ' <span style="color:#FF0101;">(' . $numsubcat . ')</span>' : '',
                'parentid' => $parentid,
                'weight_options' => array(),
                'inhome_options' => array(),
                'viewcat_options' => array(),
                'numlinks_options' => array(),
                'newday_options' => array()
            );

            // Options cho trọng số
            for ($i = 1; $i <= $num; $i++) {
                $row['weight_options'][] = array(
                    'key' => $i,
                    'title' => $i,
                    'selected' => $i == $weight ? ' selected="selected"' : ''
                );
            }

            // Options cho hiển thị trang chủ
            foreach ($array_inhome as $key => $val) {
                $row['inhome_options'][] = array(
                    'key' => $key,
                    'title' => $val,
                    'selected' => $key == $inhome ? ' selected="selected"' : ''
                );
            }

            // Options cho kiểu hiển thị
            foreach ($array_viewcat as $key => $val) {
                $row['viewcat_options'][] = array(
                    'key' => $key,
                    'title' => $val,
                    'selected' => $key == $viewcat ? ' selected="selected"' : ''
                );
            }

            // Options cho số liên kết
            for ($i = 0; $i <= 10; $i++) {
                $row['numlinks_options'][] = array(
                    'key' => $i,
                    'title' => $i,
                    'selected' => $i == $numlinks ? ' selected="selected"' : ''
                );
            }

            for ($i = 0; $i <= 30; $i++) {
                $row['newday_options'][] = array(
                    'key' => $i,
                    'title' => $i,
                    'selected' => $i == $newday ? ' selected="selected"' : ''
                );
            }

            $array_data[] = $row;
        }
        $tpl->assign('DATA', $array_data);
    }

    return $tpl->fetch('cat_lists.tpl');
}


/**
 * nv_fix_group_order()
 *
 * @param integer $parentid
 * @param integer $order
 * @param integer $lev
 * @return
 */
function nv_fix_group_order($parentid = 0, $sort = 0, $lev = 0)
{
    global $db, $db_config, $module_data;

    $sql = 'SELECT groupid, parentid FROM ' . $db_config['prefix'] . '_' . $module_data . '_group WHERE parentid=' . $parentid . ' ORDER BY weight ASC';
    $result = $db->query($sql);
    $array_group_order = array();
    while ($row = $result->fetch()) {
        $array_group_order[] = $row['groupid'];
    }
    $result->closeCursor();
    $weight = 0;
    if ($parentid > 0) {
        ++$lev;
    } else {
        $lev = 0;
    }
    foreach ($array_group_order as $groupid_i) {
        ++$sort;
        ++$weight;

        $sql = 'UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_group SET weight=' . $weight . ', sort=' . $sort . ', lev=' . $lev . ' WHERE groupid=' . $groupid_i;
        $db->query($sql);

        $sort = nv_fix_group_order($groupid_i, $sort, $lev);
    }

    $numsubgroup = $weight;

    if ($parentid > 0) {
        $sql = "UPDATE " . $db_config['prefix'] . "_" . $module_data . "_group SET numsubgroup=" . $numsubgroup;
        if ($numsubgroup == 0) {
            $sql .= ",subgroupid='', viewgroup='viewgrid'";
        } else {
            $sql .= ",subgroupid='" . implode(",", $array_group_order) . "'";
        }
        $sql .= " WHERE groupid=" . intval($parentid);
        $db->query($sql);
    }
    return $sort;
}

/**
 * shops_show_group_list()
 *
 * @param integer $parentid
 * @return
 */
function shops_show_group_list($parentid = 0)
{
    global $db, $db_config, $module_name, $module_data, $op, $array_viewcat_nosub, $module_file, $global_config, $nv_Lang, $global_array_group, $nv_Request;

    $tpl = new \NukeViet\Template\NVSmarty();
    $tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $global_config['module_theme'] . '/modules/' . $module_file);

    // Gán các biến cơ bản
    $tpl->assign('LANG', $nv_Lang);
    $tpl->assign('GLANG', \NukeViet\Core\Language::$lang_global);
    $tpl->assign('NV_BASE_ADMINURL', NV_BASE_ADMINURL);
    $tpl->assign('NV_LANG_VARIABLE', NV_LANG_VARIABLE);
    $tpl->assign('NV_LANG_DATA', NV_LANG_DATA);
    $tpl->assign('NV_NAME_VARIABLE', NV_NAME_VARIABLE);
    $tpl->assign('NV_OP_VARIABLE', NV_OP_VARIABLE);
    $tpl->assign('MODULE_NAME', $module_name);
    $tpl->assign('OP', $op);

    $current_groupid = $nv_Request->get_int('groupid', 'get,post', 0);
    
    $array_group_list = array();
    foreach ($global_array_group as $groupid_i => $rowgroup) {
        if ($groupid_i != $current_groupid) {
            $xtitle_i = '';
            if ($rowgroup['lev'] > 0) {
                for ($i = 1; $i <= $rowgroup['lev']; $i++) {
                    $xtitle_i .= '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
                }
            }
            $array_group_list[] = array(
                'groupid' => $groupid_i,
                'title' => $xtitle_i . $rowgroup['title'],
                'lev' => $rowgroup['lev']
            );
        }
    }
    $tpl->assign('GROUPS', $array_group_list);

    // Xử lý breadcrumb cho nhóm
    $array_group_nav = array();
    if ($parentid > 0) {
        $parentid_i = $parentid;
        while ($parentid_i > 0) {
            list ($groupid_i, $parentid_i, $title_i) = $db->query("SELECT groupid, parentid, " . NV_LANG_DATA . "_title FROM " . $db_config['prefix'] . "_" . $module_data . "_group WHERE groupid=" . intval($parentid_i))->fetch(3);
            $array_group_nav[] = array(
                'link' => NV_BASE_ADMINURL . "index.php?" . NV_LANG_VARIABLE . "=" . NV_LANG_DATA . "&" . NV_NAME_VARIABLE . "=" . $module_name . "&" . NV_OP_VARIABLE . "=group&amp;parentid=" . $groupid_i,
                'title' => $title_i
            );
        }
        $array_group_nav = array_reverse($array_group_nav);
        $tpl->assign('group_nav', $array_group_nav);
    }

    // Lấy danh sách nhóm
    $sql = "SELECT groupid, parentid, " . NV_LANG_DATA . "_title, " . NV_LANG_DATA . "_description, weight, viewgroup, numsubgroup, inhome, indetail, in_order FROM " . $db_config['prefix'] . "_" . $module_data . "_group WHERE parentid = '" . $parentid . "' ORDER BY weight ASC";
    $result = $db->query($sql);
    $num = $result->rowCount();

    if ($num > 0) {
        $array_yes_no = array(
            $nv_Lang->getGlobal('no'),
            $nv_Lang->getGlobal('yes')
        );

        $array_data = array();
        while ($row = $result->fetch()) {
            // Xử lý viewgroup
            if (!array_key_exists($row['viewgroup'], $array_viewcat_nosub)) {
                $row['viewgroup'] = "viewgrid";
                $stmt = $db->prepare("UPDATE " . $db_config['prefix'] . "_" . $module_data . "_group SET viewgroup= :viewgroup WHERE groupid=" . intval($row['groupid']));
                $stmt->bindParam(':viewgroup', $row['viewgroup'], PDO::PARAM_STR);
                $stmt->execute();
            }

            // Xử lý options cho các select box
            $weight_options = array();
            for ($i = 1; $i <= $num; $i++) {
                $weight_options[] = array(
                    'key' => $i,
                    'title' => $i,
                    'selected' => $i == $row['weight'] ? ' selected="selected"' : ''
                );
            }

            $inhome_options = array();
            $indetail_options = array();
            $in_order_options = array();
            foreach ($array_yes_no as $key => $val) {
                $inhome_options[] = array(
                    'key' => $key,
                    'title' => $val,
                    'selected' => $key == $row['inhome'] ? ' selected="selected"' : ''
                );
                $indetail_options[] = array(
                    'key' => $key,
                    'title' => $val,
                    'selected' => $key == $row['indetail'] ? ' selected="selected"' : ''
                );
                $in_order_options[] = array(
                    'key' => $key,
                    'title' => $val,
                    'selected' => $key == $row['in_order'] ? ' selected="selected"' : ''
                );
            }

            $viewgroup_options = array();
            foreach ($array_viewcat_nosub as $key => $val) {
                $viewgroup_options[] = array(
                    'key' => $key,
                    'title' => $val,
                    'selected' => $key == $row['viewgroup'] ? ' selected="selected"' : ''
                );
            }

            $array_data[] = array(
                'groupid' => $row['groupid'],
                'group_link' => empty($row['parentid']) ? NV_BASE_ADMINURL . "index.php?" . NV_LANG_VARIABLE . "=" . NV_LANG_DATA . "&amp;" . NV_NAME_VARIABLE . "=" . $module_name . "&amp;" . NV_OP_VARIABLE . "=group&amp;parentid=" . $row['groupid'] : 'javascript:void(0)',
                'title' => $row[NV_LANG_DATA . '_title'],
                'description' => $row[NV_LANG_DATA . '_description'],
                'numsubgroup' => $row['numsubgroup'] > 0 ? " <span style=\"color:#FF0101;\">(" . $row['numsubgroup'] . ")</span>" : "",
                'parentid' => $row['parentid'],
                'weight_options' => $weight_options,
                'inhome_options' => $inhome_options,
                'indetail_options' => $indetail_options,
                'in_order_options' => $in_order_options,
                'viewgroup_options' => $viewgroup_options
            );
        }
        $tpl->assign('DATA', $array_data);
    }

    $tpl->assign('main', true);
    return $tpl->fetch('group_lists.tpl');
}

/**
 * shops_show_location_list()
 *
 * @param integer $parentid
 * @return
 */
function shops_show_location_list($parentid, $page, $per_page, $base_url)
{
    global $db, $db_config, $module_name, $module_data, $op, $array_viewcat_nosub, $module_file, $global_config, $nv_Lang;

    $tpl = new \NukeViet\Template\NVSmarty();
    $tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $global_config['module_theme'] . '/modules/' . $module_file);

    // Navigation cho danh mục cha
    $array_location_nav = array();
    if ($parentid > 0) {
        $parentid_i = $parentid;
        while ($parentid_i > 0) {
            list($id_i, $parentid_i, $title_i) = $db->query("SELECT id, parentid, title FROM " . $db_config['prefix'] . "_" . $module_data . "_location WHERE id=" . intval($parentid_i))->fetch(3);
            
            $array_location_nav[] = array(
                'link' => NV_BASE_ADMINURL . "index.php?" . NV_LANG_VARIABLE . "=" . NV_LANG_DATA . "&" . NV_NAME_VARIABLE . "=" . $module_name . "&" . NV_OP_VARIABLE . "=location&amp;parentid=" . $id_i,
                'title' => $title_i
            );
        }
        $array_location_nav[] = array(
            'link' => NV_BASE_ADMINURL . "index.php?" . NV_LANG_VARIABLE . "=" . NV_LANG_DATA . "&" . NV_NAME_VARIABLE . "=" . $module_name . "&" . NV_OP_VARIABLE . "=location",
            'title' => $nv_Lang->getModule('location')
        );
        
        // Đảo ngược mảng để hiển thị đúng thứ tự
        $array_location_nav = array_reverse($array_location_nav);
    }

    // Fetch dữ liệu
    $db->sqlreset()
        ->select('COUNT(*)')
        ->from($db_config['prefix'] . '_' . $module_data . '_location')
        ->where('parentid = ' . $parentid);

    $all_page = $db->query($db->sql())->fetchColumn();

    $db->select('id, parentid, title, weight, numsub')
        ->order('weight ASC')
        ->limit($per_page)
        ->offset(($page - 1) * $per_page);

    $result = $db->query($db->sql());
    
    $array_data = [];
    while (list($id, $parentid, $title, $weight, $numsub) = $result->fetch(3)) {
        $array_weight = [];
        for ($i = 1; $i <= $all_page; $i++) {
            $array_weight[] = array(
                'key' => $i,
                'title' => $i,
                'selected' => $i == $weight ? ' selected="selected"' : ''
            );
        }
        
        $array_data[] = [
            'id' => $id,
            'parentid' => $parentid,
            'title' => $title,
            'weight_options' => $array_weight,
            'numsub' => $numsub > 0 ? ' <span class="text-danger">(' . $numsub . ')</span>' : '',
            'link' => NV_BASE_ADMINURL . "index.php?" . NV_LANG_VARIABLE . "=" . NV_LANG_DATA . "&amp;" . NV_NAME_VARIABLE . "=" . $module_name . "&amp;" . NV_OP_VARIABLE . "=location&amp;parentid=" . $id,
            'edit_link' => NV_BASE_ADMINURL . "index.php?" . NV_LANG_VARIABLE . "=" . NV_LANG_DATA . "&amp;" . NV_NAME_VARIABLE . "=" . $module_name . "&amp;" . NV_OP_VARIABLE . "=location&amp;id=" . $id . "&amp;parentid=" . $parentid . "#edit"
        ];
    }

    // Gán dữ liệu cho template
    $tpl->assign('LANG', $nv_Lang);
    $tpl->assign('GLANG', \NukeViet\Core\Language::$lang_global);
    $tpl->assign('NV_BASE_ADMINURL', NV_BASE_ADMINURL);
    $tpl->assign('NV_LANG_VARIABLE', NV_LANG_VARIABLE);
    $tpl->assign('NV_LANG_DATA', NV_LANG_DATA);
    $tpl->assign('NV_NAME_VARIABLE', NV_NAME_VARIABLE);
    $tpl->assign('NV_OP_VARIABLE', NV_OP_VARIABLE);
    $tpl->assign('MODULE_NAME', $module_name);
    $tpl->assign('OP', $op);

    if (!empty($array_location_nav)) {
        $tpl->assign('location_nav', $array_location_nav);
    }
    
    if (!empty($array_data)) {
        $tpl->assign('DATA', $array_data);
    }

    $generate_page = nv_generate_page($base_url, $all_page, $per_page, $page);
    if (!empty($generate_page)) {
        $tpl->assign('GENERATE_PAGE', $generate_page);
    }

    return $tpl->fetch('location_lists.tpl');
}

/**
 * nv_fix_location_order()
 *
 * @param integer $parentid
 * @param integer $order
 * @param integer $lev
 * @return
 */
function nv_fix_location_order($parentid = 0, $sort = 0, $lev = 0)
{
    global $db, $db_config, $module_data;

    $sql = 'SELECT id, parentid FROM ' . $db_config['prefix'] . '_' . $module_data . '_location WHERE parentid=' . $parentid . ' ORDER BY weight ASC';
    $result = $db->query($sql);
    $array_location_order = array();
    while ($row = $result->fetch()) {
        $array_location_order[] = $row['id'];
    }
    $result->closeCursor();
    $weight = 0;
    if ($parentid > 0) {
        ++$lev;
    } else {
        $lev = 0;
    }
    foreach ($array_location_order as $locationid_i) {
        ++$sort;
        ++$weight;

        $sql = 'UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_location SET weight=' . $weight . ', sort=' . $sort . ', lev=' . $lev . ' WHERE id=' . $locationid_i;
        $db->query($sql);

        $sort = nv_fix_location_order($locationid_i, $sort, $lev);
    }

    $numsub = $weight;

    if ($parentid > 0) {
        $sql = "UPDATE " . $db_config['prefix'] . "_" . $module_data . "_location SET numsub=" . $numsub;
        if ($numsub == 0) {
            $sql .= ",subid=''";
        } else {
            $sql .= ",subid='" . implode(",", $array_location_order) . "'";
        }
        $sql .= " WHERE id=" . intval($parentid);
        $db->query($sql);
    }
    return $sort;
}

/**
 * nv_show_block_cat_list()
 *
 * @return
 */
function nv_show_block_cat_list()
{
    global $db, $db_config, $module_name, $module_data, $op, $global_config, $module_file, $nv_Lang;

    $xtpl = new XTemplate("block_cat_list.tpl", NV_ROOTDIR . "/themes/" . $global_config['module_theme'] . "/modules/" . $module_file);
    $xtpl->assign('LANG', \NukeViet\Core\Language::$lang_module);
    $xtpl->assign('GLANG', \NukeViet\Core\Language::$lang_global);
    $xtpl->assign('NV_BASE_ADMINURL', NV_BASE_ADMINURL);
    $xtpl->assign('NV_LANG_VARIABLE', NV_LANG_VARIABLE);
    $xtpl->assign('NV_LANG_DATA', NV_LANG_DATA);
    $xtpl->assign('NV_NAME_VARIABLE', NV_NAME_VARIABLE);
    $xtpl->assign('NV_OP_VARIABLE', NV_OP_VARIABLE);
    $xtpl->assign('MODULE_NAME', $module_name);
    $xtpl->assign('OP', 'blockcat');

    $sql = "SELECT * FROM " . $db_config['prefix'] . "_" . $module_data . "_block_cat ORDER BY weight ASC";
    $result = $db->query($sql);

    $num = $result->rowCount();

    if ($num > 0) {
        $a = 0;
        $array_adddefault = array(
            $nv_Lang->getGlobal('no'),
            $nv_Lang->getGlobal('yes')
        );

        while ($row = $result->fetch()) {
            $numnews = $db->query("SELECT COUNT(*) FROM " . $db_config['prefix'] . "_" . $module_data . "_block WHERE bid=" . $row['bid'])->fetchColumn();

            $xtpl->assign('ROW', array(
                "bid" => $row['bid'],
                "numnews" => $numnews ? " (" . $numnews . " " . $nv_Lang->getModule('num_product') . ")" : "",
                "title" => $row[NV_LANG_DATA . '_title']
            ));

            for ($i = 1; $i <= $num; $i++) {
                $xtpl->assign('WEIGHT', array(
                    "key" => $i,
                    "title" => $i,
                    "selected" => $i == $row['weight'] ? " selected=\"selected\"" : ""
                ));
                $xtpl->parse('main.loop.weight');
            }

            foreach ($array_adddefault as $key => $val) {
                $xtpl->assign('ADDDEFAULT', array(
                    "key" => $key,
                    "title" => $val,
                    "selected" => $key == $row['adddefault'] ? " selected=\"selected\"" : ""
                ));
                $xtpl->parse('main.loop.adddefault');
            }

            $xtpl->parse('main.loop');
            ++$a;
        }
    }
    $result->closeCursor();

    $xtpl->parse('main');
    return $xtpl->text('main');
}

/**
 * shops_show_discounts_list()
 *
 * @return
 */
function shops_show_discounts_list()
{
    global $db, $db_config, $module_name, $module_data, $op, $global_config, $module_file, $nv_Lang;

    $xtpl = new XTemplate("discounts_list.tpl", NV_ROOTDIR . "/themes/" . $global_config['module_theme'] . "/modules/" . $module_file);
    $xtpl->assign('LANG', \NukeViet\Core\Language::$lang_module);
    $xtpl->assign('GLANG', \NukeViet\Core\Language::$lang_global);
    $xtpl->assign('NV_BASE_ADMINURL', NV_BASE_ADMINURL);
    $xtpl->assign('NV_NAME_VARIABLE', NV_NAME_VARIABLE);
    $xtpl->assign('NV_OP_VARIABLE', NV_OP_VARIABLE);
    $xtpl->assign('MODULE_NAME', $module_name);
    $xtpl->assign('OP', 'blockcat');

    $sql = "SELECT * FROM " . $db_config['prefix'] . "_" . $module_data . "_discounts ORDER BY weight ASC";
    $result = $db->query($sql);

    $num = $result->rowCount();

    if ($num > 0) {
        $a = 0;
        $array_adddefault = array(
            $nv_Lang->getGlobal('no'),
            $nv_Lang->getGlobal('yes')
        );

        while ($row = $result->fetch()) {
            $numnews = $db->query("SELECT COUNT(*) FROM " . $db_config['prefix'] . "_" . $module_data . "_block WHERE bid=" . $row['bid'])->fetchColumn();

            $xtpl->assign('ROW', array(
                "bid" => $row['bid'],
                "numnews" => $numnews ? " (" . $numnews . " " . $nv_Lang->getModule('num_product') . ")" : "",
                "title" => $row[NV_LANG_DATA . '_title']
            ));

            for ($i = 1; $i <= $num; $i++) {
                $xtpl->assign('WEIGHT', array(
                    "key" => $i,
                    "title" => $i,
                    "selected" => $i == $row['weight'] ? " selected=\"selected\"" : ""
                ));
                $xtpl->parse('main.loop.weight');
            }

            foreach ($array_adddefault as $key => $val) {
                $xtpl->assign('ADDDEFAULT', array(
                    "key" => $key,
                    "title" => $val,
                    "selected" => $key == $row['adddefault'] ? " selected=\"selected\"" : ""
                ));
                $xtpl->parse('main.loop.adddefault');
            }

            $xtpl->parse('main.loop');
            ++$a;
        }
    }
    $result->closeCursor();

    $xtpl->parse('main');
    return $xtpl->text('main');
}

/**
 * nv_show_block_list()
 *
 * @param mixed $bid
 * @return string
 */
function nv_show_block_list($bid)
{
    global $db, $db_config, $module_name, $module_data, $op, $global_array_shops_cat, $global_config, $module_file, $nv_Lang;

    $template = get_tpl_dir([$global_config['module_theme'], $global_config['admin_theme']], 'admin_future', '/modules/' . $module_file . '/block_list.tpl');
    $tpl = new \NukeViet\Template\NVSmarty();
    $tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $template . '/modules/' . $module_file);

    $sql = 'SELECT t1.id, t1.listcatid, t1.' . NV_LANG_DATA . '_title, t1.' . NV_LANG_DATA . '_alias, t2.weight, status 
            FROM ' . $db_config['prefix'] . '_' . $module_data . '_rows as t1 
            INNER JOIN ' . $db_config['prefix'] . '_' . $module_data . '_block AS t2 
            ON t1.id = t2.id WHERE t2.bid= ' . $bid . ' 
            ORDER BY t2.weight ASC';

    $result = $db->query($sql);
    $num = $result->rowCount();
    $array_data = [];

    while (list($id, $listcatid, $title, $alias, $weight, $status) = $result->fetch(3)) {
        $weight_options = [];
        for ($i = 1; $i <= $num; $i++) {
            $weight_options[] = [
                'key' => $i,
                'title' => $i,
                'selected' => $i == $weight ? ' selected="selected"' : ''
            ];
        }

        $array_data[] = [
            'id' => $id,
            'title' => $title,
            'status' => $nv_Lang->getModule('status_' . $status),
            'link' => NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $global_array_shops_cat[$listcatid]['alias'] . '/' . $alias . $global_config['rewrite_exturl'],
            'weight_options' => $weight_options
        ];
    }
    $result->closeCursor();

    // Gán dữ liệu cho template
    $tpl->assign('LANG', $nv_Lang);
    $tpl->assign('GLANG', \NukeViet\Core\Language::$lang_global);
    $tpl->assign('NV_BASE_ADMINURL', NV_BASE_ADMINURL);
    $tpl->assign('NV_LANG_VARIABLE', NV_LANG_VARIABLE);
    $tpl->assign('NV_LANG_DATA', NV_LANG_DATA);
    $tpl->assign('NV_NAME_VARIABLE', NV_NAME_VARIABLE);
    $tpl->assign('NV_OP_VARIABLE', NV_OP_VARIABLE);
    $tpl->assign('MODULE_NAME', $module_name);
    $tpl->assign('OP', $op);
    $tpl->assign('BID', $bid);
    $tpl->assign('DATA', $array_data);

    return $tpl->fetch('block_list.tpl');
}

/**
 * email_new_order_payment()
 *
 * @param mixed $content
 * @param mixed $data_content
 * @param mixed $data_pro
 * @param mixed $data_table
 * @return
 */
function email_new_order_payment($content, $data_content, $data_pro, $data_table = false)
{
    global $module_info, $module_file, $pro_config, $global_config, $money_config, $nv_Lang;

    if ($data_table) {
        $xtpl = new XTemplate("email_new_order_payment.tpl", NV_ROOTDIR . "/themes/" . $global_config['module_theme'] . "/modules/" . $module_file);
        $xtpl->assign('LANG', \NukeViet\Core\Language::$lang_module);
        $xtpl->assign('DATA', $data_content);

        $i = 0;
        foreach ($data_pro as $pdata) {
            $xtpl->assign('product_name', $pdata['title']);
            $xtpl->assign('product_number', $pdata['product_number']);
            $xtpl->assign('product_price', number_format($pdata['product_price'], nv_get_decimals($pro_config['money_unit'])));
            $xtpl->assign('product_unit', $pdata['product_unit']);
            $xtpl->assign('pro_no', $i + 1);

            $bg = ($i % 2 == 0) ? " style=\"background:#f3f3f3;\"" : "";
            $xtpl->assign('bg', $bg);

            if ($pro_config['active_price'] == '1') {
                $xtpl->parse('data_product.loop.price2');
            }
            $xtpl->parse('data_product.loop');
            ++$i;
        }

        if (!empty($data_content['order_note'])) {
            $xtpl->parse('data_product.order_note');
        }

        $xtpl->assign('order_total', number_format($data_content['order_total'], nv_get_decimals($pro_config['money_unit'])));
        $xtpl->assign('unit', $data_content['unit_total']);

        if ($pro_config['active_price'] == '1') {
            $xtpl->parse('data_product.price1');
            $xtpl->parse('data_product.price3');
        }

        $xtpl->parse('data_product');
        return $xtpl->text('data_product');
        die();
    }

    $xtpl = new XTemplate("email_new_order_payment.tpl", NV_ROOTDIR . "/themes/" . $global_config['module_theme'] . "/modules/" . $module_file);
    $xtpl->assign('LANG', \NukeViet\Core\Language::$lang_module);
    $xtpl->assign('CONTENT', $content);

    $xtpl->parse('main');
    return $xtpl->text('main');
}

/**
 * drawselect_number()
 *
 * @param string $select_name
 * @param integer $number_start
 * @param integer $number_end
 * @param integer $number_curent
 * @param string $func_onchange
 * @return
 */
function drawselect_number($select_name = "", $number_start = 0, $number_end = 1, $number_curent = 0, $func_onchange = "")
{
    $html = "<select class=\"form-control\" name=\"" . $select_name . "\" onchange=\"" . $func_onchange . "\">";
    for ($i = $number_start; $i < $number_end; $i++) {
        $select = ($i == $number_curent) ? "selected=\"selected\"" : "";
        $html .= "<option value=\"" . $i . "\"" . $select . ">" . $i . "</option>";
    }
    $html .= "</select>";
    return $html;
}

/**
 * GetCatidInChild()
 *
 * @param mixed $catid
 * @return
 */
function GetCatidInChild($catid)
{
    global $global_array_shops_cat, $array_cat;

    $array_cat[] = $catid;

    if ($global_array_shops_cat[$catid]['parentid'] > 0) {
        $array_cat[] = $global_array_shops_cat[$catid]['parentid'];
        $array_cat_temp = GetCatidInChild($global_array_shops_cat[$catid]['parentid']);
        foreach ($array_cat_temp as $catid_i) {
            $array_cat[] = $catid_i;
        }
    }
    return array_unique($array_cat);
}

/**
 * nv_show_custom_form()
 *
 * @param mixed $is_edit
 * @param mixed $form
 * @param mixed $array_custom
 * @param mixed $array_custom_lang
 * @return
 */
function nv_show_custom_form($is_edit, $form, $array_custom)
{
    global $db, $db_config, $module_name, $module_data, $op, $global_array_shops_cat, $global_config, $module_file, $module_upload, $nv_Lang;

    $xtpl = new XTemplate('cat_form_' . $form . '.tpl', NV_ROOTDIR . '/' . NV_ASSETS_DIR . '/' . $module_upload . '/files_tpl');
    $xtpl->assign('LANG', \NukeViet\Core\Language::$lang_module);
    $xtpl->assign('GLANG', \NukeViet\Core\Language::$lang_global);
    $xtpl->assign('NV_BASE_ADMINURL', NV_BASE_ADMINURL);
    $xtpl->assign('NV_NAME_VARIABLE', NV_NAME_VARIABLE);
    $xtpl->assign('NV_OP_VARIABLE', NV_OP_VARIABLE);
    $xtpl->assign('MODULE_NAME', $module_name);
    $xtpl->assign('OP', $op);

    if (preg_match('/^[a-zA-Z0-9\-\_]+$/', $form) and file_exists(NV_ROOTDIR . '/modules/' . $module_file . '/admin/cat_form_' . $form . '.php')) {
        require_once NV_ROOTDIR . '/modules/' . $module_file . '/admin/cat_form_' . $form . '.php';
    }

    if (defined('NV_EDITOR')) {
        require_once NV_ROOTDIR . '/' . NV_EDITORSDIR . '/' . NV_EDITOR . '/nv.php';
    }

    $array_custom_lang = array();
    list($idtemplate, $titletemplate) = $db->query('SELECT id, ' . NV_LANG_DATA . '_title title FROM ' . $db_config['prefix'] . '_' . $module_data . '_template WHERE alias = "' . preg_replace("/[\_]/", "-", $form) . '"')->fetch(3);
    if ($idtemplate) {
        $array_tmp = array();
        $result = $db->query('SELECT * FROM ' . $db_config['prefix'] . '_' . $module_data . '_field WHERE FIND_IN_SET(' . $idtemplate . ', listtemplate)');
        while ($row = $result->fetch()) {
            if (!$is_edit) {
                if ($row['field_type'] == 'date') {
                    $array_custom[$row['field']] = ($row['field_choices']['current_date']) ? NV_CURRENTTIME : $row['default_value'];
                } elseif ($row['field_type'] == 'number') {
                    $array_custom[$row['field']] = $row['default_value'];
                } else {
                    if (!empty($row['field_choices'])) {
                        $temp = array_keys($row['field_choices']);
                        $tempkey = intval($row['default_value']) - 1;
                        $array_custom[$row['field']] = (isset($temp[$tempkey])) ? $temp[$tempkey] : '';
                    }
                }
            } elseif (!empty($row['field_choices'])) {
                $row['field_choices'] = unserialize($row['field_choices']);
            } elseif (!empty($row['sql_choices'])) {
                $row['sql_choices'] = explode('|', $row['sql_choices']);
                $query = 'SELECT ' . $row['sql_choices'][2] . ', ' . $row['sql_choices'][3] . ' FROM ' . $row['sql_choices'][1];
                $result_sql = $db->query($query);
                $weight = 0;
                while (list ($key, $val) = $result_sql->fetch(3)) {
                    $row['field_choices'][$key] = $val;
                }
            }

            if ($row['field_type'] == 'date') {
                $array_custom[$row['field']] = (empty($array_custom[$row['field']])) ? '' : date('d/m/Y', $array_custom[$row['field']]);
            } elseif ($row['field_type'] == 'textarea') {
                $array_custom[$row['field']] = nv_htmlspecialchars(nv_br2nl($array_custom[$row['field']]));
            } elseif ($row['field_type'] == 'editor') {
                $array_custom[$row['field']] = (empty($array_custom[$row['field']])) ? '' : htmlspecialchars(nv_editor_br2nl($array_custom[$row['field']]));
                $array_custom[$row['fid']] = !empty($array_custom[$row['fid']]) ? $array_custom[$row['fid']] : '';

                if (defined('NV_EDITOR') and nv_function_exists('nv_aleditor')) {
                    $row['class'] = explode('@', $row['class']);
                    $edits = nv_aleditor('custom[' . $row['fid'] . ']', $row['class'][0], $row['class'][1], $array_custom[$row['fid']]);
                    $array_custom[$row['field']] = $edits;
                } else {
                    $row['class'] = '';
                }
            } elseif ($row['field_type'] == 'select') {
                foreach ($row['field_choices'] as $key => $value) {
                    $xtpl->assign('OPTION', array(
                        'key' => $key,
                        'selected' => ($key == $array_custom[$row['field']]) ? ' selected="selected"' : '',
                        'title' => $value
                    ));
                    $xtpl->parse('main.select_' . $row['field']);
                }
            } elseif ($row['field_type'] == 'radio' or $row['field_type'] == 'checkbox') {
                $number = 0;
                foreach ($row['field_choices'] as $key => $value) {
                    $xtpl->assign('OPTION', array(
                        'id' => $row['fid'] . '_' . $number++,
                        'key' => $key,
                        'checked' => ($key == $array_custom[$row['field']]) ? ' checked="checked"' : '',
                        'title' => $value
                    ));

                    $xtpl->parse('main.' . $row['field_type'] . '_' . $row['field']);
                }
            } elseif ($row['field_type'] == 'multiselect') {
                foreach ($row['field_choices'] as $key => $value) {
                    $xtpl->assign('OPTION', array(
                        'key' => $key,
                        'selected' => ($key == $array_custom[$row['field']]) ? ' selected="selected"' : '',
                        'title' => $value
                    ));
                    $xtpl->parse('main.' . $row['field']);
                }
            }

            // Du lieu hien thi tieu de
            $array_tmp[$row['fid']] = unserialize($row['language']);
        }

        if (!empty($array_tmp)) {
            foreach ($array_tmp as $f_key => $field) {
                foreach ($field as $key_lang => $lang_data) {
                    if ($key_lang == NV_LANG_INTERFACE) {
                        $array_custom_lang[$f_key] = array(
                            'title' => $lang_data[0],
                            'description' => isset($lang_data[1]) ? $lang_data[1] : ''
                        );
                    }
                }
            }
        }
    }

    $xtpl->assign('TEMPLATE_NAME', $titletemplate);
    $xtpl->assign('ROW', $array_custom);
    $xtpl->assign('CUSTOM_LANG', $array_custom_lang);

    foreach ($array_custom_lang as $k_lang => $custom_lang) {
        if (!empty($custom_lang['description'])) {
            $xtpl->parse('main.' . $k_lang . '_description');
        }
    }

    $xtpl->parse('main');
    return $xtpl->text('main');
}

/**
 * Insertabl_catfields()
 *
 * @param mixed $table
 * @param mixed $array
 * @param mixed $idshop
 * @return
 */
function Insertabl_catfields($table, $array, $idshop)
{
    global $db, $module_name, $module_file, $db, $link, $module_info, $global_array_shops_cat, $global_config;

    $result = $db->query("SHOW COLUMNS FROM " . $table);

    $array_column = array();

    while ($row = $result->fetch()) {
        $array_column[] = $row['field'];
    }
    $sql_insert = '';
    array_shift($array_column);
    array_shift($array_column);
    $array_new = array();

    foreach ($array as $key => $array_a) {
        $array_new[$key] = $array_a;
    }

    foreach ($array_column as $array_i) {
        $sql_insert .= ",'" . $array_new[$array_i] . "'";
    }

    $sql = " INSERT INTO " . $table . " VALUES ( " . $idshop . ",1 " . $sql_insert . ")";

    $db->query($sql);
}

/**
 * nv_get_data_type()
 *
 * @param mixed $dataform
 * @return
 */
function nv_get_data_type($dataform)
{
    $type_date = '';
    if ($dataform['field_type'] == 'number') {
        $type_date = "DOUBLE NOT NULL DEFAULT '" . $dataform['default_value'] . "'";
    } elseif ($dataform['field_type'] == 'date') {
        $type_date = "INT(11) NOT NULL DEFAULT '0'";
    } elseif ($dataform['max_length'] <= 255) {
        $type_date = "VARCHAR( " . $dataform['max_length'] . " ) NOT NULL DEFAULT ''";
    } elseif ($dataform['max_length'] <= 65536) {
        //2^16 TEXT

        $type_date = 'TEXT NOT NULL';
    } elseif ($dataform['max_length'] <= 16777216) {
        //2^24 MEDIUMTEXT

        $type_date = 'MEDIUMTEXT NOT NULL';
    } elseif ($dataform['max_length'] <= 4294967296) {
        //2^32 LONGTEXT

        $type_date = 'LONGTEXT NOT NULL';
    }

    return $type_date;
}

function setTagKeywords($keywords, $isArr = false)
{
    $keywords = nv_strtolower($keywords);
    $keywords = explode(',', $keywords);
    $keywords = array_map('trim', $keywords);
    $keywords = array_filter($keywords);
    $keywords = array_unique($keywords);
    sort($keywords);

    if ($isArr) {
        return $keywords;
    }

    return implode(',', $keywords);
}

/**
 * setTagAlias()
 *
 * @param mixed $keywords
 * @param int   $tid
 * @param int   $dbexist
 * @return string|null
 * @throws PDOException
 */
function setTagAlias($keywords, $tid = 0, &$dbexist = 0)
{
    global $db, $module_data, $module_config, $module_name, $db_config;

    $alias = ($module_config[$module_name]['tags_alias']) ? get_mod_alias($keywords) : change_alias_tags($keywords);
    $dbexist = (bool) $db->query('SELECT COUNT(*) FROM ' . $db_config['prefix'] . '_' . $module_data . '_tags_' . NV_LANG_DATA . ' WHERE alias=' . $db->quote($alias) . ' AND tid!=' . $tid)->fetchColumn();

    return $alias;
}
