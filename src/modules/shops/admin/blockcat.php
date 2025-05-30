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

$page_title = $nv_Lang->getModule('block');

$error = '';
$savecat = 0;
$currentpath = NV_UPLOADS_DIR . '/' . $module_upload . '/' . date('Y_m');
if (!file_exists($currentpath)) {
    nv_mkdir(NV_UPLOADS_REAL_DIR . '/' . $module_upload, date('Y_m'), true);
}

$data = array(
    'bid' => 0,
    'title' => '',
    'alias' => '',
    'description' => '',
    'bodytext' => '',
    'keywords' => '',
    'image' => '',
    'tag_title' => '',
    'tag_description' => ''
);

$table_name = $db_config['prefix'] . '_' . $module_data . '_block_cat';
$savecat = $nv_Request->get_int('savecat', 'post', 0);

// Xử lý AJAX
if ($nv_Request->isset_request('changeweight', 'post')) {
    $bid = $nv_Request->get_int('bid', 'post', 0);
    $new_weight = $nv_Request->get_int('new_weight', 'post', 0);
    
    $sql = 'SELECT COUNT(*) FROM ' . $table_name . ' WHERE bid=' . $bid;
    if ($db->query($sql)->fetchColumn()) {
        $sql = 'SELECT bid FROM ' . $table_name . ' WHERE bid!=' . $bid . ' ORDER BY weight ASC';
        $result = $db->query($sql);
        
        $weight = 0;
        while ($row = $result->fetch()) {
            ++$weight;
            if ($weight == $new_weight) ++$weight;
            $db->query('UPDATE ' . $table_name . ' SET weight=' . $weight . ' WHERE bid=' . $row['bid']);
        }
        
        $db->query('UPDATE ' . $table_name . ' SET weight=' . $new_weight . ' WHERE bid=' . $bid);
        nv_insert_logs(NV_LANG_DATA, $module_name, 'Change block weight', 'bid: ' . $bid . ', new weight: ' . $new_weight, $admin_info['userid']);
        
        $nv_Cache->delMod($module_name);
        nv_jsonOutput('OK');
    }
    nv_jsonOutput('ERR');
}

if ($nv_Request->isset_request('changeactive', 'post')) {
    $bid = $nv_Request->get_int('bid', 'post', 0);
    $new_status = $nv_Request->get_bool('new_status', 'post', false);
    
    $sql = 'UPDATE ' . $table_name . ' SET adddefault=' . ($new_status ? 1 : 0) . ' WHERE bid=' . $bid;
    if ($db->exec($sql)) {
        nv_insert_logs(NV_LANG_DATA, $module_name, 'Change block status', 'bid: ' . $bid . ', new status: ' . $new_status, $admin_info['userid']);
        $nv_Cache->delMod($module_name);
        nv_jsonOutput('OK');
    }
    nv_jsonOutput('ERR');
}

if ($nv_Request->isset_request('del', 'post')) {
    $bid = $nv_Request->get_int('bid', 'post', 0);
    
    $sql = 'DELETE FROM ' . $table_name . ' WHERE bid=' . $bid;
    if ($db->exec($sql)) {
        nv_fix_block_cat();
        nv_insert_logs(NV_LANG_DATA, $module_name, 'Delete block', 'bid: ' . $bid, $admin_info['userid']);
        $nv_Cache->delMod($module_name);
        nv_jsonOutput('OK');
    }
    nv_jsonOutput('ERR');
}

