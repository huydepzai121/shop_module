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

if ($nv_Request->isset_request('ajax_action', 'post')) {
    $id = $nv_Request->get_int('id', 'post', 0);
    $new_vid = $nv_Request->get_int('new_vid', 'post', 0);

    if ($new_vid > 0) {
        $sql = 'SELECT id FROM ' . $db_config['prefix'] . '_' . $module_data . '_shops WHERE id!=' . $id . ' ORDER BY weight ASC';
        $result = $db->query($sql);
        $weight = 0;
        while ($row = $result->fetch()) {
            ++$weight;
            if ($weight == $new_vid) {
                ++$weight;
            }
            $sql = 'UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_shops SET weight=' . $weight . ' WHERE id=' . $row['id'];
            $db->query($sql);
        }
        $sql = 'UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_shops SET weight=' . $new_vid . ' WHERE id=' . $id;
        $db->query($sql);
        $nv_Cache->delMod($module_name);
        nv_jsonOutput([
            'status' => 'OK',
            'message' => $nv_Lang->getModule('success_save')
        ]);
    } else {
        nv_jsonOutput([
            'status' => 'NO',
            'message' => $nv_Lang->getModule('error_save')
        ]);
    }
    
}

if ($nv_Request->isset_request('delete_id', 'get,post') and $nv_Request->isset_request('delete_checkss', 'get,post')) {
    $id = $nv_Request->get_int('delete_id', 'get,post');
    $delete_checkss = $nv_Request->get_string('delete_checkss', 'get,post');
    if ($id > 0 and $delete_checkss == md5($id . NV_CACHE_PREFIX . $client_info['session_id'])) {
        $weight=0;
        $sql = 'SELECT weight FROM ' . $db_config['prefix'] . '_' . $module_data . '_shops WHERE id =' . $db->quote($id);
        $result = $db->query($sql);
        list($weight) = $result->fetch(3);

        $db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_shops  WHERE id = ' . $db->quote($id));

        // Xoa bang shops_carrier
        $db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_shops_carrier WHERE shops_id = ' . $id);

        if ($weight > 0) {
            $sql = 'SELECT id, weight FROM ' . $db_config['prefix'] . '_' . $module_data . '_shops WHERE weight >' . $weight;
            $result = $db->query($sql);
            while (list($id, $weight) = $result->fetch(3)) {
                $weight--;
                $db->query('UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_shops SET weight=' . $weight . ' WHERE id=' . intval($id));
            }
        }
        $nv_Cache->delMod($module_name);
        nv_jsonOutput([
            'status' => 'OK',
            'message' => $nv_Lang->getModule('success_delete')
        ]);
    } else {
        nv_jsonOutput([
            'status' => 'NO',
            'message' => $nv_Lang->getModule('error_delete')
        ]);
    }
}

if ($nv_Request->isset_request('change_active', 'post')) {
    $id = $nv_Request->get_int('id', 'post', 0);

    $sql = 'SELECT id FROM ' . $db_config['prefix'] . '_' . $module_data . '_shops WHERE id=' . $id;
    $id = $db->query($sql)->fetchColumn();
    if (empty($id)) {
        nv_jsonOutput([
            'status' => 'NO',
            'message' => $nv_Lang->getModule('error_delete')
        ]);
    }

    $new_status = $nv_Request->get_bool('new_status', 'post');
    $new_status = ( int )$new_status;

    $sql = 'UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_shops SET status=' . $new_status . ' WHERE id=' . $id;
    $db->query($sql);

    $nv_Cache->delMod($module_name);
    nv_jsonOutput([
        'status' => 'OK',
        'message' => $nv_Lang->getModule('success_change_active')
    ]);
}

$row = array();
$config_carrier_old = array();
$error = array();
$row['id'] = $nv_Request->get_int('id', 'post,get', 0);

