<?php

/**
 * @Project NUKEVIET 4.x
 * @Author VINADES.,JSC <contact@vinades.vn>
 * @Copyright (C) 2017 VINADES.,JSC. All rights reserved
 * @License GNU/GPL version 2 or any later version
 * @Createdate 04/18/2017 09:47
 */

if (! defined('NV_IS_FILE_ADMIN')) {
    die('Stop!!!');
}

if ($nv_Request->isset_request('change_weight', 'post')) {
    $id = $nv_Request->get_int('id', 'post', 0);
    $new_vid = $nv_Request->get_int('new_vid', 'post', 0);
    $content = 'NO_' . $id;
    if ($new_vid > 0) {
        $sql = 'SELECT id FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config WHERE id!=' . $id . ' ORDER BY weight ASC';
        $result = $db->query($sql);
        $weight = 0;
        while ($row = $result->fetch()) {
            ++$weight;
            if ($weight == $new_vid) {
                ++$weight;
            }
            $sql = 'UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config SET weight=' . $weight . ' WHERE id=' . $row['id'];
            $db->query($sql);
        }
        $sql = 'UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config SET weight=' . $new_vid . ' WHERE id=' . $id;
        $db->query($sql);
        $nv_Cache->delMod($module_name);
        nv_jsonOutput([
            'status' => 'OK',
            'message' => $nv_Lang->getModule('change_weight_success')
        ]);
    } else {
        nv_jsonOutput([
            'status' => 'ERROR',
            'message' => $nv_Lang->getModule('change_weight_error')
        ]);
    }
}

if ($nv_Request->isset_request('delete_id', 'get,post') and $nv_Request->isset_request('delete_checkss', 'get,post')) {
    $id = $nv_Request->get_int('delete_id', 'get,post');
    $delete_checkss = $nv_Request->get_string('delete_checkss', 'get,post');
    if ($id > 0 and $delete_checkss === md5($id . NV_CACHE_PREFIX . $client_info['session_id'])) {
        $weight=0;
        $sql = 'SELECT weight FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config WHERE id =' . $db->quote($id);
        $result = $db->query($sql);
        list($weight) = $result->fetch(3);

        $db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config  WHERE id = ' . $db->quote($id));

        $sql = 'SELECT id FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config_items WHERE cid =' . $id;
        $result = $db->query($sql);
        while (list($iid) = $result->fetch(3)) {
            // Xoa bang carrier_config_location
            $db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config_location WHERE iid = ' . $iid);

            // Xoa bang carrier_config_weight
            $db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config_weight WHERE iid = ' . $iid);

            // Xoa bang carrier_config_items
            $db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config_items WHERE cid = ' . $id);
        }

        // Xoa bang shops_carrier
        $db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_shops_carrier WHERE config_id = ' . $id);

        if ($weight > 0) {
            $sql = 'SELECT id, weight FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config WHERE weight >' . $weight;
            $result = $db->query($sql);
            while (list($id, $weight) = $result->fetch(3)) {
                $weight--;
                $db->query('UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config SET weight=' . $weight . ' WHERE id=' . intval($id));
            }
        }

        $nv_Cache->delMod($module_name);
        nv_jsonOutput([
            'status' => 'OK',
            'message' => $nv_Lang->getModule('delete_carrier_config_success')
        ]);
    } else {
        nv_jsonOutput([
            'status' => 'ERROR',
            'message' => $nv_Lang->getModule('delete_carrier_config_error')
        ]);
    }
}

if ($nv_Request->isset_request('change_status', 'post')) {
    $id = $nv_Request->get_int('id', 'post', 0);

    $sql = 'SELECT id FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config WHERE id=' . $id;
    $id = $db->query($sql)->fetchColumn();
    if (empty($id)) {
        nv_jsonOutput([
            'status' => 'ERROR',
            'message' => $nv_Lang->getModule('change_status_error')
        ]);
    }

    $new_status = $nv_Request->get_bool('new_status', 'post');
    $new_status = ( int )$new_status;

    $sql = 'UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config SET status=' . $new_status . ' WHERE id=' . $id;
    $db->query($sql);

    $nv_Cache->delMod($module_name);

    nv_jsonOutput([
        'status' => 'OK',
        'message' => $nv_Lang->getModule('change_status_success')
    ]);
}