// Xử lý form
if (!empty($savecat)) {
    $field_lang = nv_file_table($table_name);

    $data['bid'] = $nv_Request->get_int('bid', 'post', 0);
    $data['title'] = nv_substr($nv_Request->get_title('title', 'post', '', 1), 0, 255);
    $data['keywords'] = nv_substr($nv_Request->get_title('keywords', 'post', '', 1), 0, 255);
    $data['alias'] = nv_substr($nv_Request->get_title('alias', 'post', '', 1), 0, 255);
    $data['description'] = $nv_Request->get_string('description', 'post', '');
    $data['description'] = nv_nl2br(nv_htmlspecialchars(strip_tags($data['description'])), '<br />');
    $data['bodytext'] = $nv_Request->get_editor('bodytext', 'post', NV_ALLOWED_HTML_TAGS);
    $data['tag_title'] = $nv_Request->get_title('tag_title', 'post', '');
    $data['tag_description'] = $nv_Request->get_textarea('tag_description', '', NV_ALLOWED_HTML_TAGS);

    $image = $nv_Request->get_string('image', 'post', '');
    if (is_file(NV_DOCUMENT_ROOT . $image)) {
        $lu = strlen(NV_BASE_SITEURL . NV_UPLOADS_DIR . '/' . $module_upload . '/');
        $data['image'] = substr($image, $lu);
    } else {
        $data['image'] = '';
    }

    // Cat mo ta cho chinh xac
    if (strlen($data['description']) > 255) {
        $data['description'] = nv_clean60($data['description'], 250);
    }

    $data['alias'] = ($data['alias'] == '') ? change_alias($data['title']) : change_alias($data['alias']);

    // Kiem tra loi
    if (empty($data['title'])) {
        $error = $nv_Lang->getModule('block_error_name');
    } else {
        if ($data['bid'] == 0) {
            $stmt = $db->prepare('SELECT bid FROM ' . $db_config['prefix'] . '_' . $module_data . '_block_cat WHERE ' . NV_LANG_DATA . '_alias= :alias');
            $stmt->bindParam(':alias', $data['alias'], PDO::PARAM_STR);
            $stmt->execute();
            if ($stmt->rowCount()) {
                $error = $nv_Lang->getModule('block_error_alias');
            } else {
                $weight = $db->query('SELECT max(weight) FROM ' . $db_config['prefix'] . '_' . $module_data . '_block_cat')->fetchColumn();
                $weight = intval($weight) + 1;
                $listfield = '';
                $listvalue = '';

                foreach ($field_lang as $field_lang_i) {
                    list ($flang, $fname) = $field_lang_i;
                    $listfield .= ', ' . $flang . '_' . $fname;
                    $listvalue .= ', :' . $flang . '_' . $fname;
                }

                $sql = "INSERT INTO " . $db_config['prefix'] . "_" . $module_data . "_block_cat (bid, adddefault,image, weight, add_time, edit_time " . $listfield . ") VALUES (NULL, 0, :image, " . $weight . ", " . NV_CURRENTTIME . ", " . NV_CURRENTTIME . " " . $listvalue . ")";

                $data_insert = array();
                $data_insert['image'] = $data['image'];
                foreach ($field_lang as $field_lang_i) {
                    list ($flang, $fname) = $field_lang_i;
                    $data_insert[$flang . '_' . $fname] = $data[$fname];
                }

                if ($db->insert_id($sql, 'bid', $data_insert)) {
                    $nv_Cache->delMod($module_name);
                    nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op);
                } else {
                    $error = $nv_Lang->getModule('errorsave');
                }
            }
        } else {
            $stmt = $db->prepare('SELECT bid FROM ' . $db_config['prefix'] . '_' . $module_data . '_block_cat WHERE ' . NV_LANG_DATA . '_alias= :alias AND bid!=' . $data['bid']);
            $stmt->bindParam(':alias', $data['alias'], PDO::PARAM_STR);
            $stmt->execute();
            if ($stmt->rowCount()) {
                $error = $nv_Lang->getModule('block_error_alias');
            } else {
                $stmt = $db->prepare('UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_block_cat SET ' . NV_LANG_DATA . '_title= :title, ' . NV_LANG_DATA . '_alias = :alias, ' . NV_LANG_DATA . '_description= :description, ' . NV_LANG_DATA . '_bodytext = :bodytext, ' . NV_LANG_DATA . '_keywords= :keywords, ' . NV_LANG_DATA . '_tag_title= :tag_title, ' . NV_LANG_DATA . '_tag_description= :tag_description, image = :image, edit_time=' . NV_CURRENTTIME . ' WHERE bid =' . $data['bid']);
                $stmt->bindParam(':title', $data['title'], PDO::PARAM_STR);
                $stmt->bindParam(':alias', $data['alias'], PDO::PARAM_STR);
                $stmt->bindParam(':description', $data['description'], PDO::PARAM_STR);
                $stmt->bindParam(':bodytext', $data['bodytext'], PDO::PARAM_STR);
                $stmt->bindParam(':keywords', $data['keywords'], PDO::PARAM_STR);
                $stmt->bindParam(':tag_title', $data['tag_title'], PDO::PARAM_STR);
                $stmt->bindParam(':tag_description', $data['tag_description'], PDO::PARAM_STR);
                $stmt->bindParam(':image', $data['image'], PDO::PARAM_STR);
                if ($stmt->execute()) {
                    $error = $nv_Lang->getModule('saveok');
                    $nv_Cache->delMod($module_name);
                    nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op);
                } else {
                    $error = $nv_Lang->getModule('errorsave');
                }
            }
        }
    }
}

