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

$page_title = $nv_Lang->getModule('group');

$currentpath = NV_UPLOADS_DIR . '/' . $module_upload . '/' . date('Y_m');
if (!file_exists($currentpath)) {
    nv_mkdir(NV_UPLOADS_REAL_DIR . '/' . $module_upload, date('Y_m'), true);
}

$table_name = $db_config['prefix'] . '_' . $module_data . '_group';
$error = $admins = '';
$savegroup = 0;
$data = [];
$data['cateid_old'] = 0;
list($data['groupid'], $data['parentid'], $data['title'], $data['alias'], $data['description'], $data['keywords'], $data['cateid'], $data['numpro'], $data['image']) = [
    0, 0, '', '', '', '', [], 0, ''
];

$data['parentid'] = $nv_Request->get_int('parentid', 'get,post', 0);
$data['groupid'] = $nv_Request->get_int('groupid', 'get', 0);
if ($data['groupid'] > 0) {
    list($data['groupid'], $data['parentid'], $data['title'], $data['alias'], $data['description'], $data['keywords'], $data['image'], $data['require']) = $db->query('SELECT groupid, parentid, ' . NV_LANG_DATA . '_title, ' . NV_LANG_DATA . '_alias, ' . NV_LANG_DATA . '_description, ' . NV_LANG_DATA . '_keywords, image, is_require FROM ' . $table_name . ' where groupid=' . $data['groupid'])->fetch(3);
    $result = $db->query('SELECT cateid FROM ' . $db_config['prefix'] . '_' . $module_data . '_group_cateid WHERE groupid = ' . $data['groupid'] . ' ORDER BY cateid');
    if ($result) {
        while ($row = $result->fetchColumn()) {
            $data['cateid'][] = $row;
        }
    }

    $data['cateid_old'] = $data['cateid'];

    $data['require_ck'] = $data['require'] ? 'checked="checked"' : '';

    $caption = $nv_Lang->getModule('edit_group');
} else {
    $caption = $nv_Lang->getModule('add_group');
}



if ($nv_Request->isset_request('mod', 'post, get')) {
    $mod = $nv_Request->get_string('mod', 'post, get', '');
    $groupid = $nv_Request->get_int('groupid', 'post, get', 0);
    $new_vid = $nv_Request->get_title('newvid', 'post, get', '');
    $parentid = $nv_Request->get_int('parentid', 'post, get', 0);

    try {
        if ($mod == 'weight' and $new_vid > 0) {
            $sql = 'SELECT groupid FROM ' . $table_name . ' WHERE groupid!=' . $groupid . ' AND parentid=' . $parentid . ' ORDER BY weight ASC';
            $result = $db->query($sql);
    
            $weight = 0;
            while ($row = $result->fetch()) {
                ++$weight;
                if ($weight == $new_vid) {
                    ++$weight;
                }
                $sql = 'UPDATE ' . $table_name . ' SET weight=' . $weight . ' WHERE groupid=' . intval($row['groupid']);
                $db->query($sql);
            }
    
            $sql = 'UPDATE ' . $table_name . ' SET weight=' . $new_vid . ' WHERE groupid=' . $groupid;
            $db->query($sql);
            $nv_Cache->delMod($module_name);
            nv_fix_cat_order();
            nv_jsonOutput([
                'status' => 'success',
                'message' => $nv_Lang->getModule('success_cat_update')
            ]);
        } elseif ($mod == 'inhome' and ($new_vid == 0 or $new_vid == 1)) {
            $sql = 'UPDATE ' . $table_name . ' SET inhome=' . $new_vid . ' WHERE groupid=' . $groupid;
            $db->query($sql);
            $nv_Cache->delMod($module_name);
            nv_jsonOutput([
                'status' => 'success',
                'message' => $nv_Lang->getModule('success_cat_update')
            ]);
        } elseif ($mod == 'indetail' and $new_vid >= 0 and $new_vid <= 10) {
            $sql = 'UPDATE ' . $table_name . ' SET indetail=' . $new_vid . ' WHERE groupid=' . $groupid;
            $db->query($sql);
            $nv_Cache->delMod($module_name);
            nv_jsonOutput([
                'status' => 'success',
                'message' => $nv_Lang->getModule('success_cat_update')
            ]);
        } elseif ($mod == 'viewgroup' and $new_vid >= 0) {
            $viewcat = $nv_Request->get_title('newvid', 'post','');
    
            $array_viewcat = ($numsubcat > 0) ? $array_viewcat_full : $array_viewcat_nosub;
            if (!array_key_exists($viewcat, $array_viewcat)) {
                $viewcat = 'viewgroup_page_new';
            }
    
            $sql = 'UPDATE ' . $table_name . ' SET viewgroup=' . $db->quote($viewcat) . ' WHERE groupid=' . $groupid;
            $db->query($sql);
            $nv_Cache->delMod($module_name);
            nv_jsonOutput([
                'status' => 'success',
                'message' => $nv_Lang->getModule('success_cat_update')
            ]);
        } elseif ($mod == 'in_order' and $new_vid >= 0) {
            $sql = 'UPDATE ' . $table_name . ' SET in_order=' . $new_vid . ' WHERE groupid=' . $groupid;
            $db->query($sql);
            $nv_Cache->delMod($module_name);
            nv_jsonOutput([
                'status' => 'success',
                'message' => $nv_Lang->getModule('success_cat_update')
            ]);
        }
    } catch (PDOException $e) {
        pr($e);
        trigger_error($e->getMessage());
    }
}


