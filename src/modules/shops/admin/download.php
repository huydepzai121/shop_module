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

$data = [];
$error = [];
$table_name = $db_config['prefix'] . "_" . $module_data . "_files";
$data['id'] = $nv_Request->get_int('id', 'get', 0);
$popup = $nv_Request->get_bool('popup', 'get', 0);
$base_url = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op;
$groups_list = nv_groups_list();

// Load danh sách file điền vào select
if ($nv_Request->isset_request('get_files', 'post,get')) {
    $ids = $nv_Request->get_typed_array('ids', 'post,get', 'int', '');
    $ids[] = $nv_Request->get_int('id_new', 'post,get', 0);

    $sql = 'SELECT id, ' . NV_LANG_DATA . '_title title FROM ' . $db_config['prefix'] . '_' . $module_data . '_files WHERE status=1';
    $array_files = $nv_Cache->db($sql, 'id', $module_name);

    $option = '';
    if (!empty($array_files)) {
        foreach ($array_files as $files) {
            $option .= '<option value="' . $files['id'] . '"' . (in_array($files['id'], $ids) ? ' selected="selected"' : '') . '>' . $files['title'] . '</option>';
        }
    }
    nv_htmlOutput($option);
}

if ($nv_Request->isset_request('del', 'post,get')) {
    $id = $nv_Request->get_int('id', 'post,get', 0);
    if (empty($id)) {
        die('NO');
    }

    $count = $db->query('SELECT COUNT(*) FROM ' . $table_name . ' WHERE id=' . $id)->fetchColumn();
    if ($count > 0) {
        $result = $db->query('DELETE FROM ' . $table_name . ' WHERE id=' . $id);
        if ($result) {
            $result = $db->query('DELETE FROM ' . $table_name . '_rows WHERE id_files=' . $id);
            $nv_Cache->delMod($module_name);
            nv_htmlOutput('OK');
        }
    }
    nv_htmlOutput('NO');
}

if ($nv_Request->isset_request('change_active', 'get,post')) {
    $id = $nv_Request->get_int('id', 'post', 0);

    $sql = 'SELECT id FROM ' . $table_name . ' WHERE id=' . $id;
    $id = $db->query($sql)->fetchColumn();
    if (empty($id)) {
        die('NO_' . $id);
    }

    $new_status = $nv_Request->get_bool('new_status', 'post');
    $new_status = ( int )$new_status;

    $sql = 'UPDATE ' . $table_name . ' SET status=' . $new_status . ' WHERE id=' . $id;
    $db->query($sql);
    $nv_Cache->delMod($module_name);
    nv_htmlOutput('OK');
}

