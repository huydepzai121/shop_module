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
    if ($new_vid > 0) {
        $sql = 'SELECT id FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier WHERE id!=' . $id . ' ORDER BY weight ASC';
        $result = $db->query($sql);
        $weight = 0;
        while ($row = $result->fetch()) {
            ++$weight;
            if ($weight == $new_vid) {
                ++$weight;
            }
            $sql = 'UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_carrier SET weight=' . $weight . ' WHERE id=' . $row['id'];
            $db->query($sql);
        }
        $sql = 'UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_carrier SET weight=' . $new_vid . ' WHERE id=' . $id;
        $db->query($sql);
        nv_jsonOutput([
            'status' => 'OK',
            'message' => $nv_Lang->getModule('carrier_weight_success')
        ]);
    }
    else {
        nv_jsonOutput([
            'status' => 'ERROR',
            'message' => $nv_Lang->getModule('carrier_weight_error')
        ]);
    }
}

if ($nv_Request->isset_request('delete_carrier', 'post')) {
    $id = $nv_Request->get_int('id', 'post', 0);
    if ($id > 0) {
        $weight=0;
        $sql = 'SELECT weight FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier WHERE id =' . $db->quote($id);
        $result = $db->query($sql);
        list($weight) = $result->fetch(3);

        $db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier  WHERE id = ' . $db->quote($id));

        // Xoa bang shops_carrier
        $db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_shops_carrier WHERE carrier_id = ' . $id);

        if ($weight > 0) {
            $sql = 'SELECT id, weight FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier WHERE weight >' . $weight;
            $result = $db->query($sql);
            while (list($id, $weight) = $result->fetch(3)) {
                $weight--;
                $db->query('UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_carrier SET weight=' . $weight . ' WHERE id=' . intval($id));
            }
        }

        nv_jsonOutput([
            'status' => 'OK',
            'message' => $nv_Lang->getModule('carrier_delete_success')
        ]);
    } else {
        nv_jsonOutput([
            'status' => 'ERROR',
            'message' => $nv_Lang->getModule('carrier_delete_error')
        ]);
    }
}

if ($nv_Request->isset_request('change_active', 'post')) {
    $id = $nv_Request->get_int('id', 'post', 0);

    $sql = 'SELECT id FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier WHERE id=' . $id;
    $id = $db->query($sql)->fetchColumn();
    if (empty($id)) {
        nv_jsonOutput([
            'status' => 'ERROR',
            'message' => $nv_Lang->getModule('carrier_error_required_name')
        ]);
    }

    $new_status = $nv_Request->get_bool('new_status', 'post');
    $new_status = ( int )$new_status;

    $sql = 'UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_carrier SET status=' . $new_status . ' WHERE id=' . $id;
    $db->query($sql);

    $nv_Cache->delMod($module_name);

    nv_jsonOutput([
        'status' => 'OK',
        'message' => $nv_Lang->getModule('carrier_active_success')
    ]);
}

