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

$page_title = $nv_Lang->getModule('guarantee_list');

// Lấy danh sách sản phẩm
$sql = 'SELECT id, ' . NV_LANG_DATA . '_title as title FROM ' . $db_config['prefix'] . '_' . $module_data . '_rows WHERE status=1 ORDER BY ' . NV_LANG_DATA . '_title ASC';
$result = $db->query($sql);
$array_products = array();
while ($row = $result->fetch()) {
    $array_products[$row['id']] = $row;
}

// Xử lý xóa qua ajax
if ($nv_Request->isset_request('delete', 'post')) {
    $id = $nv_Request->get_int('id', 'post', 0);
    
    try {
        $stmt = $db->prepare('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_guarantee WHERE id = :id');
        $stmt->bindParam(':id', $id, PDO::PARAM_INT);
        $stmt->execute();
        nv_insert_logs(NV_LANG_DATA, $module_name, 'Delete guarantee', 'ID: ' . $id, $admin_info['userid']);
        $nv_Cache->delMod($module_name);
        nv_jsonOutput([
            'status' => 'OK',
            'mess' => $nv_Lang->getModule('success_delete')
        ]);
    } catch (PDOException $e) {
        nv_jsonOutput([
            'status' => 'ERROR',
            'mess' => $nv_Lang->getModule('error_delete')
        ]);
    }
}