if ($nv_Request->isset_request('delete_group', 'post,get')) {
    $groupid = $nv_Request->get_int('groupid', 'post,get', 0);
    $action = $nv_Request->get_int('action', 'post', 0);
    $groupidnews = $nv_Request->get_int('groupidnews', 'post', 0);

    if (empty($groupid)) {
        nv_jsonOutput([
            'error' => 1,
            'msg' => $nv_Lang->getModule('error_group_not_exist')
        ]);
    }

    list($groupid, $parentid, $title) = $db->query('SELECT groupid, parentid, ' . NV_LANG_DATA . '_title FROM ' . $table_name . ' WHERE groupid=' . $groupid)->fetch(3);

    // Kiểm tra có nhóm con
    $check_subgroups = $db->query('SELECT COUNT(*) FROM ' . $table_name . ' WHERE parentid=' . $groupid)->fetchColumn();
    if ($check_subgroups > 0) {
        nv_jsonOutput([
            'error' => 1,
            'msg' => sprintf($nv_Lang->getModule('delgroup_msg_group'), $check_subgroups)
        ]);
    }

    // Kiểm tra có sản phẩm trong nhóm
    $check_items = $db->query('SELECT COUNT(*) FROM ' . $db_config['prefix'] . '_' . $module_data . '_group_items WHERE group_id=' . $groupid)->fetchColumn();

    if ($check_items > 0) {
        if (empty($action)) {
            // Trả về thông tin có sản phẩm để hiển thị confirm
            $sql = 'SELECT groupid, ' . NV_LANG_DATA . '_title title FROM ' . $table_name . ' WHERE groupid !=' . $groupid . ' ORDER BY weight ASC';
            $result = $db->query($sql);
            $array_groups = [];
            while ($row = $result->fetch()) {
                $array_groups[] = $row;
            }

            nv_jsonOutput([
                'error' => 2, // Có sản phẩm
                'msg' => sprintf($nv_Lang->getModule('delgroup_msg_rows'), $check_items),
                'title' => $title,
                'groups' => $array_groups
            ]);
        }

        if ($action == 1 && $groupidnews > 0) {
            // Di chuyển sản phẩm sang nhóm khác
            $result = $db->query('SELECT pro_id FROM ' . $db_config['prefix'] . '_' . $module_data . '_group_items WHERE group_id=' . $groupid);
            while ($row = $result->fetch()) {
                $count = $db->query('SELECT COUNT(*) FROM ' . $db_config['prefix'] . '_' . $module_data . '_group_items WHERE group_id=' . $groupidnews . ' AND pro_id=' . $row['pro_id'])->fetchColumn();
                if ($count == 0) {
                    $stmt = $db->prepare('UPDATE ' . $db_config['prefix'] . '_' . $module_data . '_group_items SET group_id=:group_id WHERE pro_id=' . $row['pro_id'] . ' AND group_id=' . $groupid);
                    $stmt->bindParam(':group_id', $groupidnews, PDO::PARAM_STR);
                    $stmt->execute();
                } else {
                    $db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_group_items WHERE pro_id=' . $row['pro_id'] . ' AND group_id=' . $groupid);
                }
            }
        } elseif ($action == 2) {
            // Xóa sản phẩm
            $result = $db->query('SELECT pro_id FROM ' . $db_config['prefix'] . '_' . $module_data . '_group_items WHERE group_id=' . $groupid);
            while ($row = $result->fetch()) {
                nv_del_content_module($row['pro_id']);
            }
        }
    }

    // Xóa nhóm
    $db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_group_items WHERE group_id=' . $groupid);
    $db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_group WHERE groupid=' . $groupid);
    $db->query('DELETE FROM ' . $db_config['prefix'] . '_' . $module_data . '_group_cateid WHERE groupid=' . $groupid);

    nv_fix_group_order();
    $nv_Cache->delMod($module_name);

    nv_insert_logs(NV_LANG_DATA, $module_name, 'log_del_group', 'ID ' . $groupid, $admin_info['userid']);

    nv_jsonOutput([
        'error' => 0,
        'msg' => $nv_Lang->getModule('success_group_delete'),
        'parentid' => $parentid
    ]);
}

