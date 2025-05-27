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

$page_title = $nv_Lang->getModule('suppliers');
// Thay đổi trạng thái
if ($nv_Request->isset_request('change_status', 'post, get')) {
    $id = $nv_Request->get_int('id', 'post, get', 0);
    
    if (empty($id)) {
        nv_jsonOutput([
            'status' => 'ERROR',
            'mess' => $nv_Lang->getModule('supplier_error_not_found')
        ]);
    }
    
    $query = 'SELECT status FROM ' . $db_config['prefix'] . '_' . $module_data . '_suppliers WHERE id=' . $id;
    $result = $db->query($query);
    $numrows = $result->rowCount();
    
    if ($numrows != 1) {
        nv_jsonOutput([
            'status' => 'ERROR',
            'mess' => $nv_Lang->getModule('supplier_error_not_found')
        ]);
    }
    
    $new_status = $result->fetchColumn() ? 0 : 1;
    $query = 'UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_suppliers SET status=' . $new_status . ' WHERE id=' . $id;
    $db->query($query);
    
    $nv_Cache->delMod($module_name);
    
    nv_jsonOutput([
        'status' => 'OK',
        'mess' => $nv_Lang->getModule('supplier_success_status')
    ]);
}

// Xử lý Ajax cho modal
if ($nv_Request->isset_request('ajax', 'post,get')) {
    $action = $nv_Request->get_string('action', 'post,get', '');
    if ($action == 'get_supplier') {
        $id = $nv_Request->get_int('id', 'post,get', 0);
        if ($id > 0) {
            $supplier = $db->query('SELECT * FROM ' . $db_config['prefix'] . '_' . $module_data . '_suppliers WHERE id = ' . $id)->fetch();
            
            if (!empty($supplier)) {
                nv_jsonOutput([
                    'status' => 'OK',
                    'data' => $supplier,
                    'mess' => ''
                ]);
            }
        }
        
        nv_jsonOutput([
            'status' => 'ERROR',
            'mess' => $nv_Lang->getModule('supplier_error_not_found')
        ]);
    } elseif ($action == 'save_supplier') {
        $id = $nv_Request->get_int('id', 'post', 0);
        $title = $nv_Request->get_title('title', 'post', '');
        $alias = $nv_Request->get_title('alias', 'post', '');
        $description = $nv_Request->get_textarea('description', '', NV_ALLOWED_HTML_TAGS);
        $address = $nv_Request->get_title('address', 'post', '');
        $phone = $nv_Request->get_title('phone', 'post', '');
        $email = $nv_Request->get_title('email', 'post', '');
        $fax = $nv_Request->get_title('fax', 'post', '');
        $website = $nv_Request->get_title('website', 'post', '');
        $image = $nv_Request->get_title('image', 'post', '');
        $note = $nv_Request->get_textarea('note', '', NV_ALLOWED_HTML_TAGS);
        $status = $nv_Request->get_int('status', 'post', 0);
        
        // Validate input
        if (empty($title)) {
            nv_jsonOutput([
                'status' => 'ERROR',
                'mess' => $nv_Lang->getModule('supplier_error_title')
            ]);
        }
        
        // Generate alias if empty
        if (empty($alias)) {
            $alias = change_alias($title);
        }
        
        try {
            if ($id > 0) {
                // Update supplier
                $stmt = $db->prepare('UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_suppliers SET 
                    title = :title, 
                    alias = :alias, 
                    description = :description, 
                    address = :address, 
                    phone = :phone, 
                    email = :email, 
                    fax = :fax, 
                    website = :website, 
                    image = :image, 
                    note = :note, 
                    status = :status,
                    edit_time = :edit_time
                    WHERE id = ' . $id);
                
                $stmt->bindParam(':title', $title, PDO::PARAM_STR);
                $stmt->bindParam(':alias', $alias, PDO::PARAM_STR);
                $stmt->bindParam(':description', $description, PDO::PARAM_STR);
                $stmt->bindParam(':address', $address, PDO::PARAM_STR);
                $stmt->bindParam(':phone', $phone, PDO::PARAM_STR);
                $stmt->bindParam(':email', $email, PDO::PARAM_STR);
                $stmt->bindParam(':fax', $fax, PDO::PARAM_STR);
                $stmt->bindParam(':website', $website, PDO::PARAM_STR);
                $stmt->bindParam(':image', $image, PDO::PARAM_STR);
                $stmt->bindParam(':note', $note, PDO::PARAM_STR);
                $stmt->bindParam(':status', $status, PDO::PARAM_INT);
                $stmt->bindValue(':edit_time', NV_CURRENTTIME, PDO::PARAM_INT);
                
                $stmt->execute();
                
                nv_insert_logs(NV_LANG_DATA, $module_name, 'Edit Supplier', 'ID: ' . $id . ' - ' . $title, $admin_info['userid']);
                
                nv_jsonOutput([
                    'status' => 'OK',
                    'mess' => $nv_Lang->getModule('supplier_success_edit'),
                    'data' => [
                        'id' => $id,
                        'title' => $title,
                        'alias' => $alias,
                        'phone' => $phone,
                        'email' => $email,
                        'status' => $status
                    ]
                ]);
            } else {
                // Insert new supplier
                $weight = $db->query('SELECT max(weight) FROM ' . $db_config['prefix'] . '_' . $module_data . '_suppliers')->fetchColumn();
                $weight = intval($weight) + 1;
                
                $stmt = $db->prepare('INSERT INTO ' . $db_config['prefix'] . '_' . $module_data . '_suppliers 
                    (title, alias, description, address, phone, email, fax, website, image, note, weight, add_time, edit_time, status) 
                    VALUES 
                    (:title, :alias, :description, :address, :phone, :email, :fax, :website, :image, :note, :weight, :add_time, :edit_time, :status)');
                
                $stmt->bindParam(':title', $title, PDO::PARAM_STR);
                $stmt->bindParam(':alias', $alias, PDO::PARAM_STR);
                $stmt->bindParam(':description', $description, PDO::PARAM_STR);
                $stmt->bindParam(':address', $address, PDO::PARAM_STR);
                $stmt->bindParam(':phone', $phone, PDO::PARAM_STR);
                $stmt->bindParam(':email', $email, PDO::PARAM_STR);
                $stmt->bindParam(':fax', $fax, PDO::PARAM_STR);
                $stmt->bindParam(':website', $website, PDO::PARAM_STR);
                $stmt->bindParam(':image', $image, PDO::PARAM_STR);
                $stmt->bindParam(':note', $note, PDO::PARAM_STR);
                $stmt->bindParam(':weight', $weight, PDO::PARAM_INT);
                $stmt->bindValue(':add_time', NV_CURRENTTIME, PDO::PARAM_INT);
                $stmt->bindValue(':edit_time', 0, PDO::PARAM_INT);
                $stmt->bindParam(':status', $status, PDO::PARAM_INT);
                
                $stmt->execute();
                $id = $db->lastInsertId();
                
                nv_insert_logs(NV_LANG_DATA, $module_name, 'Add Supplier', $title, $admin_info['userid']);
                
                nv_jsonOutput([
                    'status' => 'OK',
                    'mess' => $nv_Lang->getModule('supplier_success_add'),
                    'data' => [
                        'id' => $id,
                        'title' => $title,
                        'alias' => $alias,
                        'phone' => $phone,
                        'email' => $email,
                        'status' => $status
                    ]
                ]);
            }
        } catch (PDOException $e) {
            nv_jsonOutput([
                'status' => 'ERROR',
                'mess' => $nv_Lang->getModule('supplier_error_save')
            ]);
        }
    }
}

if ($nv_Request->isset_request('get_alias', 'post,get')) {
    $title = $nv_Request->get_title('title', 'post,get', '');
    $alias = change_alias($title);
    
    nv_jsonOutput([
        'status' => 'OK',
        'alias' => $alias
    ]);
}

// Xóa nhà cung cấp
if ($nv_Request->isset_request('delete', 'post')) {
    $id = $nv_Request->get_int('id', 'post', 0);
    $checkss = $nv_Request->get_string('checkss', 'post', '');
    
    if (empty($id) || $checkss != md5($id . NV_CACHE_PREFIX . $client_info['session_id'])) {
        nv_jsonOutput([
            'status' => 'ERROR',
            'mess' => $nv_Lang->getModule('supplier_error_security')
        ]);
    }
    
    // Kiểm tra xem nhà cung cấp có đang được sử dụng không
    $count = $db->query('SELECT COUNT(*) FROM ' . $db_config['prefix'] . '_' . $module_data . '_warehouse_logs WHERE supplier_id=' . $id)->fetchColumn();
    
    if ($count > 0) {
        nv_jsonOutput([
            'status' => 'ERROR',
            'mess' => $nv_Lang->getModule('supplier_error_in_use')
        ]);
    }
    
    if ($db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_suppliers WHERE id=' . $id)) {
        nv_insert_logs(NV_LANG_DATA, $module_name, 'Delete Supplier', 'ID: ' . $id, $admin_info['userid']);
        $nv_Cache->delMod($module_name);
        
        nv_jsonOutput([
            'status' => 'OK',
            'mess' => $nv_Lang->getModule('supplier_success_delete')
        ]);
    }
    
    nv_jsonOutput([
        'status' => 'ERROR',
        'mess' => $nv_Lang->getModule('supplier_error_save')
    ]);
}

$row = array();
$error = array();

// Form xử lý
$row['id'] = $nv_Request->get_int('id', 'post,get', 0);

if ($nv_Request->isset_request('submit', 'post')) {
    $row['title'] = $nv_Request->get_title('title', 'post', '');
    $row['alias'] = $nv_Request->get_title('alias', 'post', '');
    $row['alias'] = ($row['alias'] == '') ? change_alias($row['title']) : change_alias($row['alias']);
    $row['description'] = $nv_Request->get_textarea('description', '', NV_ALLOWED_HTML_TAGS);
    $row['address'] = $nv_Request->get_title('address', 'post', '');
    $row['phone'] = $nv_Request->get_title('phone', 'post', '');
    $row['email'] = $nv_Request->get_title('email', 'post', '');
    $row['fax'] = $nv_Request->get_title('fax', 'post', '');
    $row['website'] = $nv_Request->get_title('website', 'post', '');
    $row['image'] = $nv_Request->get_title('image', 'post', '');
    $row['note'] = $nv_Request->get_textarea('note', '', NV_ALLOWED_HTML_TAGS);
    $row['status'] = $nv_Request->get_int('status', 'post', 0);
    
    if (empty($row['title'])) {
        $error[] = $nv_Lang->getModule('error_required_title');
    }
    
    if (empty($error)) {
        try {
            if (empty($row['id'])) {
                // Thêm mới
                $stmt = $db->prepare('INSERT INTO ' . $db_config['prefix'] . '_' . $module_data . '_suppliers 
                    (title, alias, description, address, phone, email, fax, website, image, note, weight, add_time, edit_time, status) 
                    VALUES (:title, :alias, :description, :address, :phone, :email, :fax, :website, :image, :note, :weight, :add_time, :edit_time, :status)');
                
                $weight = $db->query('SELECT max(weight) FROM ' . $db_config['prefix'] . '_' . $module_data . '_suppliers')->fetchColumn();
                $weight = intval($weight) + 1;
                
                $stmt->bindParam(':weight', $weight, PDO::PARAM_INT);
                $stmt->bindValue(':add_time', NV_CURRENTTIME, PDO::PARAM_INT);
                $stmt->bindValue(':edit_time', 0, PDO::PARAM_INT);
            } else {
                // Cập nhật
                $stmt = $db->prepare('UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_suppliers SET 
                    title = :title, alias = :alias, description = :description, address = :address, 
                    phone = :phone, email = :email, fax = :fax, website = :website, 
                    image = :image, note = :note, edit_time = :edit_time, status = :status 
                    WHERE id=' . $row['id']);
                
                $stmt->bindValue(':edit_time', NV_CURRENTTIME, PDO::PARAM_INT);
            }
            
            $stmt->bindParam(':title', $row['title'], PDO::PARAM_STR);
            $stmt->bindParam(':alias', $row['alias'], PDO::PARAM_STR);
            $stmt->bindParam(':description', $row['description'], PDO::PARAM_STR, strlen($row['description']));
            $stmt->bindParam(':address', $row['address'], PDO::PARAM_STR);
            $stmt->bindParam(':phone', $row['phone'], PDO::PARAM_STR);
            $stmt->bindParam(':email', $row['email'], PDO::PARAM_STR);
            $stmt->bindParam(':fax', $row['fax'], PDO::PARAM_STR);
            $stmt->bindParam(':website', $row['website'], PDO::PARAM_STR);
            $stmt->bindParam(':image', $row['image'], PDO::PARAM_STR);
            $stmt->bindParam(':note', $row['note'], PDO::PARAM_STR, strlen($row['note']));
            $stmt->bindParam(':status', $row['status'], PDO::PARAM_INT);
            
            $exc = $stmt->execute();
            
            if ($exc) {
                $nv_Cache->delMod($module_name);
                
                if (empty($row['id'])) {
                    nv_insert_logs(NV_LANG_DATA, $module_name, 'Add Supplier', $row['title'], $admin_info['userid']);
                } else {
                    nv_insert_logs(NV_LANG_DATA, $module_name, 'Edit Supplier', 'ID: ' . $row['id'] . ' - ' . $row['title'], $admin_info['userid']);
                }
                
                Header('Location: ' . NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op);
                die();
            }
        } catch (PDOException $e) {
            trigger_error($e->getMessage());
            die($e->getMessage()); // Thông báo lỗi
        }
    }
} elseif ($row['id'] > 0) {
    // Lấy dữ liệu từ CSDL nếu là sửa
    $row = $db->query('SELECT * FROM ' . $db_config['prefix'] . '_' . $module_data . '_suppliers WHERE id=' . $row['id'])->fetch();
    
    if (empty($row)) {
        Header('Location: ' . NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op);
        die();
    }
} else {
    // Giá trị mặc định khi thêm mới
    $row['id'] = 0;
    $row['title'] = '';
    $row['alias'] = '';
    $row['description'] = '';
    $row['address'] = '';
    $row['phone'] = '';
    $row['email'] = '';
    $row['fax'] = '';
    $row['website'] = '';
    $row['image'] = '';
    $row['note'] = '';
    $row['status'] = 1;
}

// Trạng thái
if ($row['status'] == 1) {
    $row['status_checked'] = 'checked="checked"';
} else {
    $row['status_checked'] = '';
}

$q = $nv_Request->get_title('q', 'post,get');

// Danh sách nhà cung cấp
$array_search = array();

$base_url = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op;

if (!empty($q)) {
    $array_search['keywords'] = $q;
    $base_url .= '&q=' . $q;
}

$db->sqlreset()
    ->select('COUNT(*)')
    ->from($db_config['prefix'] . '_' . $module_data . '_suppliers');

if (!empty($array_search['keywords'])) {
    $db->where('title LIKE :keywords OR phone LIKE :keywords OR email LIKE :keywords OR address LIKE :keywords');
}

$sth = $db->prepare($db->sql());

if (!empty($array_search['keywords'])) {
    $sth->bindValue(':keywords', '%' . $array_search['keywords'] . '%', PDO::PARAM_STR);
}

$sth->execute();
$num_items = $sth->fetchColumn();

$page = $nv_Request->get_int('page', 'post,get', 1);
$per_page = 20;

$db->select('*')
    ->order('weight ASC')
    ->limit($per_page)
    ->offset(($page - 1) * $per_page);

$sth = $db->prepare($db->sql());

if (!empty($array_search['keywords'])) {
    $sth->bindValue(':keywords', '%' . $array_search['keywords'] . '%', PDO::PARAM_STR);
}

$sth->execute();

// Lấy danh sách nhà cung cấp
$array_suppliers = array();
while ($view = $sth->fetch()) {
    $view['status_text'] = $view['status'] ? $nv_Lang->getModule('active') : $nv_Lang->getModule('inactive');
    $view['add_time'] = nv_date('d/m/Y', $view['add_time']);
    $view['edit_url'] = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op . '&amp;id=' . $view['id'];
    $view['status_url'] = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op . '&amp;change_status&amp;id=' . $view['id'];
    $view['checkss'] = md5($view['id'] . NV_CACHE_PREFIX . $client_info['session_id']);
    
    $array_suppliers[] = $view;
}

// Phân trang
$generate_page = nv_generate_page($base_url, $num_items, $per_page, $page);

// Thiết lập template
$template = get_tpl_dir([$global_config['module_theme'], $global_config['admin_theme']], 'admin_future');
$tpl = new \NukeViet\Template\NVSmarty();
$tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $template . '/modules/' . $module_file);

// Gán các biến cho template
$tpl->assign('LANG', $nv_Lang);
$tpl->assign('NV_LANG_VARIABLE', NV_LANG_VARIABLE);
$tpl->assign('NV_LANG_DATA', NV_LANG_DATA);
$tpl->assign('NV_BASE_ADMINURL', NV_BASE_ADMINURL);
$tpl->assign('NV_NAME_VARIABLE', NV_NAME_VARIABLE);
$tpl->assign('NV_OP_VARIABLE', NV_OP_VARIABLE);
$tpl->assign('MODULE_NAME', $module_name);
$tpl->assign('OP', $op);
$tpl->assign('ROW', $row);
$tpl->assign('SEARCH', $array_search);
$tpl->assign('UPLOAD_CURRENT', NV_UPLOADS_DIR . '/' . $module_upload);
$tpl->assign('SUPPLIERS', $array_suppliers);
$tpl->assign('GENERATE_PAGE', $generate_page);
$tpl->assign('Q', $q);

$contents = $tpl->fetch('suppliers.tpl');

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