// Xử lý các action ajax khác
if ($nv_Request->isset_request('action', 'post')) {
    $action = $nv_Request->get_string('action', 'post', '');
    $id = $nv_Request->get_int('id', 'post', 0);

    // Lấy dữ liệu khi sửa
    if ($action == 1 && $id > 0) {        
        $sql = 'SELECT * FROM ' . $db_config['prefix'] . '_' . $module_data . '_guarantee WHERE id=' . $id;
        $row = $db->query($sql)->fetch();
        
        if ($row) {
            $row['warranty_start'] = !empty($row['warranty_start']) ? date('d/m/Y', $row['warranty_start']) : '';
            $row['warranty_end'] = !empty($row['warranty_end']) ? date('d/m/Y', $row['warranty_end']) : '';
            
            nv_jsonOutput([
                'status' => 'OK',
                'data' => $row
            ]);
        }
        
        nv_jsonOutput([
            'status' => 'ERROR',
            'mess' => $nv_Lang->getModule('error_not_found')
        ]);
    }
    
    if ($action) {
        $id = $nv_Request->get_int('id', 'post', 0);
        
        $data = array(
            'product_id' => $nv_Request->get_int('product_id', 'post', 0),
            'warranty_code' => $nv_Request->get_string('warranty_code', 'post', ''),
            'serial_number' => $nv_Request->get_string('serial_number', 'post', ''),
            'customer_name' => $nv_Request->get_string('customer_name', 'post', ''),
            'customer_phone' => $nv_Request->get_string('customer_phone', 'post', ''),
            'customer_address' => $nv_Request->get_string('customer_address', 'post', ''),
            'warranty_start' => $nv_Request->get_string('warranty_start', 'post', ''),
            'warranty_end' => $nv_Request->get_string('warranty_end', 'post', ''),
            'warranty_status' => $nv_Request->get_int('warranty_status', 'post', 0),
            'note' => $nv_Request->get_string('note', 'post', '')
        );

        // Validate data
        if (empty($data['product_id'])) {
            nv_jsonOutput([
                'status' => 'error',
                'message' => $nv_Lang->getModule('error_required_product')
            ]);
        }
        if (empty($data['warranty_code'])) {
            nv_jsonOutput([
                'status' => 'error',
                'message' => $nv_Lang->getModule('error_required_warranty_code')
            ]);
        }
        if (empty($data['serial_number'])) {
            nv_jsonOutput([
                'status' => 'error',
                'message' => $nv_Lang->getModule('error_required_serial_number')
            ]);
        }
        if (empty($data['customer_name'])) {
            nv_jsonOutput([
                'status' => 'error',
                'message' => $nv_Lang->getModule('error_required_customer_name')
            ]);
        }
        if (empty($data['customer_phone'])) {
            nv_jsonOutput([
                'status' => 'error',
                'message' => $nv_Lang->getModule('error_required_customer_phone')
            ]);
        }

        // Convert dates
        if (!empty($data['warranty_start'])) {
            preg_match('/^([0-9]{1,2})\/([0-9]{1,2})\/([0-9]{4})$/', $data['warranty_start'], $m);
            $data['warranty_start'] = mktime(0, 0, 0, $m[2], $m[1], $m[3]);
        }
        if (!empty($data['warranty_end'])) {
            preg_match('/^([0-9]{1,2})\/([0-9]{1,2})\/([0-9]{4})$/', $data['warranty_end'], $m);
            $data['warranty_end'] = mktime(0, 0, 0, $m[2], $m[1], $m[3]);
        }
        try {
            if ($id) { // Sửa
                $stmt = $db->prepare('UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_guarantee SET 
                    product_id = :product_id,
                    warranty_code = :warranty_code,
                    serial_number = :serial_number,
                    customer_name = :customer_name,
                    customer_phone = :customer_phone,
                    customer_address = :customer_address,
                    warranty_start = :warranty_start,
                    warranty_end = :warranty_end,
                    warranty_status = :warranty_status,
                    note = :note
                    WHERE id = ' . $id);
            } else { // Thêm mới
                $stmt = $db->prepare('INSERT INTO ' . $db_config['prefix'] . '_' . $module_data . '_guarantee 
                    (product_id, warranty_code, serial_number, customer_name, customer_phone, customer_address, 
                    warranty_start, warranty_end, warranty_status, note, admin_id, add_time) 
                    VALUES 
                    (:product_id, :warranty_code, :serial_number, :customer_name, :customer_phone, :customer_address,
                    :warranty_start, :warranty_end, :warranty_status, :note, :admin_id, :add_time)');
                
                $data['admin_id'] = $admin_info['userid'];
                $data['add_time'] = NV_CURRENTTIME;
                $stmt->bindParam(':admin_id', $data['admin_id'], PDO::PARAM_INT);
                $stmt->bindParam(':add_time', $data['add_time'], PDO::PARAM_INT);
            }

            // Bind các tham số chung
            $stmt->bindParam(':product_id', $data['product_id'], PDO::PARAM_INT);
            $stmt->bindParam(':warranty_code', $data['warranty_code'], PDO::PARAM_STR);
            $stmt->bindParam(':serial_number', $data['serial_number'], PDO::PARAM_STR);
            $stmt->bindParam(':customer_name', $data['customer_name'], PDO::PARAM_STR);
            $stmt->bindParam(':customer_phone', $data['customer_phone'], PDO::PARAM_STR);
            $stmt->bindParam(':customer_address', $data['customer_address'], PDO::PARAM_STR);
            $stmt->bindParam(':warranty_start', $data['warranty_start'], PDO::PARAM_INT);
            $stmt->bindParam(':warranty_end', $data['warranty_end'], PDO::PARAM_INT);
            $stmt->bindParam(':warranty_status', $data['warranty_status'], PDO::PARAM_INT);
            $stmt->bindParam(':note', $data['note'], PDO::PARAM_STR);

            if ($stmt->execute()) {
                nv_insert_logs(NV_LANG_DATA, $module_name, ($id ? 'Edit' : 'Add') . ' guarantee', 'Code: ' . $data['warranty_code'], $admin_info['userid']);
                $nv_Cache->delMod($module_name);
                
                nv_jsonOutput([
                    'status' => 'OK',
                    'mess' => $nv_Lang->getModule($id ? 'success_edit' : 'success_add')
                ]);
            }
        } catch (PDOException $e) {
            nv_jsonOutput([
                'status' => 'error',
                'message' => $nv_Lang->getModule('error_save')
            ]);
        }
    }
}

// Khởi tạo các biến tìm kiếm
$search = array(
    'keyword' => $nv_Request->get_string('keyword', 'get', ''),
    'date_from' => $nv_Request->get_string('date_from', 'get', ''),
    'date_to' => $nv_Request->get_string('date_to', 'get', ''),
    'status' => $nv_Request->get_int('status', 'get', -1),
    'product_id' => $nv_Request->get_int('product_id', 'get', 0)
);

$page = $nv_Request->get_int('page', 'get', 1);
$perpage = 20;

$db->sqlreset()->select('COUNT(*)')->from($db_config['prefix'] . "_" . $module_data . "_guarantee");

// Điều kiện tìm kiếm
$where = array();
if (!empty($search['keyword'])) {
    $where[] = "(customer_name LIKE '%" . $search['keyword'] . "%' OR 
                 customer_phone LIKE '%" . $search['keyword'] . "%' OR
                 warranty_code LIKE '%" . $search['keyword'] . "%' OR
                 serial_number LIKE '%" . $search['keyword'] . "%')";
}
if (!empty($search['date_from'])) {
    preg_match('/^([0-9]{1,2})\/([0-9]{1,2})\/([0-9]{4})$/', $search['date_from'], $m);
    $from_time = mktime(0, 0, 0, $m[2], $m[1], $m[3]);
    $where[] = "warranty_start >= " . $from_time;
}
if (!empty($search['date_to'])) {
    preg_match('/^([0-9]{1,2})\/([0-9]{1,2})\/([0-9]{4})$/', $search['date_to'], $m);
    $to_time = mktime(23, 59, 59, $m[2], $m[1], $m[3]);
    $where[] = "warranty_end <= " . $to_time;
}
if ($search['status'] >= 0) {
    $where[] = "warranty_status = " . $search['status'];
}
if ($search['product_id'] > 0) {
    $where[] = "product_id = " . $search['product_id'];
}

if (!empty($where)) {
    $db->where(implode(' AND ', $where));
}

$total = $db->query($db->sql())->fetchColumn();

$db->select('w.*, p.' . NV_LANG_DATA . '_title as product_name, u.username')
    ->from($db_config['prefix'] . "_" . $module_data . "_guarantee w, " . 
          $db_config['prefix'] . "_" . $module_data . "_rows p, " . 
          NV_USERS_GLOBALTABLE . " u")
    ->where('w.product_id=p.id AND w.admin_id=u.userid')
    ->order('w.id DESC')
    ->limit($perpage)
    ->offset(($page - 1) * $perpage);

if (!empty($where)) {
    $db->where(implode(' AND ', $where));
}

$result = $db->query($db->sql());

$array_status = array(
    0 => $nv_Lang->getModule('warranty_status_0'),
    1 => $nv_Lang->getModule('warranty_status_1'),
    2 => $nv_Lang->getModule('warranty_status_2')
);

// Xây dựng URL cơ sở cho phân trang
$base_url = NV_BASE_ADMINURL . "index.php?" . NV_LANG_VARIABLE . "=" . NV_LANG_DATA . "&" . NV_NAME_VARIABLE . "=" . $module_name . "&" . NV_OP_VARIABLE . "=guarantee";
if (!empty($search['keyword'])) {
    $base_url .= "&keyword=" . urlencode($search['keyword']);
}
if (!empty($search['date_from'])) {
    $base_url .= "&date_from=" . urlencode($search['date_from']);
}
if (!empty($search['date_to'])) {
    $base_url .= "&date_to=" . urlencode($search['date_to']);
}
if ($search['status'] >= 0) {
    $base_url .= "&status=" . $search['status'];
}
if ($search['product_id'] > 0) {
    $base_url .= "&product_id=" . $search['product_id'];
}

$array_data = array();

while ($row = $result->fetch()) {
    $row['warranty_start'] = date('d/m/Y', $row['warranty_start']);
    $row['warranty_end'] = date('d/m/Y', $row['warranty_end']);
    $row['add_time'] = date('d/m/Y H:i', $row['add_time']);
    $row['status_text'] = $array_status[$row['warranty_status']];
    $array_data[] = $row;
}

$template = get_tpl_dir([$global_config['module_theme'], $global_config['admin_theme']], 'admin_future', '/modules/' . $module_file . '/guarantee.tpl');
$tpl = new \NukeViet\Template\NVSmarty();
$tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $template . '/modules/' . $module_file);
$tpl->assign('SEARCH', $search);
$tpl->assign('DATA', $array_data); 
$tpl->assign('ARRAY_STATUS', $array_status);
$tpl->assign('PRODUCTS', $array_products);
$tpl->assign('LANG', $nv_Lang);
$tpl->assign('MODULE_NAME', $module_name);
$generate_page = nv_generate_page($base_url, $total, $perpage, $page);
if ($generate_page) {
    $tpl->assign('PAGES', $generate_page);
}

$contents = $tpl->fetch('guarantee.tpl');

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