$savegroup = $nv_Request->get_int('savegroup', 'post', 0);
if (!empty($savegroup)) {
    $field_lang = nv_file_table($table_name);

    $data['groupid'] = $nv_Request->get_int('groupid', 'post', 0);
    $data['parentid_old'] = $nv_Request->get_int('parentid_old', 'post', 0);
    $data['parentid'] = $nv_Request->get_int('parentid', 'post', 0);
    $data['cateid'] = $nv_Request->get_array('cateid', 'post', []);
    $data['title'] = nv_substr($nv_Request->get_title('title', 'post', '', 1), 0, 250);
    $data['require'] = $nv_Request->get_int('require', 'post');
    $data['keywords'] = $nv_Request->get_title('keywords', 'post', '', 1);
    $data['alias'] = nv_substr($nv_Request->get_title('alias', 'post', '', 1), 0, 250);
    $data['description'] = $nv_Request->get_string('description', 'post', '');
    $data['description'] = nv_nl2br(nv_htmlspecialchars(strip_tags($data['description'])), '<br />');
    $data['alias'] = ($data['alias'] == '') ? change_alias($data['title']) : change_alias($data['alias']);
    $image = $nv_Request->get_string('image', 'post', '');
    if (is_file(NV_DOCUMENT_ROOT . $image)) {
        $lu = strlen(NV_BASE_SITEURL . NV_UPLOADS_DIR . '/' . $module_upload . '/');
        $data['image'] = substr($image, $lu);
    } else {
        $data['image'] = '';
    }

    if ($data['title'] == '') {
        $error = $nv_Lang->getModule('group_name_empty');
    } elseif (sizeof($data['cateid']) == 0 and empty($data['parentid'])) {
        $error = $nv_Lang->getModule('group_cateid_empty');
    }

    $stmt = $db->prepare('SELECT COUNT(*) FROM ' . $table_name . ' WHERE groupid!=' . $data['groupid'] . ' AND ' . NV_LANG_DATA . '_alias= :alias');

    $stmt->bindParam(':alias', $data['alias'], PDO::PARAM_STR);
    $stmt->execute();
    $check_alias = $stmt->fetchColumn();
    if ($check_alias and $data['parentid'] > 0) {
        $parentid_alias = $db->query('SELECT ' . NV_LANG_DATA . '_alias FROM ' . $table_name . ' WHERE groupid=' . $data['parentid'])->fetchColumn();
        $data['alias'] = $parentid_alias . '-' . $data['alias'];
    }

    if ($data['groupid'] == 0 and $data['title'] != '' and $error == '') {
        $listfield = '';
        $listvalue = '';
        foreach ($field_lang as $field_lang_i) {
            list($flang, $fname) = $field_lang_i;
            $listfield .= ', ' . $flang . '_' . $fname;
            if ($flang == NV_LANG_DATA) {
                $listvalue .= ', ' . $db->quote($data[$fname]);
            } else {
                $listvalue .= ', ' . $db->quote($data[$fname]);
            }
        }

        $_sql = 'SELECT max(weight) FROM ' . $table_name . ' WHERE parentid=' . $data['parentid'];
        $weight = $db->query($_sql)->fetchColumn();
        $weight = intval($weight) + 1;

        $viewgroup = 'viewgrid';
        $subgroupid = '';

        $sql = "INSERT INTO " . $table_name . " (parentid, image,  weight, sort, lev, viewgroup, numsubgroup, subgroupid, inhome, indetail, add_time, edit_time, numpro, in_order, is_require " . $listfield . " )
             VALUES (" . $data['parentid'] . ", :image ," . (int)$weight . ", '0', '0', :viewgroup, '0', :subgroupid, '1', '0',  " . NV_CURRENTTIME . ", " . NV_CURRENTTIME . ",'0', 1, " . $data['require'] . " " . $listvalue . " )";

        $data_insert = [];
        $data_insert['viewgroup'] = $viewgroup;
        $data_insert['subgroupid'] = $subgroupid;
        $data_insert['image'] = $data['image'];
        $newgroupid = intval($db->insert_id($sql, 'groupid', $data_insert));

        if ($newgroupid > 0) {
            // Cap nhat cateid
            foreach ($data['cateid'] as $cateid) {
                $db->query('INSERT INTO ' . $table_name . '_cateid (groupid, cateid) VALUES (' . $newgroupid .', ' . $cateid . ')');
            }

            nv_insert_logs(NV_LANG_DATA, $module_name, 'log_add_group', 'id ' . $newgroupid, $admin_info['userid']);
            nv_fix_group_order();
            $nv_Cache->delMod($module_name);
            nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op . '&parentid=' . $data['parentid']);
        } else {
            $error = $nv_Lang->getModule('errorsave');
        }
    } elseif ($data['groupid'] > 0 and $data['title'] != '' and $error == '') {
        try {
            $stmt = $db->prepare('UPDATE ' . $table_name . ' SET parentid=' . $data['parentid'] . ', image = :image, ' . NV_LANG_DATA . '_title= :title, ' . NV_LANG_DATA . '_alias = :alias, ' . NV_LANG_DATA . '_description= :description, ' . NV_LANG_DATA . '_keywords= :keywords, edit_time=' . NV_CURRENTTIME . ', is_require = ' . $data['require'] . ' WHERE groupid =' . $data['groupid']);
            $stmt->bindParam(':image', $data['image'], PDO::PARAM_STR);
            $stmt->bindParam(':title', $data['title'], PDO::PARAM_STR);
            $stmt->bindParam(':alias', $data['alias'], PDO::PARAM_STR);
            $stmt->bindParam(':description', $data['description'], PDO::PARAM_STR);
            $stmt->bindParam(':keywords', $data['keywords'], PDO::PARAM_STR);
            if ($stmt->execute()) {
                // Cap nhat cateid
                $data['cateid'] = array_map('intval', $data['cateid']);
                if ($data['cateid'] != $data['cateid_old']||$data['cateid_old']=='') {
                    foreach ($data['cateid'] as $cateid) {
                        if (!in_array($cateid, $data['cateid_old'])) {
                            $db->query('INSERT INTO ' . $table_name . '_cateid (groupid, cateid) VALUES (' . $data['groupid'] .', ' . $cateid . ')');
                        }
                    }

                    foreach ($data['cateid_old'] as $cateid_old) {
                        if (!in_array($cateid_old, $data['cateid'])) {
                            $db->query('DELETE FROM ' . $table_name . '_cateid WHERE cateid = ' . $cateid_old.' AND groupid='.$data['groupid']);
                        }
                    }
                }

                nv_insert_logs(NV_LANG_DATA, $module_name, $nv_Lang->getModule('edit_group'), $data['title'], $admin_info['userid']);
                if ($data['parentid'] != $data['parentid_old']) {
                    $stmt = $db->prepare('SELECT max(weight) FROM ' . $table_name . ' WHERE parentid= :parentid');
                    $stmt->bindParam(':parentid', $data['parentid'], PDO::PARAM_INT);
                    $stmt->execute();
                    $weight = $stmt->fetchColumn();
                    $weight = intval($weight) + 1;
                    $sql = 'UPDATE ' . $table_name . ' SET weight=' . $weight . ' WHERE groupid=' . intval($data['groupid']);
                    $db->query($sql);
                    nv_fix_group_order();
                }

                $nv_Cache->delMod($module_name);

                nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op . '&parentid=' . $data['parentid']);
            }
        } catch (PDOException $e) {
            $error = $nv_Lang->getModule('errorsave');
        }
    }
}