// Lay nha cung cap dich vu van chuyen
$sql = 'SELECT id, name FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier WHERE status = 1 ORDER BY weight ASC';
$global_array_carrier = $nv_Cache->db($sql, 'id', $module_name);

// Lay cau hinh nha cung cap dich vu van chuyen
$sql = 'SELECT id, title FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier_config WHERE status = 1 ORDER BY weight ASC';
$global_array_carrier_config = $nv_Cache->db($sql, 'id', $module_name);

if (empty($global_array_carrier)) {
    nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=carrier');
}

if (empty($global_array_carrier_config)) {
    nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=carrier_config');
}

if ($row['id'] > 0) {
    $row = $db->query('SELECT * FROM ' . $db_config['prefix'] . '_' . $module_data . '_shops WHERE id=' . $row['id'])->fetch();
    if (empty($row)) {
        nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op);
    }

    $row['config_carrier'] = array();
    $result = $db->query('SELECT * FROM ' . $db_config['prefix'] . '_' . $module_data . '_shops_carrier WHERE shops_id=' . $row['id']);
    if ($result) {
        while ($carrier = $result->fetch()) {
            $row['config_carrier'][] = array( 'carrier' => intval($carrier['carrier_id']), 'config' => intval($carrier['config_id']) );
        }
    }
    $config_carrier_old = $row['config_carrier'];
} else {
    $row['id'] = 0;
    $row['name'] = '';
    $row['location'] = 0;
    $row['address'] = '';
    $row['description'] = '';
    $row['status'] = 0;
}

if ($nv_Request->isset_request('submit', 'post')) {
    $row['name'] = $nv_Request->get_title('name', 'post', '');
    $row['location'] = $nv_Request->get_int('location', 'post', 0);
    $row['address'] = $nv_Request->get_title('address', 'post', '');
    $row['config_carrier'] = $nv_Request->get_array('config_carrier', 'post', array());
    $row['description'] = $nv_Request->get_editor('description', '', NV_ALLOWED_HTML_TAGS);
    $row['status'] = $nv_Request->get_int('status', 'post', 0);

    if (! empty($row['config_carrier'])) {
        foreach ($row['config_carrier'] as $key => $array) {
            if (empty($array['carrier']) or empty($array['config'])) {
                unset($row['config_carrier'][$key]);
            }
        }
    }

    if (empty($row['name'])) {
        $error[] = $nv_Lang->getModule('shops_error_required_name');
    } elseif (empty($row['location'])) {
        $error[] = $nv_Lang->getModule('shops_error_required_location');
    }

    if (empty($error)) {
        try {
            if (empty($row['id'])) {
                $sql = 'INSERT INTO ' . $db_config['prefix'] . '_' . $module_data . '_shops (name, location, address, description, weight, status) VALUES (:name, :location, :address, :description, :weight, 1)';

                $weight = $db->query('SELECT max(weight) FROM ' . $db_config['prefix'] . '_' . $module_data . '_shops')->fetchColumn();
                $weight = intval($weight) + 1;

                $data_insert = array( );
                $data_insert['name'] = $row['name'];
                $data_insert['location'] = $row['location'];
                $data_insert['address'] = $row['address'];
                $data_insert['description'] = $row['description'];
                $data_insert['weight'] = $weight;
                $insert_id = $db->insert_id($sql, 'id', $data_insert);
            } else {
                $stmt = $db->prepare('UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_shops SET name = :name, location = :location, address = :address, description = :description WHERE id=' . $row['id']);
                $stmt->bindParam(':name', $row['name'], PDO::PARAM_STR);
                $stmt->bindParam(':location', $row['location'], PDO::PARAM_STR);
                $stmt->bindParam(':address', $row['address'], PDO::PARAM_STR);
                $stmt->bindParam(':description', $row['description'], PDO::PARAM_STR, strlen($row['description']));
                $exc = $stmt->execute();
            }

            if ($exc or $insert_id) {
                if ($row['config_carrier'] != $config_carrier_old) {
                    if (!empty($row['id'])) {
                        $db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_shops_carrier WHERE shops_id=' . $row['id']);
                    }
                    foreach ($row['config_carrier'] as $array) {
                        if (empty($row['id'])) {
                            $db->query('INSERT INTO ' . $db_config['prefix'] . '_' . $module_data . '_shops_carrier ( shops_id, carrier_id, config_id ) VALUES (' . $insert_id . ', ' . $array['carrier'] . ', ' . $array['config'] . ')');
                        } else {
                            $db->query('INSERT INTO ' . $db_config['prefix'] . '_' . $module_data . '_shops_carrier ( shops_id, carrier_id, config_id ) VALUES (' . $row['id'] . ', ' . $array['carrier'] . ', ' . $array['config'] . ')');
                        }
                    }
                }

                $nv_Cache->delMod($module_name);
                nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op);
            }
        } catch (PDOException $e) {
            $error[] = $nv_Lang->getModule('shops_error_exist_carrier');
            trigger_error($e->getMessage());
        }
    }
}