if ($nv_Request->isset_request('submit', 'post')) {
    $field_lang = nv_file_table($table_name);
    $data['id'] = $nv_Request->get_int('id', 'post', 0);
    $data['title'] = $nv_Request->get_title('title', 'post', '');
    $data['description'] = $nv_Request->get_textarea('description', '', 'br');
    $data['path'] = $nv_Request->get_title('path', 'post', '');

    $_dowload_groups = $nv_Request->get_array('download_groups', 'post', []);
    if (in_array(-1, $_dowload_groups)) {
        $data['download_groups'] = '-1';
    } else {
        $data['download_groups'] = ! empty($_dowload_groups) ? implode(',', nv_groups_post(array_intersect($_dowload_groups, array_keys($groups_list)))) : '';
    }

    $data['filesize'] = 0;
    $data['extension'] = '';

    if (empty($data['title'])) {
        die('NO_' . $nv_Lang->getModule('download_files_error_title'));
    }

    if (empty($data['path'])) {
        die('NO_' . $nv_Lang->getModule('download_files_error_path'));
    }

    if (nv_is_url($data['path'])) {
        $data['path'] = $data['path'];
    } else {
        $lu = strlen(NV_BASE_SITEURL . NV_UPLOADS_DIR . '/' . $module_upload . '/files/');
        $data['path'] = substr($data['path'], $lu);
        $real_file = NV_ROOTDIR . '/' . NV_UPLOADS_DIR . '/' . $module_upload .'/files/'. $data['path'];
        if (file_exists($real_file) and ($filesize = filesize($real_file)) != 0) {
            $data['filesize'] = $filesize;
            $data['extension'] = nv_getextension($real_file);
        } else {
            die('NO_' . $nv_Lang->getModule('download_files_error_path_valid'));
        }
    }

    if ($data['id'] > 0) {
        $stmt = $db->prepare("UPDATE " . $table_name . " SET path=:path, filesize=:filesize, extension=:extension, download_groups=:download_groups, " . NV_LANG_DATA . "_title=:title, " . NV_LANG_DATA . "_description=:description WHERE id =" . $data['id']);
        $stmt->bindParam(':title', $data['title'], PDO::PARAM_STR);
        $stmt->bindParam(':path', $data['path'], PDO::PARAM_STR);
        $stmt->bindParam(':filesize', $data['filesize'], PDO::PARAM_STR);
        $stmt->bindParam(':extension', $data['extension'], PDO::PARAM_STR);
        $stmt->bindParam(':download_groups', $data['download_groups'], PDO::PARAM_STR);
        $stmt->bindParam(':description', $data['description'], PDO::PARAM_STR);
        if ($stmt->execute()) {
            $nv_Cache->delMod($module_name);
            nv_htmlOutput('OK');
        } else {
            die('NO_' . $nv_Lang->getModule('errorsave'));
        }
    } else {
        $listfield = "";
        $listvalue = "";

        foreach ($field_lang as $field_lang_i) {
            list($flang, $fname) = $field_lang_i;
            $listfield .= ", " . $flang . "_" . $fname;
            if ($flang == NV_LANG_DATA) {
                $listvalue .= ", " . $db->quote($data[$fname]);
            } else {
                $listvalue .= ", " . $db->quote($data[$fname]);
            }
        }

        $sql = "INSERT INTO " . $table_name . " (
            path, filesize, extension, addtime, download_groups, status " . $listfield . "
        ) VALUES (
            :path, :filesize, :extension, " . NV_CURRENTTIME . ", :download_groups, 1 " . $listvalue . "
        )";
        $array_insert = [
            'path' => $data['path'],
            'filesize' => $data['filesize'],
            'extension' => $data['extension'],
            'download_groups' => $data['download_groups'],
        ];
        $new_id = $db->insert_id($sql, 'id', $array_insert);
        if ($new_id) {
            $nv_Cache->delMod($module_name);
            nv_htmlOutput('OK_' . $new_id);
        } else {
            die('NO_' . $nv_Lang->getModule('errorsave'));
        }
    }
}

if ($data['id'] > 0) {
    // Load data khi sửa
    $result = $db->query('SELECT id, ' . NV_LANG_DATA . '_title title, ' . NV_LANG_DATA . '_description description, path, download_groups FROM ' . $table_name . ' WHERE id=' . $data['id']);
    if ($result->rowCount()) {
        $row = $result->fetch();
        $data = array_merge($data, $row); // Merge với giá trị mặc định
    }
} else {
    // Khởi tạo giá trị mặc định khi thêm mới
    $data = [
        'id' => 0,
        'title' => '',
        'description' => '',
        'path' => '',
        'download_groups' => -1,
        'filesize' => 0,
        'extension' => '',
        'status' => 1
    ];
}

$array_search = [];
$array_search['keywords'] = $nv_Request->get_title('keywords', 'get', '');
$array_search['status'] = $nv_Request->get_int('status', 'get', -1);
if (!$popup) {
    $per_page = 20;
    $page = $nv_Request->get_int('page', 'post,get', 1);
    $where = '';

    $db->sqlreset()
        ->select('COUNT(*)')
        ->from($db_config['prefix'] . '_' . $module_data . '_files');

    if (!empty($array_search['keywords'])) {
        $where .= ' AND ' . NV_LANG_DATA . '_title LIKE :q_title OR ' . NV_LANG_DATA . '_description LIKE :q_description';
    }

    if ($array_search['status'] >= 0) {
        $where .= ' AND status = ' . $array_search['status'];
    }

    if (! empty($where)) {
        $db->where('1=1' . $where);
    }

    $sth = $db->prepare($db->sql());

    if (!empty($array_search['keywords'])) {
        $sth->bindValue(':q_title', '%' . $array_search['keywords'] . '%');
        $sth->bindValue(':q_description', '%' . $array_search['keywords'] . '%');
    }

    $sth->execute();
    $num_items = $sth->fetchColumn();

    $db->select('id, path, addtime, status, ' . NV_LANG_DATA . '_title title, ' . NV_LANG_DATA . '_description description')->order('id DESC')->limit($per_page)->offset(($page - 1) * $per_page);
    $sth = $db->prepare($db->sql());

    if (!empty($array_search['keywords'])) {
        $sth->bindValue(':q_title', '%' . $array_search['keywords'] . '%');
        $sth->bindValue(':q_description', '%' . $array_search['keywords'] . '%');
    }
    $sth->execute();
}

