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

if ($nv_Request->isset_request('del', 'post,get')) {
    $dellist = $nv_Request->isset_request('dellist', 'post,get');
    if ($dellist) {
        $array_id = $nv_Request->get_string('listid', 'post,get');
        $array_id = explode(',', $array_id);

        foreach ($array_id as $review_id) {
            if (!empty($review_id)) {
                $db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_review WHERE review_id=' . $review_id);
            }
        }
        $nv_Cache->delMod($module_name);
        nv_htmlOutput('OK');
    } else {
        $id = $nv_Request->get_int('id', 'post,get', 0);
        if (empty($id)) {
            die('NO');
        }

        $result = $db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_review WHERE review_id=' . $id);
        if ($result) {
            $nv_Cache->delMod($module_name);
            nv_htmlOutput('OK');
        }
    }
    nv_htmlOutput('NO');
}

// Xử lý xóa review
if ($nv_Request->isset_request('delete', 'get,post')) {
    $review_id = $nv_Request->get_int('review_id', 'post,get', 0);
    
    if (empty($review_id)) {
        $json['status'] = 'ERROR';
        $json['message'] = $nv_Lang->getModule('review_delete_error_empty');
    }

    if ($review_id > 0) {
        try {
            // Xóa review
            $sql = 'DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_review WHERE review_id = ' . $review_id;
            if ($db->exec($sql)) {
                $json['status'] = 'OK';
                $json['message'] = $nv_Lang->getModule('review_delete_success');
                
                // Xóa cache nếu cần
                $nv_Cache->delMod($module_name);
            }
        } catch (PDOException $e) {
            $json['message'] = $nv_Lang->getModule('review_delete_error');
        }
    }

    nv_jsonOutput($json);
}

if ($nv_Request->isset_request('delete_multiple', 'get,post')) {
    $listid = $nv_Request->get_string('listid', 'post,get');
    $listid = explode(',', $listid);

    if (empty($listid)) {
        nv_jsonOutput([
            'status' => 'ERROR',
            'message' => $nv_Lang->getModule('please_select_one')
        ]);
    }
    try {
        foreach ($listid as $review_id) {
            $sql = 'DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_review WHERE review_id=' . $review_id;
            $db->query($sql);
        }
        $nv_Cache->delMod($module_name);
        nv_jsonOutput([
            'status' => 'OK',
            'message' => $nv_Lang->getModule('review_delete_success')
        ]);
    } catch (PDOException $e) {
        nv_jsonOutput([
            'status' => 'ERROR',
            'message' => $nv_Lang->getModule('review_delete_error')
        ]);
    }
}

if ($nv_Request->isset_request('change_status_review', 'get,post')) {
    $listid = $nv_Request->get_string('listid', 'post,get');
    $listid = explode(',', $listid);
    $new_status = $nv_Request->get_int('status', 'post,get', 0);

    if (empty($listid)) {
        nv_jsonOutput([
            'status' => 'ERROR',
            'message' => $nv_Lang->getModule('please_select_one')
        ]);
    }
    try {
        foreach ($listid as $review_id) {
            $sql = 'UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_review SET status=' . $new_status . ' WHERE review_id=' . $review_id;
            $db->query($sql);
        }
        $nv_Cache->delMod($module_name);
        nv_jsonOutput([
            'status' => 'OK',
            'message' => $nv_Lang->getModule('review_status_success')
        ]);
    } catch (PDOException $e) {
        nv_jsonOutput([
            'status' => 'ERROR',
            'message' => $nv_Lang->getModule('review_status_error')
        ]);
    }
}
    

if ($nv_Request->isset_request('change_status', 'get,post')) {
    $array_id = $nv_Request->get_string('listid', 'post,get');
    $array_id = explode(',', $array_id);
    $new_status = $nv_Request->get_int('status', 'post,get', 0);
    $new_status = ( int )$new_status;

    foreach ($array_id as $review_id) {
        if (!empty($review_id)) {
            $sql = 'UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_review SET status=' . $new_status . ' WHERE review_id=' . $review_id;
            $db->query($sql);
        }
    }
    $nv_Cache->delMod($module_name);
    nv_htmlOutput('OK');
}