$row = array();
$error = array();
$row['id'] = $nv_Request->get_int('id', 'post,get', 0);
$base_url = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op;
if ($row['id'] > 0) {
    $row = $db->query('SELECT * FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config WHERE id=' . $row['id'])->fetch();
    if (empty($row)) {
        nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op);
    }
} else {
    $row['id'] = 0;
    $row['title'] = '';
    $row['description'] = '';
    $row['status'] = 1;
}

if ($nv_Request->isset_request('submit', 'post')) {
    $row['title'] = $nv_Request->get_title('title', 'post', '');
    $row['description'] = $nv_Request->get_textarea('description', 'post');

    if (empty($row['title'])) {
        $error[] = $nv_Lang->getModule('carrier_config_error_required_name');
    }

    if (empty($error)) {
        try {
            if (empty($row['id'])) {
                $stmt = $db->prepare('INSERT INTO ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config (title, description, weight, status) VALUES (:title, :description, :weight, 1)');

                $weight = $db->query('SELECT max(weight) FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config')->fetchColumn();
                $weight = intval($weight) + 1;
                $stmt->bindParam(':weight', $weight, PDO::PARAM_INT);
            } else {
                $stmt = $db->prepare('UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config SET title = :title, description = :description WHERE id=' . $row['id']);
            }
            $stmt->bindParam(':title', $row['title'], PDO::PARAM_STR);
            $stmt->bindParam(':description', $row['description'], PDO::PARAM_STR, strlen($row['description']));

            $exc = $stmt->execute();
            if ($exc) {
                $nv_Cache->delMod($module_name);
                nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op);
            }
        } catch (PDOException $e) {
            trigger_error($e->getMessage());
        }
    }
}

// Fetch Limit
$show_view = false;
$per_page = 10;
$page = $nv_Request->get_int('page', 'post,get', 1);
$db->sqlreset()
    ->select('COUNT(*)')
    ->from($db_config['prefix'] . '_' . $module_data . '_carrier_config');
$sth = $db->prepare($db->sql());
$sth->execute();
$num_items = $sth->fetchColumn();

$db->select('*')
    ->order('weight ASC')
    ->limit($per_page)
    ->offset(($page - 1) * $per_page);
$sth = $db->prepare($db->sql());
$sth->execute();

$template = get_tpl_dir([$global_config['module_theme'], $global_config['admin_theme']], 'admin_future', '/modules/' . $module_file . '/carrier_config.tpl');
$tpl = new \NukeViet\Template\NVSmarty();
$tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $template . '/modules/' . $module_file);

$tpl->assign('LANG', $nv_Lang);
$tpl->assign('MODULE_NAME', $module_name);
$tpl->assign('OP', $op);
$tpl->assign('ROW', $row);
$tpl->assign('CAPTION', $row['id'] ? $nv_Lang->getModule('edit_carrier_config') : $nv_Lang->getModule('add_carrier_config'));

$tpl->assign('LOCALTION_URL', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=location');
$tpl->assign('CARRIER_URL', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=carrier');
$tpl->assign('CONFIG_URL', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=carrier_config');
$tpl->assign('SHOPS_URL', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=shops');

$generate_page = nv_generate_page($base_url, $num_items, $per_page, $page);
if (!empty($generate_page)) {
    $tpl->assign('GENERATE_PAGE', $generate_page);
}

$array_data = array();
while ($view = $sth->fetch()) {
    $view['link_edit'] = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op . '&amp;id=' . $view['id'];
    $view['link_config_items'] = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=carrier_config_items&amp;cid=' . $view['id'];
    $view['delete_checkss'] = md5($view['id'] . NV_CACHE_PREFIX . $client_info['session_id']);
    // Weight options
    $view['weight_options'] = array();
    for ($i = 1; $i <= $num_items; ++$i) {
        $view['weight_options'][] = array(
            'key' => $i,
            'title' => $i,
            'selected' => $i == $view['weight'] ? ' selected="selected"' : ''
        );
    }
    $array_data[] = $view;
}
$tpl->assign('VIEW', $array_data);

if (!empty($error)) {
    $tpl->assign('ERROR', implode('<br />', $error));
}

$tpl->assign('main', true);
$contents = $tpl->fetch('carrier_config.tpl');

$page_title = $nv_Lang->getModule('carrier_config_list');

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