if (defined('NV_EDITOR')) {
    require_once NV_ROOTDIR . '/' . NV_EDITORSDIR . '/' . NV_EDITOR . '/nv.php';
}
$row['description'] = htmlspecialchars(nv_editor_br2nl($row['description']));
if (defined('NV_EDITOR') and nv_function_exists('nv_aleditor')) {
    $row['description'] = nv_aleditor('description', '100%', '300px', $row['description'], 'Basic');
} else {
    $row['description'] = '<textarea style="width:100%;height:300px" name="description">' . $row['description'] . '</textarea>';
}

$show_view = true;
    $per_page = 5;
    $page = $nv_Request->get_int('page', 'post,get', 1);
    $db->sqlreset()
        ->select('COUNT(*)')
        ->from($db_config['prefix'] . '_' . $module_data . '_shops');
    $sth = $db->prepare($db->sql());
    $sth->execute();
    $num_items = $sth->fetchColumn();

    $db->select('*')
        ->order('weight ASC')
        ->limit($per_page)
        ->offset(($page - 1) * $per_page);
    $sth = $db->prepare($db->sql());
    $sth->execute();

// Lay dia diem
$sql = "SELECT id, parentid, title, lev FROM " . $db_config['prefix'] . '_' . $module_data . "_location ORDER BY sort ASC";
$result = $db->query($sql);
$array_location_list = array();
$array_location = array();
$array_location_list[0] = array( '0', $nv_Lang->getModule('location_chose') );
while (list($id_i, $parentid_i, $title_i, $lev_i) = $result->fetch(3)) {
    $array_location[$id_i] = array( 'id' => $id_i, 'parentid'=> $parentid_i, 'title' => $title_i, 'lev' => $lev_i );
    $xtitle_i = '';
    if ($lev_i > 0) {
        $xtitle_i .= '&nbsp;';
        for ($i = 1; $i <= $lev_i; $i++) {
            $xtitle_i .= '&nbsp;&nbsp;&nbsp;';
        }
    }
    $xtitle_i .= $title_i;
    $array_location_list[] = array( $id_i, $xtitle_i );
}
$template = get_tpl_dir([$global_config['module_theme'], $global_config['admin_theme']], 'admin_default', '/modules/' . $module_file . '/main.tpl');
$tpl = new \NukeViet\Template\NVSmarty();
$tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $template . '/modules/' . $module_file);

$tpl->assign('LANG', $nv_Lang);
$tpl->assign('NV_LANG_VARIABLE', NV_LANG_VARIABLE);
$tpl->assign('NV_LANG_DATA', NV_LANG_DATA);
$tpl->assign('NV_BASE_ADMINURL', NV_BASE_ADMINURL);
$tpl->assign('NV_BASE_SITEURL', NV_BASE_SITEURL);
$tpl->assign('NV_NAME_VARIABLE', NV_NAME_VARIABLE);
$tpl->assign('NV_OP_VARIABLE', NV_OP_VARIABLE);
$tpl->assign('NV_UPLOADS_DIR', NV_UPLOADS_DIR);
$tpl->assign('MODULE_NAME', $module_name);
$tpl->assign('MODULE_FILE', $module_file);
$tpl->assign('OP', $op);
$tpl->assign('ROW', $row);

