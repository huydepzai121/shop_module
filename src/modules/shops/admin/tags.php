<?php

/**
 * NukeViet Content Management System
 * @version 4.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2023 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_IS_FILE_ADMIN')) {
    exit('Stop!!!');
}

$page_title = $nv_Lang->getModule('tags');

// Lấy tags từ nội dung bài viết
if ($nv_Request->isset_request('getTagsFromContent', 'post')) {
    $content = $nv_Request->get_title('content', 'post', '');
    $tags = nv_get_mod_tags($content);
    nv_jsonOutput($tags);
}

$checkss = $nv_Request->get_string('checkss', 'post', '');

// Xóa các liên kết
if ($nv_Request->isset_request('tagsIdDel', 'post')) {
    $tid = $nv_Request->get_int('tid', 'post', 0);
    $ids = $nv_Request->get_title('ids', 'post', '');

    $respon = [
        'success' => 0,
        'text' => 'Error session!!!'
    ];

    if (!empty($ids) and !empty($tid) and $checkss === NV_CHECK_SESSION) {
        nv_insert_logs(NV_LANG_DATA, $module_name, 'DEL_TAG_IDS', $tid . ': ' . $ids, $admin_info['userid']);

        $ids = preg_replace('/[^0-9\,]+/', '', $ids);
        $db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_tags_id_' . NV_LANG_DATA . ' WHERE tid = ' . $tid . ' AND id IN (' . $ids . ')');
        $num = $db->query('SELECT COUNT(*) FROM ' . $db_config['prefix'] . '_' . $module_data . '_tags_id_' . NV_LANG_DATA . ' where tid=' . $tid)->fetchColumn();
        $db->query('UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_tags_' . NV_LANG_DATA . ' SET numpro=' . $num . ' WHERE tid=' . $tid);
        
        $respon = [
            'success' => 1,
            'text' => $nv_Lang->getModule('delete_success')
        ];
    }

    nv_jsonOutput($respon);
}

// Sửa keyword
if ($nv_Request->isset_request('keywordEdit', 'post')) {
    $respon = [
        'success' => 0,
        'text' => 'Error session!!!'
    ];

    $id = $nv_Request->get_int('id', 'post', 0);
    $tid = $nv_Request->get_int('tid', 'post', 0);
    $keyword = $nv_Request->get_title('keyword', 'post', '');
    if (!empty($keyword) and $checkss === NV_CHECK_SESSION) {
        nv_insert_logs(NV_LANG_DATA, $module_name, 'EDIT_TAGID_KEYWORD', $tid . '-' . $id . ': ' . $keyword, $admin_info['userid']);

        $sth = $db->prepare('UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_tags_id SET keyword = :keyword WHERE id=' . $id . ' AND tid =' . $tid);
        $sth->bindParam(':keyword', $keyword, PDO::PARAM_STR);
    $sth->execute();

        $respon['success'] = 1;
        $respon['keyword'] = $keyword;
        nv_jsonOutput($respon);
    }

    nv_jsonOutput($respon);
}

// Xóa nhiều tags
if ($nv_Request->isset_request('del_listid', 'post')) {
    $del_listid = $nv_Request->get_string('del_listid', 'post', '');
    $del_listid = array_map('intval', explode(',', $del_listid));
    $del_listid = array_filter($del_listid);
    if (!empty($del_listid) and NV_CHECK_SESSION == $checkss) {
        $del_listid = implode(',', $del_listid);
        nv_insert_logs(NV_LANG_DATA, $module_name, 'DEL_TAGS', $del_listid, $admin_info['userid']);

        $db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_tags_' . NV_LANG_DATA . ' WHERE tid IN (' . $del_listid . ')');
        $db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_tags_id_' . NV_LANG_DATA . ' WHERE tid IN (' . $del_listid . ')');

        nv_jsonOutput([
            'success' => 1,
            'text' => $nv_Lang->getModule('delete_success')
        ]);
    }

    nv_jsonOutput([
        'success' => 0,
        'text' => $nv_Lang->getModule('delete_error')
    ]);
}

// Xóa tag
if ($nv_Request->isset_request('del_tid', 'post')) {
    $tid = $nv_Request->get_int('del_tid', 'post', 0);

    if (!empty($tid) and NV_CHECK_SESSION == $checkss) {
        nv_insert_logs(NV_LANG_DATA, $module_name, 'DEL_TAG', $tid, $admin_info['userid']);

        $db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_tags_' . NV_LANG_DATA . ' WHERE tid=' . $tid);
        $db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_tags_id_' . NV_LANG_DATA . ' WHERE tid=' . $tid);

        nv_jsonOutput([
            'success' => 1,
            'text' => ''
        ]);
    }

    nv_jsonOutput([
        'success' => 0,
        'text' => 'Wrong session or no tag ID!'
    ]);
}

// Thêm nhiều tags
if ($nv_Request->isset_request('savetag', 'post')) {
    $respon = [
        'status' => 'error',
        'mess' => 'Error!!!',
    ];

    $title = $nv_Request->get_textarea('mtitle', '', NV_ALLOWED_HTML_TAGS, true);
    $list_tag = explode('<br />', strip_tags($title, '<br>'));
    $added = [];
    $aliases = [];

    foreach ($list_tag as $tag_i) {
        $keywords = trim(strip_tags($tag_i));
        if (nv_strlen($keywords) >= 2) {
            $dbexist = false;
            $keywords = setTagKeywords($keywords);
            $alias = setTagAlias($keywords, 0, $dbexist);
            if (!$dbexist) {
                $sth = $db->prepare('INSERT IGNORE INTO ' . $db_config['prefix'] . '_' . $module_data . "_tags_" . NV_LANG_DATA . " (keywords, alias, description) VALUES (:keywords, :alias, '')");
                $sth->bindParam(':alias', $alias, PDO::PARAM_STR);
                $sth->bindParam(':keywords', $keywords, PDO::PARAM_STR);
                $sth->execute();
                $added[] = $keywords;
                $aliases[] = $alias;
            }
        }
    }

    if (empty($added)) {
        $respon['mess'] = $nv_Lang->getModule('add_multi_tags_empty');
        nv_jsonOutput($respon);
    }
    $added = implode('; ', $added);
    $aliases = implode('; ', $aliases);
    nv_insert_logs(NV_LANG_DATA, $module_name, 'add_multi_tags', $aliases, $admin_info['userid']);

    $respon['status'] = 'success';
    $respon['mess'] = $nv_Lang->getModule('add_multi_tags') . ': ' . $added;
    $respon['refresh'] = 1;
    nv_jsonOutput($respon);
}

// Thêm tag hoặc sửa tag
if ($nv_Request->isset_request('savecat', 'post')) {
    $tid = $nv_Request->get_int('tid', 'post', 0);
    if (!empty($tid)) {
        $num = $db->query('SELECT COUNT(*) FROM ' . $db_config['prefix'] . '_' . $module_data . '_tags_' . NV_LANG_DATA . ' where tid=' . $tid)->fetchColumn();
        if (!$num) {
            nv_jsonOutput([
                'status' => 'error',
                'mess' => $nv_Lang->getModule('error_tag_tid')
            ]);
        }
    }

    $keywords = $nv_Request->get_title('keywords', 'post', '');
    if (nv_strlen($keywords) < 2) {
        nv_jsonOutput([
            'status' => 'error',
            'input' => 'keywords',
            'mess' => $nv_Lang->getModule('error_tag_keywords')
        ]);
    }
    $dbexist = false;
    $keywords = setTagKeywords($keywords);
    $alias = setTagAlias($keywords, $tid, $dbexist);

    if ($dbexist) {
        nv_jsonOutput([
            'status' => 'error',
            'input' => 'keywords',
            'mess' => $nv_Lang->getModule('error_tag_keywords_exist')
        ]);
    }

    $description = $nv_Request->get_string('description', 'post', '');
    $description = nv_nl2br(nv_htmlspecialchars(strip_tags($description)), '<br />');

    $image = $nv_Request->get_string('image', 'post', '');
    if (nv_is_file($image, NV_UPLOADS_DIR . '/' . $module_upload)) {
        $lu = strlen(NV_BASE_SITEURL . NV_UPLOADS_DIR . '/' . $module_upload . '/');
        $image = substr($image, $lu);
    } else {
        $image = '';
    }

    if (empty($tid)) {
        $sth = $db->prepare('INSERT INTO ' . $db_config['prefix'] . '_' . $module_data . '_tags_' . NV_LANG_DATA . '(keywords, alias, description, image) VALUES (:keywords, :alias, :description, :image)');
        $msg_lg = 'add_tags';
    } else {
        $sth = $db->prepare('UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_tags_' . NV_LANG_DATA . ' SET keywords = :keywords, alias = :alias, description = :description, image = :image WHERE tid =' . $tid);
            $msg_lg = 'edit_tags';
        }

        try {
            $sth->bindParam(':alias', $alias, PDO::PARAM_STR);
            $sth->bindParam(':description', $description, PDO::PARAM_STR);
            $sth->bindParam(':image', $image, PDO::PARAM_STR);
            $sth->bindParam(':keywords', $keywords, PDO::PARAM_STR);
            $sth->execute();

            nv_insert_logs(NV_LANG_DATA, $module_name, $msg_lg, $alias, $admin_info['userid']);
    } catch (Throwable $e) {
        trigger_error(print_r($e, true));
        nv_jsonOutput([
            'status' => 'error',
            'mess' => $nv_Lang->getModule('errorsave')
        ]);
    }
    nv_jsonOutput([
        'status' => 'ok',
        'mess' => $nv_Lang->getModule('content_saveok'),
        'refresh' => 1
    ]);
}

// Danh sách liên kết
if ($nv_Request->isset_request('tagLinks', 'post')) {
    $respon = [
        'success' => 0,
        'text' => 'Error!!!',
        'html' => ''
    ];
    if (NV_CHECK_SESSION !== $checkss) {
        $respon['text'] = 'Wrong session!!!';
        nv_jsonOutput($respon);
    }

    $tid = $nv_Request->get_int('tid', 'post', 0);
    [$tid, $keywords] = $db_slave->query('SELECT tid, keywords FROM ' . $db_config['prefix'] . '_' . $module_data . '_tags_' . NV_LANG_DATA . ' where tid=' . $tid)->fetch(3);
    if (empty($tid)) {
        $respon['text'] = 'Tag not exists!!!';
        nv_jsonOutput($respon);
    }
    $keywords = explode(',', $keywords);
    $keywords = array_map('trim', $keywords);

    $sql = 'SELECT a.tid, a.keyword, 
               b.id, 
               b.' . NV_LANG_DATA . '_title AS title_row, 
               b.' . NV_LANG_DATA . '_alias AS alias_row, 
               c.catid, 
               c.' . NV_LANG_DATA . '_title AS title_catalog,
               c.' . NV_LANG_DATA . '_alias AS alias_catalog
        FROM ' . $db_config['prefix'] . '_' . $module_data . '_tags_id_' . NV_LANG_DATA . ' a
        INNER JOIN ' . $db_config['prefix'] . '_' . $module_data . '_rows b ON a.id = b.id
        INNER JOIN ' . $db_config['prefix'] . '_' . $module_data . '_catalogs c ON FIND_IN_SET(c.catid, b.listcatid)
        WHERE a.tid = ' . $tid;
    $result = $db_slave->query($sql);

    $array = [];
    while ($row = $result->fetch()) {
        $row['url'] = nv_url_rewrite(NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $row['alias_catalog'] . '/' . $row['alias_row'] . $global_config['rewrite_exturl'], true);
        $array[] = $row;
    }

    $template = get_tpl_dir([$global_config['module_theme'], $global_config['admin_theme']], 'admin_default', '/modules/' . $module_file . '/tags-link.tpl');
    $tpl = new \NukeViet\Template\NVSmarty();
    $tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $template . '/modules/' . $module_file);
    $tpl->registerPlugin('modifier', 'nv_number_format', 'nv_number_format');
    $tpl->assign('LANG', $nv_Lang);
    $tpl->assign('MODULE_NAME', $module_name);
    $tpl->assign('OP', $op);
    $tpl->assign('DATA', $array);

    $tpl->assign('TID', $tid);
    $tpl->assign('KEYWORDS', $keywords);

    $respon['success'] = 1;
    $respon['html'] = $tpl->fetch('tags-link.tpl');
    nv_jsonOutput($respon);
}

// Lấy thông tin tag để sửa
if ($nv_Request->isset_request('loadEditTag', 'post')) {
    $respon = [
        'success' => 0,
        'text' => 'Error!!!'
    ];
    if (NV_CHECK_SESSION !== $checkss) {
        $respon['text'] = 'Wrong session!!!';
        nv_jsonOutput($respon);
    }

    $tid = $nv_Request->get_int('tid', 'post', 0);
    [$tid, $keywords, $description, $image] = $db_slave->query('SELECT tid, keywords, description, image FROM ' . $db_config['prefix'] . '_' . $module_data . '_tags_' . NV_LANG_DATA . ' where tid=' . $tid)->fetch(3);
    if (empty($tid)) {
        $respon['text'] = 'Tag not exists!!!';
        nv_jsonOutput($respon);
    }

    $currentpath = NV_UPLOADS_DIR . '/' . $module_upload;
if (!empty($image) and file_exists(NV_UPLOADS_REAL_DIR . '/' . $module_upload . '/' . $image)) {
    $image = NV_BASE_SITEURL . NV_UPLOADS_DIR . '/' . $module_upload . '/' . $image;
        $currentpath = dirname($image);
    }

    $respon['success'] = 1;
    $respon['data'] = [
        'currentpath' => $currentpath,
        'description' => nv_unhtmlspecialchars(nv_br2nl($description)),
        'keywords' => nv_unhtmlspecialchars($keywords),
        'image' => nv_unhtmlspecialchars($image)
    ];
    nv_jsonOutput($respon);
}

// Mặc định hiển thị danh sách tags
$complete = $nv_Request->get_bool('complete', 'get,post', false);
$incomplete = $nv_Request->get_bool('incomplete', 'get,post', false);
$page = $nv_Request->get_absint('page', 'get', 1);
$per_page = 20;
$where = [];
$base_url = NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op;

if ($incomplete === true) {
    $where[] = "description = ''";
    $base_url .= '&amp;incomplete=1';
} elseif ($complete === true) {
    $where[] = "description != ''";
    $base_url .= '&amp;complete=1';
}

$q = $nv_Request->get_title('q', 'get', '');
if (nv_strlen($q) >= 2) {
    $where[] = "keywords LIKE '%" . $db_slave->dblikeescape($q) . "%'";
    $base_url .= '&amp;q=' . urlencode($q);
}

$where = !empty($where) ? implode(' AND ', $where) : '';

$db_slave->sqlreset()
    ->select('COUNT(tid)')
    ->from($db_config['prefix'] . '_' . $module_data . '_tags_' . NV_LANG_DATA)
    ->where($where);

$sth = $db_slave->prepare($db_slave->sql());
$sth->execute();
$num_items = $sth->fetchColumn();

$db_slave->sqlreset()
    ->select('*')
    ->from($db_config['prefix'] . '_' . $module_data . '_tags_' . NV_LANG_DATA)
    ->where($where)
    ->order('keywords ASC')
    ->limit($per_page)
    ->offset(($page - 1) * $per_page);

$sth = $db_slave->prepare($db_slave->sql());
$sth->execute();

$array = [];
while ($row = $sth->fetch()) {
    $row['link'] = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $module_info['alias']['tag'] . '/' . $row['alias'];
    $row['numpro'] = isset($row['numpro']) ? intval($row['numpro']) : 0;
    
    if (empty($row['keywords'])) {
        $row['keywords'] = nv_ucfirst($row['keywords']);
        $sths = $db_slave->prepare('UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_tags_' . NV_LANG_DATA . ' SET keywords = :keywords WHERE tid =' . $row['tid']);
        $sths->bindParam(':keywords', $row['keywords'], PDO::PARAM_STR);
        $sths->execute();
    }
    $array[] = $row;
}
$sth->closeCursor();
$num_items = !empty($num_items) ? intval($num_items) : 0;

$generate_page = nv_generate_page($base_url, $num_items, $per_page, $page);

$nv_Lang->setGlobal('title_suggest_max', $nv_Lang->getGlobal('length_suggest_max', 65));
$nv_Lang->setGlobal('description_suggest_max', $nv_Lang->getGlobal('length_suggest_max', 160));

$tpl = new \NukeViet\Template\NVSmarty();
$tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $global_config['module_theme'] . '/modules/' . $module_file);
$tpl->registerPlugin('modifier', 'nv_number_format', 'nv_number_format');
$tpl->assign('LANG', $nv_Lang);
$tpl->assign('MODULE_NAME', $module_name);
$tpl->assign('OP', $op);
$tpl->assign('NV_CHECK_SESSION', NV_CHECK_SESSION);

$tpl->assign('INCOMPLETE', $incomplete);
$tpl->assign('COMPLETE', $complete);
$tpl->assign('Q', $q);
$tpl->assign('NUM_ITEMS', $num_items);
$tpl->assign('DATA', $array);
$tpl->assign('PAGINATION', $generate_page);
$tpl->assign('UPLOAD_PATH', NV_UPLOADS_DIR . '/' . $module_upload);

$contents = $tpl->fetch('tags.tpl');

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