$sql = "SELECT groupid, " . NV_LANG_DATA . "_title, lev FROM " . $table_name . " WHERE groupid !='" . $data['groupid'] . "' ORDER BY sort ASC";
$result = $db->query($sql);
$array_group_list = [];
$array_group_list[0] = array( '0', $nv_Lang->getModule('group_sub_sl') );

while (list($groupid_i, $title_i, $lev_i) = $result->fetch(3)) {
    if ($lev_i == 0) {
        $array_group_list[] = array( $groupid_i, $title_i );
    }
}

$nv_Lang->setGlobal('title_suggest_max', sprintf($nv_Lang->getGlobal('length_suggest_max'), 65));
$nv_Lang->setGlobal('description_suggest_max', sprintf($nv_Lang->getGlobal('length_suggest_max'), 160));

if (!empty($data['image']) and file_exists(NV_UPLOADS_REAL_DIR . '/' . $module_upload . '/' . $data['image'])) {
    $data['image'] = NV_BASE_SITEURL . NV_UPLOADS_DIR . '/' . $module_upload . '/' . $data['image'];
    $currentpath = dirname($data['image']);
}
$data['description'] = nv_br2nl($data['description']);

$template = get_tpl_dir([$global_config['module_theme'], $global_config['admin_theme']], 'admin_future', '/modules/' . $module_file . '/content.tpl');
$tpl = new \NukeViet\Template\NVSmarty();
$tpl->setTemplateDir(NV_ROOTDIR . '/themes/' . $template . '/modules/' . $module_file);

$tpl->assign('LANG', $nv_Lang);
$tpl->assign('CAPTION', $caption);
$tpl->assign('DATA', $data);
$tpl->assign('URL', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=getcatalog&pid=' . $data['parentid'] . '&cid=' . nv_base64_encode(serialize($data['cateid_old'])));
$tpl->assign('GROUP_LIST', shops_show_group_list($data['parentid']));
$tpl->assign('UPLOAD_CURRENT', $currentpath);
$tpl->assign('FORM_ACTION', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op . '&amp;groupid=' . $data['groupid'] . '&amp;parentid=' . $data['parentid']);
$tpl->assign('ALIAS_URL', NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=alias&title=');

if ($error != '') {
    $tpl->assign('error', $error);
}

$array_parent_loop = [];
foreach ($array_group_list as $rows_i) {
    $array_parent_loop[] = array(
        'pgroup_i' => $rows_i[0],
        'ptitle_i' => $rows_i[1],
        'pselect' => ($rows_i[0] == $data['parentid']) ? ' selected="selected"' : ''
    );
}
$tpl->assign('parent_loop', $array_parent_loop);

$tpl->assign('getalias', empty($data['alias']));

$tpl->assign('main', true);
$contents = $tpl->fetch('group_add.tpl');

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
