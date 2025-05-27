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

if (!$pro_config['active_warehouse']) {
    nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=items');
}

// Lấy danh sách nhóm thuộc tính
$global_array_group = array();
$sql = 'SELECT groupid, parentid, ' . NV_LANG_DATA . '_title AS title FROM ' . $db_config['prefix'] . '_' . $module_data . '_group ORDER BY weight ASC';
$result = $db->query($sql);
while ($row = $result->fetch()) {
    $global_array_group[$row['groupid']] = $row;
}

$wid = $nv_Request->get_int('wid', 'get', 0);
$array_search = array();
$array_warehouse = array();
$base_url = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op;
if ($wid > 0) {
    // Lấy thông tin phiếu nhập kho
    $result = $db->query('SELECT t1.*, t2.first_name, t2.last_name, t2.username FROM ' . $db_config['prefix'] . '_' . $module_data . '_warehouse t1 INNER JOIN ' . NV_USERS_GLOBALTABLE . ' t2 ON t1.user_id=t2.userid WHERE t1.wid=' . $wid);
    if ($result->rowCount() == 0) {
        nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=warehouse');
    }
    
    $array_warehouse = $result->fetch();
    $page_title = $array_warehouse['title'];
    
    // Format thông tin cơ bản
    $array_warehouse['addtime'] = nv_date('H:i d/m/Y', $array_warehouse['addtime']);
    $array_warehouse['full_name'] = !empty($array_warehouse['last_name']) ? $array_warehouse['first_name'] . ' ' . $array_warehouse['last_name'] : $array_warehouse['username'];
    
    if (!empty($array_warehouse['supplier_id'])) {
        $supplier = $db->query('SELECT title FROM ' . $db_config['prefix'] . '_' . $module_data . '_suppliers WHERE id = ' . intval($array_warehouse['supplier_id']))->fetch();
        if ($supplier) {
            $array_warehouse['supplier_name'] = $supplier['title'];
        }
    }

    // Lấy chi tiết sản phẩm
    $array_warehouse['logs'] = array();
    $result = $db->query('SELECT t1.*, t2.' . NV_LANG_DATA . '_title title, t2.' . NV_LANG_DATA . '_alias alias, t2.listcatid, t2.product_number, t2.product_unit FROM ' . $db_config['prefix'] . '_' . $module_data . '_warehouse_logs t1 INNER JOIN ' . $db_config['prefix'] . '_' . $module_data . '_rows t2 ON t1.pro_id=t2.id WHERE t1.wid=' . $array_warehouse['wid'] . ' ORDER BY t1.pro_id ASC, t1.logid ASC');
    
    $grouped_logs = array();
    
    while ($row = $result->fetch()) {
        $pro_id = $row['pro_id'];
        
        // Khởi tạo mảng cho sản phẩm nếu chưa tồn tại
        if (!isset($grouped_logs[$pro_id])) {
            $grouped_logs[$pro_id] = array(
                'pro_id' => $pro_id,
                'title' => $row['title'],
                'alias' => $row['alias'],
                'total_quantity' => 0,
                'money_unit' => $row['money_unit'],
                'supplier_id' => $row['supplier_id'],
                'supplier_name' => '',
                'price' => $row['price'],
                'sale_price' => $row['sale_price'],
                'group_info' => array(),
                'logs' => array()
            );
            
            // Lấy thông tin nhà cung cấp
            if (!empty($row['supplier_id'])) {
                $supplier = $db->query('SELECT title FROM ' . $db_config['prefix'] . '_' . $module_data . '_suppliers WHERE id = ' . intval($row['supplier_id']))->fetch();
                if ($supplier) {
                    $grouped_logs[$pro_id]['supplier_name'] = $supplier['title'];
                }
            }
            
            // Tạo link chi tiết sản phẩm
            $grouped_logs[$pro_id]['link'] = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=detail/' . $row['alias'];
        }
        
        // Cộng dồn số lượng
        $grouped_logs[$pro_id]['total_quantity'] += $row['quantity'];
        
        // Format giá
        $row['price_format'] = !empty($row['price']) ? number_format($row['price']) : 0;
        $row['sale_price_format'] = !empty($row['sale_price']) ? number_format($row['sale_price']) : 0;
        
        // Lấy thông tin nhóm thuộc tính
        $result_group = $db->query('SELECT * FROM ' . $db_config['prefix'] . '_' . $module_data . '_warehouse_logs_group WHERE logid=' . $row['logid']);
        
        $group_info = array(
            'groups' => array(),
            'quantity' => $row['quantity'],
            'price' => $row['price'],
            'price_format' => $row['price_format'],
            'sale_price' => $row['sale_price'],
            'sale_price_format' => $row['sale_price_format'],
            'supplier_id' => $row['supplier_id'],
            'supplier_name' => $grouped_logs[$pro_id]['supplier_name']
        );
        
        while ($group = $result_group->fetch()) {
            if (!empty($group['listgroup'])) {
                $group_ids = explode(',', $group['listgroup']);
                
                foreach ($group_ids as $group_id) {
                    // Lấy thông tin nhóm
                    $group_item = array();
                    
                    // Lấy thông tin nhóm thuộc tính từ global_array_group
                    if (isset($global_array_group[$group_id])) {
                        $group_item['title'] = $global_array_group[$group_id]['title'];
                        $parent_id = $global_array_group[$group_id]['parentid'];
                        $group_item['parent_title'] = isset($global_array_group[$parent_id]) ? $global_array_group[$parent_id]['title'] : '';
                        $group_info['groups'][] = $group_item;
                    }
                }
            }
            
            // Lấy thông tin giá từ bảng products_price
            $price_info = $db->query('SELECT price, money_unit, update_time 
                FROM ' . $db_config['prefix'] . '_' . $module_data . '_products_price 
                WHERE product_id = ' . $pro_id . ' 
                AND warehouse_id = ' . $array_warehouse['wid'] . '
                AND warehouse_logs_id = ' . $row['logid'] . ' 
                AND warehouse_logs_group_id = ' . $group['id'] . '
                ORDER BY update_time DESC 
                LIMIT 1')->fetch();
            
            if ($price_info) {
                $group_info['current_price'] = $price_info['price'];
                $group_info['current_price_format'] = number_format($price_info['price']);
                $group_info['current_money_unit'] = $price_info['money_unit'];
                $group_info['price_update_time'] = nv_date('H:i d/m/Y', $price_info['update_time']);
            }
        }
        
        if (!empty($group_info['groups'])) {
            $grouped_logs[$pro_id]['group_info'][] = $group_info;
        }
        
        // Thêm log vào mảng logs của sản phẩm
        $grouped_logs[$pro_id]['logs'][] = $row;
        
        // Lấy giá hiện tại của sản phẩm gốc
        if (!isset($grouped_logs[$pro_id]['current_price'])) {
            $price_info = $db->query('SELECT price, money_unit, update_time 
                FROM ' . $db_config['prefix'] . '_' . $module_data . '_products_price 
                WHERE product_id = ' . $pro_id . ' 
                AND warehouse_id = ' . $array_warehouse['wid'] . '
                AND warehouse_logs_id = ' . $row['logid'] . ' 
                AND warehouse_logs_group_id = 0
                ORDER BY update_time DESC 
                LIMIT 1')->fetch();
            
            if ($price_info) {
                $grouped_logs[$pro_id]['current_price'] = $price_info['price'];
                $grouped_logs[$pro_id]['current_price_format'] = number_format($price_info['price']);
                $grouped_logs[$pro_id]['current_money_unit'] = $price_info['money_unit'];
                $grouped_logs[$pro_id]['price_update_time'] = nv_date('H:i d/m/Y', $price_info['update_time']);
            }
        }
    }
    
    // Chuyển mảng kết quả đã gom nhóm vào array_warehouse
    $array_warehouse['logs'] = array_values($grouped_logs);
} else {
    $page_title = $nv_Lang->getModule('warehouse_logs');

    // Xử lý xóa
    if ($nv_Request->isset_request('delete', 'post')) {
        $wid = $nv_Request->get_int('wid', 'post', 0);
        $checkss = $nv_Request->get_string('checkss', 'post', '');
        
        if ($wid > 0 && $checkss == md5($global_config['sitekey'] . session_id())) {
            // Xóa logs_group
            $result = $db->query('SELECT logid FROM ' . $db_config['prefix'] . '_' . $module_data . '_warehouse_logs WHERE wid=' . $wid);
            while (list($logid) = $result->fetch(3)) {
                $db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_warehouse_logs_group WHERE logid = ' . $logid);
            }
            
            // Xóa logs
            $db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_warehouse_logs WHERE wid = ' . $wid);
            
            // Xóa warehouse
            $db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_warehouse WHERE wid = ' . $wid);
            
            $nv_Cache->delMod($module_name);
            nv_jsonOutput('OK');
        }
        nv_jsonOutput('ERROR');
    }

    $base_url = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op;

    $per_page = 20;
    $page = $nv_Request->get_int('page', 'get', 1);

    $array_search = array();
    $array_search['keywords'] = $nv_Request->get_title('keywords', 'get', '');
    $array_search['from'] = $nv_Request->get_string('from', 'get', '');
    $array_search['to'] = $nv_Request->get_string('to', 'get', '');

    $db->sqlreset()
        ->select('COUNT(*)')
        ->from($db_config['prefix'] . '_' . $module_data . '_warehouse t1')
        ->join('INNER JOIN ' . NV_USERS_GLOBALTABLE . ' t2 ON t1.user_id=t2.userid');

    $where = '';
    if (!empty($array_search['keywords'])) {
        $where .= ' AND (title LIKE :q_title OR note LIKE :q_note OR username LIKE :q_username)';
    }

    if (!empty($array_search['from']) and preg_match('/^([0-9]{1,2})\/([0-9]{1,2})\/([0-9]{4})$/', $array_search['from'], $m)) {
        $array_search['from'] = mktime(0, 0, 0, $m[2], $m[1], $m[3]);
        $where .= ' AND addtime >= ' . $array_search['from'];
    } else {
        $array_search['from'] = '';
    }

    if (!empty($array_search['to']) and preg_match('/^([0-9]{1,2})\/([0-9]{1,2})\/([0-9]{4})$/', $array_search['to'], $m)) {
        $array_search['to'] = mktime(23, 59, 59, $m[2], $m[1], $m[3]);
        $where .= ' AND addtime <= ' . $array_search['to'];
    } else {
        $array_search['to'] = '';
    }

    if (!empty($where)) {
        $db->where('1=1' . $where);
    }

    $sth = $db->prepare($db->sql());

    if (!empty($array_search['keywords'])) {
        $sth->bindValue(':q_title', '%' . $array_search['keywords'] . '%');
        $sth->bindValue(':q_note', '%' . $array_search['keywords'] . '%');
        $sth->bindValue(':q_username', '%' . $array_search['keywords'] . '%');
    }
    $sth->execute();
    $num_items = $sth->fetchColumn();

    $db->select('t1.*, t2.first_name, t2.last_name, t2.username')
        ->order('t1.addtime DESC')
        ->limit($per_page)
        ->offset(($page - 1) * $per_page);

    $sth = $db->prepare($db->sql());

    if (!empty($array_search['keywords'])) {
        $sth->bindValue(':q_title', '%' . $array_search['keywords'] . '%');
        $sth->bindValue(':q_note', '%' . $array_search['keywords'] . '%');
        $sth->bindValue(':q_username', '%' . $array_search['keywords'] . '%');
    }
    $sth->execute();

    $array_search['from'] = !empty($array_search['from']) ? nv_date('d/m/Y', $array_search['from']) : '';
    $array_search['to'] = !empty($array_search['to']) ? nv_date('d/m/Y', $array_search['to']) : '';
}

if ($nv_Request->isset_request('action', 'post,get')) {
    $action = $nv_Request->get_string('action', 'post,get', '');
    
    if ($action == 'data') {
        $draw = $nv_Request->get_int('draw', 'post', 0);
        $start = $nv_Request->get_int('start', 'post', 0);
        $length = $nv_Request->get_int('length', 'post', 50);
        $search = $nv_Request->get_string('search', 'post', '');
        $order = $nv_Request->get_array('order', 'post', array());
        $columns = $nv_Request->get_array('columns', 'post', array());
        
        // Lấy điều kiện tìm kiếm từ form
        $from = $nv_Request->get_string('from', 'post', '');
        $to = $nv_Request->get_string('to', 'post', '');
        
        $where = '1=1';
        
        // Xử lý tìm kiếm
        if (!empty($search['value'])) {
            $where .= ' AND (title LIKE :q_title OR note LIKE :q_note OR username LIKE :q_username)';
        }
        
        // Xử lý ngày tháng
        if (!empty($from) and preg_match('/^([0-9]{1,2})\/([0-9]{1,2})\/([0-9]{4})$/', $from, $m)) {
            $from = mktime(0, 0, 0, $m[2], $m[1], $m[3]);
            $where .= ' AND addtime >= ' . $from;
        }
        
        if (!empty($to) and preg_match('/^([0-9]{1,2})\/([0-9]{1,2})\/([0-9]{4})$/', $to, $m)) {
            $to = mktime(23, 59, 59, $m[2], $m[1], $m[3]);
            $where .= ' AND addtime <= ' . $to;
        }
        
        // Đếm tổng số bản ghi
        $db->sqlreset()
            ->select('COUNT(*)')
            ->from($db_config['prefix'] . '_' . $module_data . '_warehouse t1')
            ->join('INNER JOIN ' . NV_USERS_GLOBALTABLE . ' t2 ON t1.user_id=t2.userid')
            ->where($where);
            
        $sth = $db->prepare($db->sql());
        
        if (!empty($search['value'])) {
            $sth->bindValue(':q_title', '%' . $search['value'] . '%');
            $sth->bindValue(':q_note', '%' . $search['value'] . '%');
            $sth->bindValue(':q_username', '%' . $search['value'] . '%');
        }
        
        $sth->execute();
        $total_records = $sth->fetchColumn();
        
        // Lấy dữ liệu
        $db->select('t1.*, t2.first_name, t2.last_name, t2.username')
            ->order('t1.addtime DESC')
            ->limit($length)
            ->offset($start);
            
        $sth = $db->prepare($db->sql());
        
        if (!empty($search['value'])) {
            $sth->bindValue(':q_title', '%' . $search['value'] . '%');
            $sth->bindValue(':q_note', '%' . $search['value'] . '%');
            $sth->bindValue(':q_username', '%' . $search['value'] . '%');
        }
        
        $sth->execute();
        
        $data = array();
        $i = $start;
        
        while ($view = $sth->fetch()) {
            $i++;
            $row = array();
            $row['no'] = $i;
            $row['wid'] = $view['wid'];
            $row['title'] = $view['title'];
            $row['full_name'] = !empty($view['last_name']) ? $view['first_name'] . ' ' . $view['last_name'] : $view['username'];
            $row['addtime'] = nv_date('H:i d/m/Y', $view['addtime']);
            
            // Lấy thông tin nhà cung cấp
            $row['supplier_name'] = '--';
            if (!empty($view['wid'])) {
                // Lấy supplier_id từ warehouse_logs_group
                $supplier_id = $db->query('SELECT DISTINCT t2.supplier_id 
                    FROM ' . $db_config['prefix'] . '_' . $module_data . '_warehouse_logs t1 
                    INNER JOIN ' . $db_config['prefix'] . '_' . $module_data . '_warehouse_logs_group t2 
                    ON t1.logid=t2.logid 
                    WHERE t1.wid=' . $view['wid'] . ' AND t2.supplier_id > 0 
                    LIMIT 1')->fetchColumn();
                
                if ($supplier_id > 0) {
                    $supplier = $db->query('SELECT title 
                        FROM ' . $db_config['prefix'] . '_' . $module_data . '_suppliers 
                        WHERE id = ' . intval($supplier_id))->fetch();
                    if ($supplier) {
                        $row['supplier_name'] = $supplier['title'];
                    }
                }
            }
            
            $row['link'] = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op . '&amp;wid=' . $view['wid'];
            $row['link_edit'] = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=warehouse&amp;wid=' . $view['wid'];
            
            $data[] = $row;
        }
        
        $json = array(
            'draw' => $draw,
            'recordsTotal' => $total_records,
            'recordsFiltered' => $total_records,
            'data' => $data
        );
        
        nv_jsonOutput($json);
    }
    
    // Thêm xử lý AJAX lấy chi tiết nhập kho
    if ($action == 'get_detail') {
        $wid = $nv_Request->get_int('wid', 'post', 0);
        $checkss = $nv_Request->get_string('checkss', 'post', '');
        
        if (empty($wid) || $checkss != md5($global_config['sitekey'] . session_id())) {
            nv_jsonOutput(array(
                'status' => 'ERROR',
                'message' => 'Dữ liệu không hợp lệ'
            ));
        }
        
        // Lấy thông tin phiếu nhập kho
        $result = $db->query('SELECT t1.*, t2.first_name, t2.last_name, t2.username FROM ' . $db_config['prefix'] . '_' . $module_data . '_warehouse t1 INNER JOIN ' . NV_USERS_GLOBALTABLE . ' t2 ON t1.user_id=t2.userid WHERE t1.wid=' . $wid);
        if ($result->rowCount() == 0) {
            nv_jsonOutput(array(
                'status' => 'ERROR',
                'message' => 'Không tìm thấy dữ liệu nhập kho'
            ));
        }
        
        $array_warehouse = $result->fetch();
        
        // Format thông tin cơ bản
        $array_warehouse['addtime'] = nv_date('H:i d/m/Y', $array_warehouse['addtime']);
        $array_warehouse['full_name'] = !empty($array_warehouse['last_name']) ? $array_warehouse['first_name'] . ' ' . $array_warehouse['last_name'] : $array_warehouse['username'];
        
        if (!empty($array_warehouse['supplier_id'])) {
            $supplier = $db->query('SELECT title FROM ' . $db_config['prefix'] . '_' . $module_data . '_suppliers WHERE id = ' . intval($array_warehouse['supplier_id']))->fetch();
            if ($supplier) {
                $array_warehouse['supplier_name'] = $supplier['title'];
            }
        }

        // Lấy chi tiết sản phẩm
        $array_warehouse['logs'] = array();
        $result = $db->query('SELECT t1.*, t2.' . NV_LANG_DATA . '_title title, t2.' . NV_LANG_DATA . '_alias alias, t2.listcatid, t2.product_number, t2.product_unit FROM ' . $db_config['prefix'] . '_' . $module_data . '_warehouse_logs t1 INNER JOIN ' . $db_config['prefix'] . '_' . $module_data . '_rows t2 ON t1.pro_id=t2.id WHERE t1.wid=' . $array_warehouse['wid'] . ' ORDER BY t1.pro_id ASC, t1.logid ASC');
        
        $grouped_logs = array();
        
        while ($row = $result->fetch()) {
            $pro_id = $row['pro_id'];
            
            // Khởi tạo mảng cho sản phẩm nếu chưa tồn tại
            if (!isset($grouped_logs[$pro_id])) {
                $grouped_logs[$pro_id] = array(
                    'pro_id' => $pro_id,
                    'title' => $row['title'],
                    'alias' => $row['alias'],
                    'total_quantity' => 0,
                    'money_unit' => $row['money_unit'],
                    'supplier_id' => $row['supplier_id'],
                    'supplier_name' => '',
                    'price' => $row['price'],
                    'sale_price' => $row['sale_price'],
                    'group_info' => array(),
                    'logs' => array()
                );
                
                // Lấy thông tin nhà cung cấp
                if (!empty($row['supplier_id'])) {
                    $supplier = $db->query('SELECT title FROM ' . $db_config['prefix'] . '_' . $module_data . '_suppliers WHERE id = ' . intval($row['supplier_id']))->fetch();
                    if ($supplier) {
                        $grouped_logs[$pro_id]['supplier_name'] = $supplier['title'];
                    }
                }
                
                // Tạo link chi tiết sản phẩm
                $grouped_logs[$pro_id]['link'] = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=detail/' . $row['alias'];
            }
            
            // Cộng dồn số lượng
            $grouped_logs[$pro_id]['total_quantity'] += $row['quantity'];
            
            // Format giá
            $row['price_format'] = !empty($row['price']) ? number_format($row['price']) : 0;
            $row['sale_price_format'] = !empty($row['sale_price']) ? number_format($row['sale_price']) : 0;
            
            // Lấy thông tin nhóm thuộc tính
            $result_group = $db->query('SELECT * FROM ' . $db_config['prefix'] . '_' . $module_data . '_warehouse_logs_group WHERE logid=' . $row['logid']);
            
            $group_info = array(
                'groups' => array(),
                'quantity' => $row['quantity'],
                'price' => $row['price'],
                'price_format' => $row['price_format'],
                'sale_price' => $row['sale_price'],
                'sale_price_format' => $row['sale_price_format'],
                'supplier_id' => $row['supplier_id'],
                'supplier_name' => $grouped_logs[$pro_id]['supplier_name']
            );
            
            while ($group = $result_group->fetch()) {
                if (!empty($group['listgroup'])) {
                    $group_ids = explode(',', $group['listgroup']);
                    
                    foreach ($group_ids as $group_id) {
                        // Lấy thông tin nhóm
                        $group_item = array();
                        
                        // Lấy thông tin nhóm thuộc tính từ global_array_group
                        if (isset($global_array_group[$group_id])) {
                            $group_item['title'] = $global_array_group[$group_id]['title'];
                            $parent_id = $global_array_group[$group_id]['parentid'];
                            $group_item['parent_title'] = isset($global_array_group[$parent_id]) ? $global_array_group[$parent_id]['title'] : '';
                            $group_info['groups'][] = $group_item;
                        }
                    }
                }
                
                // Lấy thông tin giá từ bảng products_price
                $price_info = $db->query('SELECT price, money_unit, update_time 
                    FROM ' . $db_config['prefix'] . '_' . $module_data . '_products_price 
                    WHERE product_id = ' . $pro_id . ' 
                    AND warehouse_id = ' . $array_warehouse['wid'] . '
                    AND warehouse_logs_id = ' . $row['logid'] . ' 
                    AND warehouse_logs_group_id = ' . $group['id'] . '
                    ORDER BY update_time DESC 
                    LIMIT 1')->fetch();
                
                if ($price_info) {
                    $group_info['current_price'] = $price_info['price'];
                    $group_info['current_price_format'] = number_format($price_info['price']);
                    $group_info['current_money_unit'] = $price_info['money_unit'];
                    $group_info['price_update_time'] = nv_date('H:i d/m/Y', $price_info['update_time']);
                }
            }
            
            if (!empty($group_info['groups'])) {
                $grouped_logs[$pro_id]['group_info'][] = $group_info;
            }
            
            // Thêm log vào mảng logs của sản phẩm
            $grouped_logs[$pro_id]['logs'][] = $row;
            
            // Lấy giá hiện tại của sản phẩm gốc
            if (!isset($grouped_logs[$pro_id]['current_price'])) {
                $price_info = $db->query('SELECT price, money_unit, update_time 
                    FROM ' . $db_config['prefix'] . '_' . $module_data . '_products_price 
                    WHERE product_id = ' . $pro_id . ' 
                    AND warehouse_id = ' . $array_warehouse['wid'] . '
                    AND warehouse_logs_id = ' . $row['logid'] . ' 
                    AND warehouse_logs_group_id = 0
                    ORDER BY update_time DESC 
                    LIMIT 1')->fetch();
                
                if ($price_info) {
                    $grouped_logs[$pro_id]['current_price'] = $price_info['price'];
                    $grouped_logs[$pro_id]['current_price_format'] = number_format($price_info['price']);
                    $grouped_logs[$pro_id]['current_money_unit'] = $price_info['money_unit'];
                    $grouped_logs[$pro_id]['price_update_time'] = nv_date('H:i d/m/Y', $price_info['update_time']);
                }
            }
        }
        
        // Chuyển mảng kết quả đã gom nhóm vào array_warehouse
        $array_warehouse['logs'] = array_values($grouped_logs);
        
        // Trả về dữ liệu JSON
        $json_response = array(
            'status' => 'OK',
            'data' => $array_warehouse,
            'lang' => array(
                'user_payment' => $nv_Lang->getModule('user_payment'),
                'warehouse_time' => $nv_Lang->getModule('warehouse_time'),
                'content_note' => $nv_Lang->getModule('content_note'),
                'supplier' => $nv_Lang->getModule('supplier'),
                'warehouse_detail_info' => $nv_Lang->getModule('warehouse_detail_info'),
                'setting_stt' => $nv_Lang->getModule('setting_stt'),
                'name' => $nv_Lang->getModule('name'),
                'warehouse_group' => $nv_Lang->getModule('warehouse_group'),
                'warehouse_quantity' => $nv_Lang->getModule('warehouse_quantity'),
                'warehouse_price' => $nv_Lang->getModule('warehouse_price'),
                'warehouse_sale_price' => $nv_Lang->getModule('warehouse_sale_price')
            )
        );
        
        nv_jsonOutput($json_response);
    }
}

$template = get_tpl_dir([$global_config['module_theme'], $global_config['admin_theme']], 'admin_future', '/modules/' . $module_file . '/warehouse_logs.tpl');
$tpl = new \NukeViet\Template\NVSmarty();
$tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $template . '/modules/' . $module_file);

$tpl->assign('LANG', $nv_Lang);
$tpl->assign('MODULE_NAME', $module_name);
$tpl->assign('OP', $op);
$tpl->assign('SEARCH', $array_search);
$tpl->assign('CHECKSESS', md5($global_config['sitekey'] . session_id()));
$tpl->assign('BACK_URL', $base_url);

if ($wid > 0) {
    $tpl->assign('WAREHOUSE', $array_warehouse);
} else {
    $warehouses = array();
    $i = 1;
    while ($view = $sth->fetch()) {
        $view['no'] = $i;
        $view['full_name'] = !empty($view['last_name']) ? $view['first_name'] . ' ' . $view['last_name'] : $view['username'];
        $view['addtime'] = nv_date('H:i d/m/Y', $view['addtime']);
        
        // Lấy thông tin nhà cung cấp
        $view['supplier_name'] = '--';
        if (!empty($view['wid'])) {
            // Lấy supplier_id từ warehouse_logs_group
            $supplier_id = $db->query('SELECT DISTINCT t2.supplier_id 
                FROM ' . $db_config['prefix'] . '_' . $module_data . '_warehouse_logs t1 
                INNER JOIN ' . $db_config['prefix'] . '_' . $module_data . '_warehouse_logs_group t2 
                ON t1.logid=t2.logid 
                WHERE t1.wid=' . $view['wid'] . ' AND t2.supplier_id > 0 
                LIMIT 1')->fetchColumn();
            
            if ($supplier_id > 0) {
                $supplier = $db->query('SELECT title 
                    FROM ' . $db_config['prefix'] . '_' . $module_data . '_suppliers 
                    WHERE id = ' . intval($supplier_id))->fetch();
                if ($supplier) {
                    $view['supplier_name'] = $supplier['title'];
                }
            }
        }
        
        $view['link'] = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op . '&amp;wid=' . $view['wid'];
        $view['link_edit'] = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=warehouse&amp;wid=' . $view['wid'];
        
        $warehouses[] = $view;
        $i++;
    }

    $tpl->assign('WAREHOUSES', $warehouses);
    $tpl->assign('PAGES', nv_generate_page($base_url, $num_items, $per_page, $page));
}

$contents = $tpl->fetch('warehouse_logs.tpl');

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