$data['bid'] = $nv_Request->get_int('bid', 'get', 0);
if ($data['bid'] > 0) {
    list ($data['bid'], $data['title'], $data['alias'], $data['description'], $data['bodytext'], $data['keywords'], $data['tag_title'], $data['tag_description'], $data['image']) = $db->query('SELECT bid, ' . NV_LANG_DATA . '_title, ' . NV_LANG_DATA . '_alias, ' . NV_LANG_DATA . '_description, ' . NV_LANG_DATA . '_bodytext, ' . NV_LANG_DATA . '_keywords, ' . NV_LANG_DATA . '_tag_title, ' . NV_LANG_DATA . '_tag_description, image FROM ' . $db_config['prefix'] . '_' . $module_data . '_block_cat where bid=' . $data['bid'])->fetch(3);
    $nv_Lang->setModule('add_block_cat', $nv_Lang->getModule('edit_block_cat'));
}

if (!empty($data['image']) and file_exists(NV_UPLOADS_REAL_DIR . '/' . $module_upload . '/' . $data['image'])) {
    $data['image'] = NV_BASE_SITEURL . NV_UPLOADS_DIR . '/' . $module_upload . '/' . $data['image'];
    $currentpath = dirname($data['image']);
}

if (defined('NV_EDITOR')) require_once NV_ROOTDIR . '/' . NV_EDITORSDIR . '/' . NV_EDITOR . '/nv.php';
$data['bodytext'] = htmlspecialchars(nv_editor_br2nl($data['bodytext']));
if (defined('NV_EDITOR') and nv_function_exists('nv_aleditor')) {
    $data['bodytext'] = nv_aleditor('bodytext', '100%', '300px', $data['bodytext']);
} else {
    $data['bodytext'] = '<textarea style="width:100%;height:300px" name="bodytext">' . $data['bodytext'] . '</textarea>';
}

// Lấy dữ liệu block
$sql = 'SELECT bid, adddefault, ' . NV_LANG_DATA . '_title, ' . NV_LANG_DATA . '_alias, ' . NV_LANG_DATA . '_description, weight FROM ' . $table_name . ' ORDER BY weight ASC';
$result = $db->query($sql);

// Tạo mảng trạng thái
$status_options = [
    ['key' => 0, 'value' => $nv_Lang->getModule('no')],
    ['key' => 1, 'value' => $nv_Lang->getModule('yes')]
];

$blocks = [];
while ($row = $result->fetch()) {
    $numnews = $db->query('SELECT COUNT(*) FROM ' . $db_config['prefix'] . '_' . $module_data . '_block WHERE bid=' . $row['bid'])->fetchColumn();

    $weight_options = [];
    $sql = 'SELECT bid FROM ' . $table_name . ' ORDER BY weight ASC';
    $result_weight = $db->query($sql);
    $weight = 0;
    while ($weight_row = $result_weight->fetch()) {
        ++$weight;
        $weight_options[] = [
            'pos' => $weight,
            'selected' => ($weight == $row['weight']) ? true : false
        ];
    }

    $blocks[] = [
        'bid' => $row['bid'],
        'title' => $row[NV_LANG_DATA . '_title'],
        'alias' => $row[NV_LANG_DATA . '_alias'],
        'description' => $row[NV_LANG_DATA . '_description'],
        'weight' => $row['weight'],
        'weight_options' => $weight_options,
        'adddefault' => $row['adddefault'] ? true : false,
        'numnews' => $numnews,
        'link_edit' => NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=blockcat&amp;bid=' . $row['bid']
    ];
}
$template = get_tpl_dir([$global_config['module_theme'], $global_config['admin_theme']], 'admin_future', '/modules/' . $module_file . '/blockcat.tpl');
$tpl = new \NukeViet\Template\NVSmarty();
$tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $template . '/modules/' . $module_file);
$tpl->assign('LANG', $nv_Lang);
$tpl->assign('MODULE_NAME', $module_name);
$tpl->assign('OP', $op);
$tpl->assign('UPLOAD_CURRENT', $currentpath);
$tpl->assign('BLOCKS', $blocks);
$tpl->assign('DATA', $data);
$tpl->assign('STATUS_OPTIONS', $status_options);

if ($error != '') {
    $tpl->assign('ERROR', $error);
}

if ($data['alias'] != '') {
    $tpl->assign('SHOW_ALIAS', true);
}

$contents = $tpl->fetch('blockcat.tpl');

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