$tpl->assign('LOCALTION_URL', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=location');
$tpl->assign('CARRIER_URL', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=carrier');
$tpl->assign('CONFIG_URL', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=carrier_config');
$tpl->assign('SHOPS_URL', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=shops');

// Xử lý dữ liệu cho view
$array_data = array();
if ($show_view) {
    while ($view = $sth->fetch()) {
        $view['weight_options'] = array();
        for ($i = 1; $i <= $num_items; ++$i) {
            $view['weight_options'][] = array(
                'key' => $i,
                'title' => $i,
                'selected' => ($i == $view['weight']) ? ' selected="selected"' : ''
            );
        }

        $view['location_string'] = $array_location[$view['location']]['title'];
        while ($array_location[$view['location']]['parentid'] > 0) {
            $items = $array_location[$array_location[$view['location']]['parentid']];
            $view['location_string'] .= ', ' . $items['title'];
            $array_location[$view['location']]['parentid'] = $items['parentid'];
        }

        $view['status'] = $view['status'] ? 'checked="checked"' : '';
        $view['link_config'] = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=carrier_config&amp;id=' . $view['id'];
        $view['link_edit'] = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op . '&amp;id=' . $view['id'];
        $view['link_delete'] = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op . '&amp;delete_id=' . $view['id'] . '&amp;delete_checkss=' . md5($view['id'] . NV_CACHE_PREFIX . $client_info['session_id']);
        $view['delete_checkss'] = md5($view['id'] . NV_CACHE_PREFIX . $client_info['session_id']);
        $array_data[] = $view;
    }
}
$tpl->assign('DATA', $array_data);

// Xử lý locations
$array_locations = array();
foreach ($array_location_list as $rows_i) {
    $array_locations[] = array(
        'id' => $rows_i[0],
        'title' => $rows_i[1],
        'selected' => ($row['location'] == $rows_i[0]) ? ' selected="selected"' : ''
    );
}
$tpl->assign('LOCATIONS', $array_locations);

// Xử lý config carrier
$array_configs = array();
$row['config_carrier'][] = array(
    'carrier' => 0,
    'config' => 0,
);
$i = 0;
foreach ($row['config_carrier'] as $config) {
    $config_item = array(
        'id' => $i++,
        'carrier' => $config['carrier'],
        'config' => $config['config'],
        'carriers' => array(),
        'carrier_configs' => array()
    );
    
    if (!empty($global_array_carrier)) {
        foreach ($global_array_carrier as $carrier_id => $carrier) {
            $config_item['carriers'][] = array(
                'key' => $carrier_id,
                'value' => $carrier['name'],
                'selected' => ($config['carrier'] == $carrier_id) ? 'selected="selected"' : ''
            );
        }
    }

    if (!empty($global_array_carrier_config)) {
        foreach ($global_array_carrier_config as $carrier_config_id => $carrier_config) {
            $config_item['carrier_configs'][] = array(
                'id' => $carrier_config_id,
                'title' => $carrier_config['title'],
                'selected' => ($config['config'] == $carrier_config_id) ? 'selected="selected"' : ''
            );
        }
    }
    
    $array_configs[] = $config_item;
}
$tpl->assign('CONFIGS', $array_configs);
$tpl->assign('config_carrier_count', count($array_configs));

if (!empty($error)) {
    $tpl->assign('ERROR', implode('<br />', $error));
}

$tpl->assign('main', true);
$contents = $tpl->fetch('shops.tpl');

$page_title = $nv_Lang->getModule('shops');

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