$per_page = 20;
$page = $nv_Request->get_int('page', 'post,get', 1);
$array_search = array();
$array_search['product_id'] = $nv_Request->get_int('product_id', 'get', 0);
$array_search['keywords'] = $nv_Request->get_title('keywords', 'get', '');
$array_search['status'] = $nv_Request->get_int('status', 'get', -1);

$db->sqlreset()
    ->select('COUNT(*)')
    ->from($db_config['prefix'] . '_' . $module_data . '_review t1')
    ->join('INNER JOIN ' . $db_config['prefix'] . '_' . $module_data . '_rows t2 ON t1.product_id = t2.id');

$where = '';
$base_url = '';

if (!empty($array_search['keywords'])) {
    $where .= ' AND ' . NV_LANG_DATA . '_title LIKE :q_title OR sender LIKE :q_sender OR content like :q_content';
}

if (!empty($array_search['product_id'])) {
    $where .= ' AND t1.product_id = ' . $array_search['product_id'];
}

if ($array_search['status'] >= 0) {
    $where .= ' AND t1.status = ' . $array_search['status'];
}

if (! empty($where)) {
    $db->where('1=1' . $where);
}

$sth = $db->prepare($db->sql());

if (!empty($array_search['keywords'])) {
    $sth->bindValue(':q_title', '%' . $array_search['keywords'] . '%');
    $sth->bindValue(':q_sender', '%' . $array_search['keywords'] . '%');
    $sth->bindValue(':q_content', '%' . $array_search['keywords'] . '%');
}

$sth->execute();
$num_items = $sth->fetchColumn();

$db->select('t1.*, t2.listcatid, t2.' . NV_LANG_DATA . '_title title, t2.' . NV_LANG_DATA . '_alias alias')->order('review_id DESC')->limit($per_page)->offset(($page - 1) * $per_page);
$sth = $db->prepare($db->sql());

if (!empty($array_search['keywords'])) {
    $sth->bindValue(':q_title', '%' . $array_search['keywords'] . '%');
    $sth->bindValue(':q_sender', '%' . $array_search['keywords'] . '%');
    $sth->bindValue(':q_content', '%' . $array_search['keywords'] . '%');
}
$sth->execute();

$template = get_tpl_dir([$global_config['module_theme'], $global_config['admin_theme']], 'admin_future', '/modules/' . $module_file . '/content.tpl');
$tpl = new \NukeViet\Template\NVSmarty();
$tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $template . '/modules/' . $module_file);

$tpl->assign('LANG', $nv_Lang);
$tpl->assign('MODULE_NAME', $module_name);
$tpl->assign('OP', $op);
$tpl->assign('SEARCH', $array_search);

$array_status = array( '1' => $nv_Lang->getModule('review_status_1'), '0' => $nv_Lang->getModule('review_status_0') );
$status_options = [];
foreach ($array_status as $key => $value) {
    $status_options[] = [
        'key' => $key,
        'value' => $value,
        'selected' => ($array_search['status'] == $key)
    ];
}
$tpl->assign('STATUS_OPTIONS', $status_options);

$reviews = [];
while ($view = $sth->fetch()) {
    $reviews[] = [
        'review_id' => $view['review_id'],
        'title' => $view['title'],
        'sender' => $view['sender'],
        'rating' => $view['rating'],
        'content' => $view['content'],
        'add_time' => nv_date('H:i d/m/Y', $view['add_time']),
        'status' => $nv_Lang->getModule('review_status_' . $view['status']),
        'link_product' => NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $global_array_shops_cat[$view['listcatid']]['alias'] . '/' . $view['alias'] . $global_config['rewrite_exturl']
    ];
}

$tpl->assign('REVIEWS', $reviews);
$tpl->assign('PAGES', nv_generate_page($base_url, $num_items, $per_page, $page));

$contents = $tpl->fetch('review.tpl');

$page_title = $nv_Lang->getModule('review');

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