$template = get_tpl_dir([$global_config['module_theme'], $global_config['admin_theme']], 'admin_future', '/modules/' . $module_file . '/content.tpl');
$tpl = new \NukeViet\Template\NVSmarty();
$tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $template . '/modules/' . $module_file);

$tpl->assign('LANG', $nv_Lang);
$tpl->assign('GLANG', \NukeViet\Core\Language::$lang_global);
$tpl->assign('NV_BASE_ADMINURL', NV_BASE_ADMINURL);
$tpl->assign('NV_LANG_VARIABLE', NV_LANG_VARIABLE);
$tpl->assign('NV_LANG_DATA', NV_LANG_DATA);
$tpl->assign('NV_NAME_VARIABLE', NV_NAME_VARIABLE);
$tpl->assign('NV_OP_VARIABLE', NV_OP_VARIABLE);
$tpl->assign('MODULE_NAME', $module_name);
$tpl->assign('OP', $op);

$tpl->assign('SEARCH', $array_search);
$tpl->assign('ACTION', $base_url);
$tpl->assign('POPUP', $popup ? 'true' : 'false');
$tpl->assign('FILE_PATH', $data['path']);
$tpl->assign('UPLOADS_FILES_DIR', NV_UPLOADS_DIR . '/' . $module_upload . '/files');

$array_status = [
    '1' => $nv_Lang->getModule('review_status_1'),
    '0' => $nv_Lang->getModule('review_status_0')
];
$status_filter = [];
foreach ($array_status as $key => $value) {
    $status_filter[] = [
        'key' => $key,
        'value' => $value,
        'selected' => $array_search['status'] == $key ? 'selected="selected"' : ''
    ];
}
$tpl->assign('STATUS_FILTER', $status_filter);

$download_groups = explode(',', $data['download_groups']);
$groups_download = [];
$groups_download[] = [
    'value' => -1,
    'checked' => in_array(-1, $download_groups) ? ' checked="checked"' : '',
    'title' => $nv_Lang->getModule('download_setting_groups_module')
];
foreach ($groups_list as $_group_id => $_title) {
    $groups_download[] = [
        'value' => $_group_id,
        'checked' => in_array($_group_id, $download_groups) ? ' checked="checked"' : '',
        'title' => $_title
    ];
}
$tpl->assign('DOWNLOAD_GROUPS', $groups_download);

if (!$popup) {
    $array_data = [];
    while ($view = $sth->fetch()) {
        $view['url_edit'] = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op . '&amp;id=' . $view['id'] . '#edit';

        $view['count_product'] = $db->query('SELECT COUNT(*) FROM ' . $table_name . '_rows WHERE id_files=' . $view['id'])->fetchColumn();
        $view['download_hits'] = 0;
        $result = $db->query('SELECT download_hits FROM ' . $table_name . '_rows WHERE id_files=' . $view['id']);
        if ($result->rowCount() > 0) {
            while (list($download_hits) = $result->fetch(3)) {
                $view['download_hits'] += $download_hits;
            }
        }

        $view['addtime'] = nv_date('H:i d/m/Y', $view['addtime']);
        $view['active'] = $view['status'] ? 'checked="checked"' : '';
        $array_data[] = $view;
    }
    $tpl->assign('DATA', $array_data);

    if (!empty($generate_page)) {
        $tpl->assign('GENERATE_PAGE', $generate_page);
    }
}

if (!empty($error)) {
    $tpl->assign('ERROR', implode('<br />', $error));
}

$tpl->assign('main', true);
$contents = $tpl->fetch('download.tpl');

$page_title = $nv_Lang->getModule('download');

include NV_ROOTDIR . '/includes/header.php';
echo $popup ? $contents : nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
