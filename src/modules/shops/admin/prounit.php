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

$page_title = $nv_Lang->getModule('prounit');

$error = "";
$savecat = 0;

$data = array( "title" => "", 'note' => "" );
$table_name = $db_config['prefix'] . "_" . $module_data . "_units";
$data['id'] = $nv_Request->get_int('id', 'post,get', 0);
$savecat = $nv_Request->get_int('savecat', 'post', 0);

// Xử lý khi submit form bằng AJAX
if (! empty($savecat)) {
    $field_lang = nv_file_table($table_name);
    $data['title'] = nv_substr($nv_Request->get_title('title', 'post', '', 1), 0, 255);
    $data['note'] = $nv_Request->get_title('note', 'post', '', 1);
    
    $json = array();
    
    // Kiểm tra nếu tiêu đề trống
    if (empty($data['title'])) {
        $json['status'] = 'error';
        $json['mess'] = $nv_Lang->getModule('error_title_empty');
        $json['input'] = 'title';
        nv_jsonOutput($json);
    }

    if ($data['id'] == 0) {
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

        $sql = "INSERT INTO " . $table_name . " (id " . $listfield . ") VALUES (NULL " . $listvalue . ")";

        if ($db->insert_id($sql)) {
            $nv_Cache->delMod($module_name);
            $json['status'] = 'OK';
            $json['mess'] = 'Đơn vị sản phẩm đã được thêm thành công';
            nv_jsonOutput($json);
        } else {
            $json['status'] = 'error';
            $json['mess'] = 'Đơn vị sản phẩm không được thêm';
            nv_jsonOutput($json);
        }
    } else {
        $stmt = $db->prepare("UPDATE " . $table_name . " SET " . NV_LANG_DATA . "_title= :title, " . NV_LANG_DATA . "_note = :note WHERE id =" . $data['id']);
        $stmt->bindParam(':title', $data['title'], PDO::PARAM_STR);
        $stmt->bindParam(':note', $data['note'], PDO::PARAM_STR);
        if ($stmt->execute()) {
            $nv_Cache->delMod($module_name);
            $json['status'] = 'OK';
            $json['mess'] = 'Đơn vị sản phẩm đã được cập nhật thành công';
            nv_jsonOutput($json);
        } else {
            $json['status'] = 'error';
            $json['mess'] = 'Đơn vị sản phẩm không được cập nhật';
            nv_jsonOutput($json);
        }
    }
}

// Xử lý xóa đơn vị sản phẩm qua AJAX
if ($nv_Request->isset_request('ajaxdel', 'post')) {
    $id = $nv_Request->get_int('id', 'post', 0);
    $json = array();
    
    if ($id) {
        $sql = "DELETE FROM " . $table_name . " WHERE id=" . $id;
        if ($db->query($sql)) {
            $nv_Cache->delMod($module_name);
            $json['status'] = 'OK';
            $json['mess'] = 'Đơn vị sản phẩm đã được xóa thành công';
        } else {
            $json['status'] = 'error';
            $json['mess'] = 'Đơn vị sản phẩm không được xóa';
        }
    } else {
        $json['status'] = 'error';
        $json['mess'] = 'Đơn vị sản phẩm không được xóa';
    }
    
    nv_jsonOutput($json);
}

// Lấy thông tin đơn vị cần sửa
if ($data['id'] > 0) {
    $data_old = $db->query("SELECT * FROM " . $table_name . " WHERE id=" . $data['id'])->fetch();
    $data = array(
        "id" => $data_old['id'],
        "title" => $data_old[NV_LANG_DATA . '_title'],
        "note" => $data_old[NV_LANG_DATA . '_note']
    );
}

$tpl = new \NukeViet\Template\NVSmarty();
$tpl->registerPlugin('modifier', 'nformat', 'nv_number_format');
$tpl->registerPlugin('modifier', 'dformat', 'nv_datetime_format');
$tpl->setTemplateDir(get_module_tpl_dir('prounit.tpl'));
$tpl->assign('LANG', $nv_Lang);
$tpl->assign('MODULE_NAME', $module_name);
$tpl->assign('OP', $op);
$tpl->assign('DATA', $data);
$tpl->assign('CAPTION', $nv_Lang->getModule('prounit_info'));

if (!empty($error)) {
    $tpl->assign('ERROR', $error);
}

$rows = [];
$result = $db->query("SELECT id, " . NV_LANG_DATA . "_title, " . NV_LANG_DATA . "_note FROM " . $table_name . " ORDER BY id DESC");
while (list($id, $title, $note) = $result->fetch(3)) {
    $rows[] = [
        'title' => $title,
        'note' => $note,
        'id' => $id,
        'link_edit' => NV_BASE_ADMINURL . "index.php?" . NV_LANG_VARIABLE . "=" . NV_LANG_DATA . "&" . NV_NAME_VARIABLE . "=" . $module_name . "&" . NV_OP_VARIABLE . "=" . $op . "&id=" . $id,
        'link_del' => NV_BASE_ADMINURL . "index.php?" . NV_LANG_VARIABLE . "=" . NV_LANG_DATA . "&" . NV_NAME_VARIABLE . "=" . $module_name . "&" . NV_OP_VARIABLE . "=delunit&id=" . $id
    ];
}
$tpl->assign('ROWS', $rows);

$tpl->assign('NV_BASE_ADMINURL', NV_BASE_ADMINURL);
$tpl->assign('NV_NAME_VARIABLE', NV_NAME_VARIABLE);
$tpl->assign('NV_OP_VARIABLE', NV_OP_VARIABLE);
$tpl->assign('NV_LANG_VARIABLE', NV_LANG_VARIABLE);
$tpl->assign('NV_LANG_DATA', NV_LANG_DATA);

$tpl->assign('URL_DEL', NV_BASE_ADMINURL . "index.php?" . NV_LANG_VARIABLE . "=" . NV_LANG_DATA . "&" . NV_NAME_VARIABLE . "=" . $module_name . "&" . NV_OP_VARIABLE . "=delunit");
$tpl->assign('URL_DEL_BACK', NV_BASE_ADMINURL . "index.php?" . NV_LANG_VARIABLE . "=" . NV_LANG_DATA . "&" . NV_NAME_VARIABLE . "=" . $module_name . "&" . NV_OP_VARIABLE . "=" . $op);
$tpl->assign('CURRENT_URL', NV_BASE_ADMINURL . "index.php?" . NV_LANG_VARIABLE . "=" . NV_LANG_DATA . "&" . NV_NAME_VARIABLE . "=" . $module_name . "&" . NV_OP_VARIABLE . "=" . $op);

$contents = $tpl->fetch('prounit.tpl');

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