$row = [];
$currentpath = NV_UPLOADS_DIR . '/' . $module_upload . '/' . date('Y_m');
if (!file_exists($currentpath)) {
    nv_mkdir(NV_UPLOADS_REAL_DIR . '/' . $module_upload, date('Y_m'), true);
}
$error = array();
$row['id'] = $nv_Request->get_int('id', 'post,get', 0);
if ($nv_Request->isset_request('submit', 'post')) {
    $row['name'] = $nv_Request->get_title('name', 'post', '');
    $row['phone'] = $nv_Request->get_title('phone', 'post', '');
    $row['address'] = $nv_Request->get_title('address', 'post', '');
    $row['logo'] = $nv_Request->get_title('logo', 'post', '');
    $row['description'] = $nv_Request->get_editor('description', '', NV_ALLOWED_HTML_TAGS);
    $row['status'] = $nv_Request->get_int('status', 'post', 0);

    if (empty($row['name'])) {
        $error[] = $nv_Lang->getModule('carrier_error_required_name');
    }

    if (empty($error)) {
        try {
            if (empty($row['id'])) {
                $stmt = $db->prepare('INSERT INTO ' . $db_config['prefix'] . '_' . $module_data . '_carrier (name, phone, address, logo, description, weight, status) VALUES (:name, :phone, :address, :logo, :description, :weight, 1)');

                $weight = $db->query('SELECT max(weight) FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier')->fetchColumn();
                $weight = intval($weight) + 1;
                $stmt->bindParam(':weight', $weight, PDO::PARAM_INT);
            } else {
                $stmt = $db->prepare('UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_carrier SET name = :name, phone = :phone, address = :address, logo = :logo, description = :description WHERE id=' . $row['id']);
            }
            $stmt->bindParam(':name', $row['name'], PDO::PARAM_STR);
            $stmt->bindParam(':phone', $row['phone'], PDO::PARAM_STR);
            $stmt->bindParam(':address', $row['address'], PDO::PARAM_STR);
            $stmt->bindParam(':logo', $row['logo'], PDO::PARAM_STR);
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
} elseif ($row['id'] > 0) {
    $row = $db->query('SELECT * FROM ' . $db_config['prefix'] . '_' . $module_data . '_carrier WHERE id=' . $row['id'])->fetch();
    if (empty($row)) {
        nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op);
    }
    $caption = $nv_Lang->getModule('edit_carrier');
} else {
    $row['id'] = 0;
    $row['name'] = '';
    $row['phone'] = '';
    $row['address'] = '';
    $row['logo'] = '';
    $row['description'] = '';
    $row['status'] = 0;
    $caption = $nv_Lang->getModule('add_carrier');
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

if (!empty($row['logo']) and file_exists(NV_UPLOADS_REAL_DIR . '/' . $module_upload . '/' . $row['logo'])) {
    $row['logo'] = NV_BASE_SITEURL . NV_UPLOADS_DIR . '/' . $module_upload . '/' . $row['logo'];
    $currentpath = dirname($row['logo']);
}

// Fetch Limit
$per_page = 5;
$page = $nv_Request->get_int('page', 'post,get', 1);
$db->sqlreset()
    ->select('COUNT(*)')
    ->from($db_config['prefix'] . '_' . $module_data . '_carrier');
$sth = $db->prepare($db->sql());
$sth->execute();
$num_items = $sth->fetchColumn();

$db->select('*')
    ->order('weight ASC')
    ->limit($per_page)
    ->offset(($page - 1) * $per_page);
$result = $db->query($db->sql());
while ($row_s = $result->fetch()) {
    $list_views[] = $row_s;
}

$template = get_tpl_dir([$global_config['module_theme'], $global_config['admin_theme']], 'admin_future', '/modules/' . $module_file . '/carrier.tpl');
$tpl = new \NukeViet\Template\NVSmarty();
$tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $template . '/modules/' . $module_file);
$tpl->assign('LANG', $nv_Lang);
$tpl->assign('ROW', $row);
$tpl->assign('NV_UPLOADS_DIR', NV_UPLOADS_DIR);
$tpl->assign('MODULE_NAME', $module_name);
$tpl->assign('NV_BASE_ADMINURL', NV_BASE_ADMINURL);
$tpl->assign('NV_LANG_VARIABLE', NV_LANG_VARIABLE);
$tpl->assign('NV_LANG_DATA', NV_LANG_DATA);
$tpl->assign('NV_NAME_VARIABLE', NV_NAME_VARIABLE);
$tpl->assign('NV_OP_VARIABLE', NV_OP_VARIABLE);
$tpl->assign('OP', $op);
$tpl->assign('UPLOAD_CURRENT', $currentpath);
$tpl->assign('CAPTION', $caption);
$tpl->assign('LOCALTION_URL', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=location');
$tpl->assign('CARRIER_URL', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=carrier');
$tpl->assign('CONFIG_URL', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=carrier_config');
$tpl->assign('SHOPS_URL', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=shops');

if (!empty($list_views)) {
    $array_views = [];
    foreach ($list_views as $view) {
        $array_weight = [];
        for ($i = 1; $i <= $num_items; ++$i) {
            $array_weight[] = [
                'key' => $i,
                'title' => $i,
                'selected' => $i == $view['weight'] ? 'selected="selected"' : ''
            ];
        }
        $view['status'] = $view['status'] ? 'checked="checked"' : '';
        $view['link_edit'] = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op . '&amp;id=' . $view['id'];
        $view['link_config'] = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=carrier_config&amp;id=' . $view['id'];
        $view['link_delete'] = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op . '&amp;delete_id=' . $view['id'] . '&amp;delete_checkss=' . md5($view['id'] . NV_CACHE_PREFIX . $client_info['session_id']);
        $view['weight_options'] = $array_weight;
        $array_views[] = $view;
    }
    $tpl->assign('VIEWS', $array_views);
}

if (! empty($error)) {
    $tpl->assign('ERROR', implode('<br />', $error));
}

$contents = $tpl->fetch('carrier.tpl');

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
