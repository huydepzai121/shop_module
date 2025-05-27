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
$error = [];
$page_title = $nv_Lang->getModule('warehouse');

// Xử lý AJAX request
if ($nv_Request->isset_request('ajax', 'post,get')) {
    $checkss = $nv_Request->get_string('checkss', 'post,get', '');
    if ($checkss != md5($global_config['sitekey'] . session_id())) {
        nv_jsonOutput(['status' => 'ERROR', 'message' => $nv_Lang->getModule('error_security')]);
    }

    $func = $nv_Request->get_string('func', 'post', '');
    $response = ['status' => 'ERROR', 'message' => $nv_Lang->getModule('unknown_error')];

    // API lấy thông tin giá
    if ($func == 'get_product_price') {
        $pro_id = $nv_Request->get_int('pro_id', 'post', 0);
        $listgroup = $nv_Request->get_string('listgroup', 'post', '');
        
        if ($pro_id > 0) {
            // Lấy thông tin giá từ bảng products_price
            $where = '';
            if (!empty($listgroup)) {
                $where .= ' AND listgroup = ' . $db->quote($listgroup);
            }
            
            $price_list = [];
            $result = $db->query('SELECT * FROM ' . $db_config['prefix'] . '_' . $module_data . '_products_price 
                WHERE product_id = ' . $pro_id . $where . '
                ORDER BY update_time DESC');
            
            while ($row = $result->fetch()) {
                $row['update_time'] = nv_date('d/m/Y H:i', $row['update_time']);
                $price_list[] = $row;
            }
            
            $response = [
                'status' => 'OK',
                'data' => $price_list
            ];
        }
        
        nv_jsonOutput($response);
    }
}

if ($nv_Request->isset_request('checkss', 'get') and $nv_Request->get_string('checkss', 'get') == md5($global_config['sitekey'] . session_id())) {
    $array_data = [];
    $array_warehouse = [
        'title' => $page_title,
        'note' => '',
        'from' => nv_date('d/m/Y')
    ];
    $listid = $nv_Request->get_string('listid', 'get', '');
    if (empty($listid)) {
        nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=items');
    } else {
        $listid = rtrim($listid, ',');
    }
    $array_rows = [];
    if (!empty($listid)) {
        $result = $db->query('SELECT * FROM ' . $db_config['prefix'] . '_' . $module_data . '_rows WHERE id IN (' . $listid . ')');
        while ($row = $result->fetch()) {
            if ($row['homeimgthumb'] == 1) {
                //image thumb
                $row['image_thumb'] = NV_BASE_SITEURL . NV_FILES_DIR . '/' . $module_upload . '/' . $row['homeimgfile'];
                $row['image_file'] = NV_BASE_SITEURL . NV_UPLOADS_DIR . '/' . $module_upload . '/' . $row['homeimgfile'];
            } elseif ($row['homeimgthumb'] == 2) {
                //image file
                $row['image_file'] = $row['image_thumb'] = NV_BASE_SITEURL . NV_UPLOADS_DIR . '/' . $module_upload . '/' . $row['homeimgfile'];
            } elseif ($row['homeimgthumb'] == 3) {
                //image url
                $row['image_file'] = $row['image_thumb'] = $row['homeimgfile'];
            } elseif (file_exists(NV_ROOTDIR . '/themes/' . $global_config['module_theme'] . '/images/' . $module_file . '/no-image.jpg')) {
                $row['image_file'] = $row['image_thumb'] = NV_STATIC_URL . 'themes/' . $theme . '/images/' . $module_file . '/no-image.jpg';
            } else {
                $row['image_file'] = $row['image_thumb'] = NV_STATIC_URL . 'themes/default/images/' . $module_file . '/no-image.jpg';
            }
            $array_warehouse[$row['id']] = $row;
        }
    }

    if ($nv_Request->isset_request('submit', 'post')) {
        $title = $nv_Request->get_title('title', 'post', $page_title);
        $note = $nv_Request->get_textarea('note', '', 'br');
        $data = $nv_Request->get_array('data', 'post', []);
        $from = $nv_Request->get_string('from', 'post', '');
        $supplier_id = $nv_Request->get_int('supplier_id', 'post', 0);

        if (empty($from)) {
            $error[] = $nv_Lang->getModule('error_from');
        }

        if (empty($title)) {
            $error[] = $nv_Lang->getModule('error_title');
        }

        if (empty($supplier_id)) {
            $error[] = $nv_Lang->getModule('error_supplier');
        }

        $title_day = $title . ' ' . $nv_Lang->getGlobal('day') . ' ' . $from;

        $sql = 'INSERT INTO ' . $db_config['prefix'] . '_' . $module_data . '_warehouse(title, note, user_id, addtime) VALUES (:title, :note, ' . $admin_info['admin_id'] . ', ' . NV_CURRENTTIME . ')';
        $data_insert = [];
        $data_insert['title'] = $title_day;
        $data_insert['note'] = $note;
        $wid = $db->insert_id($sql, 'wid', $data_insert);
        $dem = 0;
        
        if ($wid > 0 and !empty($data)) {
            foreach ($data as $pro_id => $items) {
                foreach ($items as $item) {
                    if (!empty($item['quantity'])) {
                        $listgroup = '';
                        if (isset($item['group']) && !empty($item['group'])) {
                            $listgroup = implode(',', array_values($item['group']));
                        }
                        
                        // Thêm vào warehouse_logs
                        $sql = 'INSERT INTO ' . $db_config['prefix'] . '_' . $module_data . '_warehouse_logs
                            (wid, pro_id, quantity, price, money_unit, supplier_id) 
                            VALUES (:wid, :pro_id, :quantity, :price, :money_unit, :supplier_id)';
                        
                        $data_insert = [];
                        $data_insert['wid'] = $wid;
                        $data_insert['pro_id'] = $pro_id;
                        $data_insert['quantity'] = $item['quantity'];
                        $data_insert['price'] = !empty($item['price']) ? str_replace(',', '', $item['price']) : 0;
                        $data_insert['money_unit'] = !empty($item['money_unit']) ? $item['money_unit'] : $pro_config['money_unit'];
                        $data_insert['supplier_id'] = intval($item['supplier_id']);
                        
                        $logid = $db->insert_id($sql, 'logid', $data_insert);
                        
                        if ($logid > 0) {
                            if (!empty($listgroup)) {
                                $sql = 'INSERT INTO ' . $db_config['prefix'] . '_' . $module_data . '_warehouse_logs_group
                                    (logid, listgroup, quantity, price, money_unit, supplier_id) 
                                    VALUES (:logid, :listgroup, :quantity, :price, :money_unit, :supplier_id)';
                                
                                $data_group = [];
                                $data_group['logid'] = $logid;
                                $data_group['listgroup'] = $listgroup;
                                $data_group['quantity'] = $item['quantity'];
                                $data_group['price'] = !empty($item['price']) ? str_replace(',', '', $item['price']) : 0;
                                $data_group['money_unit'] = !empty($item['money_unit']) ? $item['money_unit'] : $pro_config['money_unit'];
                                $data_group['supplier_id'] = intval($item['supplier_id']);
                                
                                $db->insert_id($sql, 'id', $data_group);
                            }
                            
                            if (!empty($item['price'])) {
                                $price = str_replace(',', '', $item['price']);
                                
                                $sql = 'INSERT INTO ' . $db_config['prefix'] . '_' . $module_data . '_products_price
                                    (product_id, price, money_unit, warehouse_id, warehouse_logs_id, warehouse_logs_group_id, 
                                    userid, add_time, update_time, note) 
                                    VALUES (:product_id, :price, :money_unit, :warehouse_id, :warehouse_logs_id, :warehouse_logs_group_id,
                                    :userid, :add_time, :update_time, :note)';
                                
                                $price_data = [];
                                $price_data['product_id'] = $pro_id;
                                $price_data['price'] = $price;
                                $price_data['money_unit'] = !empty($item['money_unit']) ? $item['money_unit'] : $pro_config['money_unit'];
                                $price_data['warehouse_id'] = $wid;
                                $price_data['warehouse_logs_id'] = $logid;
                                $price_data['warehouse_logs_group_id'] = 0;
                                if (!empty($listgroup)) {
                                    $result = $db->query('SELECT id FROM ' . $db_config['prefix'] . '_' . $module_data . '_warehouse_logs_group WHERE logid = ' . $logid . ' AND listgroup = ' . $db->quote($listgroup));
                                    if ($row = $result->fetch()) {
                                        $price_data['warehouse_logs_group_id'] = $row['id'];
                                    }
                                }
                                $price_data['userid'] = $admin_info['userid'];
                                $price_data['add_time'] = NV_CURRENTTIME;
                                $price_data['update_time'] = NV_CURRENTTIME;
                                $price_data['note'] = $nv_Lang->getModule('price_added_from_warehouse');
                                
                                $stmt = $db->prepare($sql);
                                $stmt->execute($price_data);
                                $price_id = $db->lastInsertId();
                                
                                if ($price_id > 0) {
                                    $db->query('INSERT INTO ' . $db_config['prefix'] . '_' . $module_data . '_price_history
                                        (price_id, old_price, new_price, userid, change_time, reason)
                                        VALUES (' . $price_id . ', 0, ' . $price . ', ' . $admin_info['userid'] . ', ' . NV_CURRENTTIME . ', ' . $db->quote($nv_Lang->getModule('price_added')) . ')');
                                }
                            }
                            
                            $db->query('UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_rows SET product_number = product_number + ' . $item['quantity'] . ' WHERE id = ' . $pro_id);
                            
                            if (!empty($listgroup)) {
                                $exists = $db->query('SELECT quantity FROM ' . $db_config['prefix'] . '_' . $module_data . '_group_quantity WHERE pro_id = ' . $pro_id . ' AND listgroup = ' . $db->quote($listgroup))->fetch();
                                
                                if ($exists) {
                                    $db->query('UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_group_quantity SET quantity = quantity + ' . $item['quantity'] . ' WHERE pro_id = ' . $pro_id . ' AND listgroup = ' . $db->quote($listgroup));
                                } else {
                                    $db->query('INSERT INTO ' . $db_config['prefix'] . '_' . $module_data . '_group_quantity(pro_id, listgroup, quantity) VALUES(' . $pro_id . ', ' . $db->quote($listgroup) . ', ' . $item['quantity'] . ')');
                                }
                            }
                            
                            $dem++;
                        }
                    }
                }
            }
            
            if ($dem > 0) {
                nv_insert_logs(NV_LANG_DATA, $module_name, $nv_Lang->getModule('warehouse_logs_add'), $title_day, $admin_info['userid']);
                $nv_Cache->delMod($module_name);
                nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=warehouse_logs&wid=' . $wid);
            }
        }
    }

    // List pro_unit
    $array_unit = [];
    $sql = 'SELECT id, ' . NV_LANG_DATA . '_title title FROM ' . $db_config['prefix'] . '_' . $module_data . '_units';
    $result_unit = $db->query($sql);
    if ($result_unit->rowCount() > 0) {
        while ($row = $result_unit->fetch()) {
            $array_unit[$row['id']] = $row;
        }
    }

    $_sql = 'SELECT id, listcatid, ' . NV_LANG_DATA . '_title title, ' . NV_LANG_DATA . '_alias alias, product_number, product_unit, money_unit FROM ' . $db_config['prefix'] . '_' . $module_data . '_rows WHERE id IN (' . $listid . ') ORDER BY addtime DESC';
    $_query = $db->query($_sql);

    while ($row = $_query->fetch()) {
        $array_group = [];
        $result = $db->query('SELECT listgroup FROM ' . $db_config['prefix'] . '_' . $module_data . '_group_quantity WHERE pro_id=' . $row['id']);
        while (list($listgroup) = $result->fetch(3)) {
            $array_group[] = $listgroup;
        }
        $row['listgroup'] = $array_group;
        $array_data[$row['id']] = $row;
    }

    $template = get_tpl_dir([$global_config['module_theme'], $global_config['admin_theme']], 'admin_future', '/modules/' . $module_file . '/warehouse.tpl');
    $tpl = new \NukeViet\Template\NVSmarty();
    $tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $template . '/modules/' . $module_file);

    // Gán dữ liệu cho template
    $tpl->assign('LANG', $nv_Lang);
    $tpl->assign('MODULE_NAME', $module_name);
    $tpl->assign('OP', $op);
    $tpl->assign('ROW', $array_warehouse);
    
    // Thêm lấy danh sách nhà cung cấp
    $sql = 'SELECT id, title FROM ' . $db_config['prefix'] . '_' . $module_data . '_suppliers WHERE status=1 ORDER BY title ASC';
    $suppliers = $db->query($sql)->fetchAll();
    $tpl->assign('SUPPLIERS', $suppliers);

    // Lấy danh sách đơn vị tiền tệ
    $sql = 'SELECT code, currency, symbol, exchange, round, number_format FROM ' . $db_config['prefix'] . '_' . $module_data . '_money_' . NV_LANG_DATA;
    $money_config = array();
    $result = $db->query($sql);
    while ($row = $result->fetch()) {
        $money_config[$row['code']] = array(
            'code' => $row['code'],
            'currency' => $row['currency'],
            'symbol' => $row['symbol'],
            'exchange' => $row['exchange'],
            'round' => $row['round'],
            'number_format' => $row['number_format'],
            'decimals' => $row['round'] > 1 ? $row['round'] : strlen($row['round']) - 2,
            'is_config' => ($row['code'] == $pro_config['money_unit']) ? 1 : 0
        );
    }
    $result->closeCursor();

    if (!empty($array_data)) {
        $i = 1;
        foreach ($array_data as $key => $data) {
            $array_data[$key]['no'] = $i;
            $array_data[$key]['product_unit'] = $array_unit[$data['product_unit']]['title'];
            $array_data[$key]['link'] = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $global_array_shops_cat[$data['listcatid']]['alias'] . '/' . $data['alias'] . $global_config['rewrite_exturl'];

            // Nhóm sản phẩm
            $listgroup = GetGroupID($data['id']);
            if (!empty($listgroup)) {
                $parent_id = [];
                foreach ($listgroup as $group_id) {
                    $parent_id[] = $global_array_group[$group_id]['parentid'];
                }
                $parent_id = array_unique($parent_id);

                if (!empty($parent_id)) {
                    if (empty($data['listgroup'])) {
                        $array_data[$key]['listgroup'][] = implode(',', $listgroup);
                    }

                    // Lấy nhóm cha
                    $array_data[$key]['parent_groups'] = [];
                    foreach ($parent_id as $parent_id_i) {
                        $parent = $global_array_group[$parent_id_i];
                        if ($parent['in_order']) {
                            $array_data[$key]['parent_groups'][] = $parent;
                        }
                    }

                    // Lấy nhóm con
                    $array_data[$key]['groups'] = [];
                    foreach ($parent_id as $parent_id_i) {
                        foreach ($listgroup as $groupid) {
                            $group = $global_array_group[$groupid];
                            if ($group['parentid'] == $parent_id_i && $group['in_order']) {
                                $array_data[$key]['groups'][$group['parentid']][] = $group;
                            }
                        }
                    }
                }
            }
            $i++;
        }
    }

    $tpl->assign('DATA', $array_data);
    $tpl->assign('MONEY_CONFIG', $money_config);

    if (!empty($error)) {
        $tpl->assign('ERROR', implode('<br />', $error));
    }

    $contents = $tpl->fetch('warehouse.tpl');

    include NV_ROOTDIR . '/includes/header.php';
    echo nv_admin_theme($contents);
    include NV_ROOTDIR . '/includes/footer.php';
} else {
    nv_redirect_location(NV_BASE_ADMINURL. 'index.php?'. NV_LANG_VARIABLE. '='. NV_LANG_DATA. '&'. NV_NAME_VARIABLE. '='. $module_name. '&'. NV_OP_VARIABLE. '=items');
}
