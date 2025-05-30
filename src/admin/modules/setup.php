<?php

/**
 * NukeViet Content Management System
 * @version 5.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2025 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_IS_FILE_MODULES')) {
    exit('Stop!!!');
}

$array_site_cat_module = [];
if ($global_config['idsite']) {
    $_module = $db->query('SELECT module FROM ' . $db_config['dbsystem'] . '.' . $db_config['prefix'] . '_site_cat t1 INNER JOIN ' . $db_config['dbsystem'] . '.' . $db_config['prefix'] . '_site t2 ON t1.cid=t2.cid WHERE t2.idsite=' . $global_config['idsite'])->fetchColumn();
    if (!empty($_module)) {
        $array_site_cat_module = explode(',', $_module);
    }
}

$contents = '';

// Thiet lap module moi
$setmodule = $nv_Request->get_title('setmodule', 'get', '', 1);
$autosetup = $nv_Request->get_title('autosetup', 'get', '', 1);

if (!empty($setmodule) and preg_match($global_config['check_module'], $setmodule)) {
    if ($nv_Request->get_title('checkss', 'get') == md5('setmodule' . $setmodule . NV_CHECK_SESSION)) {
        $sample = $nv_Request->get_int('sample', 'get', 0);
        $hook_files = $nv_Request->get_title('hook_files', 'get', '');
        $hook_mods = $nv_Request->get_title('hook_mods', 'get', '');
        $hook_files = explode('|', $hook_files);
        $hook_mods = explode('|', $hook_mods);

        $hook_data = [];
        foreach ($hook_files as $fkey => $file) {
            if (!empty($hook_mods[$fkey]) and !isset($sys_mods[$hook_mods[$fkey]])) {
                nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op);
            }
            $hook_data[$file] = $hook_mods[$fkey];
        }

        $sth = $db->prepare('SELECT basename, table_prefix FROM ' . $db_config['prefix'] . '_setup_extensions WHERE title=:title AND type=\'module\'');
        $sth->bindParam(':title', $setmodule, PDO::PARAM_STR);
        $sth->execute();
        $modrow = $sth->fetch();

        if (!empty($modrow)) {
            if (!empty($array_site_cat_module) and !in_array($modrow['basename'], $array_site_cat_module, true)) {
                nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op);
            }

            // Kiểm tra các module liên quan nếu module này có hook
            $array_hooks = [];
            if (is_dir(NV_ROOTDIR . '/modules/' . $modrow['basename'] . '/hooks')) {
                $hooks = nv_scandir(NV_ROOTDIR . '/modules/' . $modrow['basename'] . '/hooks', '/^[a-zA-Z0-9\_]+\.php$/');
                if (!empty($hooks)) {
                    foreach ($hooks as $hook) {
                        $plugin_area = nv_get_plugin_area(NV_ROOTDIR . '/modules/' . $modrow['basename'] . '/hooks/' . $hook);
                        if (count($plugin_area) == 1) {
                            $require_module = nv_get_hook_require(NV_ROOTDIR . '/modules/' . $modrow['basename'] . '/hooks/' . $hook);
                            if (!isset($hook_data[$hook]) or (!empty($require_module) and (!isset($sys_mods[$hook_data[$hook]]) or $sys_mods[$hook_data[$hook]]['module_file'] != $require_module))) {
                                nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op);
                            }
                            $array_hooks[] = [
                                'plugin_file' => $hook,
                                'plugin_area' => $plugin_area[0],
                                'hook_module' => $hook_data[$hook]
                            ];
                        }
                    }
                }
            }

            $weight = $db->query('SELECT MAX(weight) FROM ' . NV_MODULES_TABLE)->fetchColumn();
            $weight = (int) $weight + 1;

            $module_version = [];
            $custom_title = preg_replace('/(\W+)/i', ' ', $setmodule);
            $version_file = NV_ROOTDIR . '/modules/' . $modrow['basename'] . '/version.php';

            if (file_exists($version_file)) {
                include $version_file;
                if ($setmodule == $modrow['basename'] and isset($module_version['name'])) {
                    $custom_title = $module_version['name'];
                }
            }

            $_admin_file = (file_exists(NV_ROOTDIR . '/modules/' . $modrow['basename'] . '/admin.functions.php') and file_exists(NV_ROOTDIR . '/modules/' . $modrow['basename'] . '/admin/main.php')) ? 1 : 0;
            $_main_file = (file_exists(NV_ROOTDIR . '/modules/' . $modrow['basename'] . '/functions.php') and file_exists(NV_ROOTDIR . '/modules/' . $modrow['basename'] . '/funcs/main.php')) ? 1 : 0;
            $_module_data = (strlen($modrow['table_prefix']) > 30) ? trim(substr($modrow['table_prefix'], 0, 20), '_') . '_' . NV_CURRENTTIME : $modrow['table_prefix'];

            try {
                $sth = $db->prepare('INSERT INTO ' . NV_MODULES_TABLE . " (
                    title, module_file, module_data, module_upload, module_theme, custom_title, admin_title,
                    set_time, main_file, admin_file, theme, mobile, description, keywords, groups_view, weight,
                    act, admins, rss, sitemap, icon
                ) VALUES (
                    :title, :module_file, :module_data, :module_upload, :module_theme, :custom_title, '',
                    " . NV_CURRENTTIME . ', ' . $_main_file . ', ' . $_admin_file . ", '', '', '', '', '6',
                    " . $weight . ", 0, '', 1, 1, :icon
                )");

                $sth->bindParam(':title', $setmodule, PDO::PARAM_STR);
                $sth->bindParam(':module_file', $modrow['basename'], PDO::PARAM_STR);
                $sth->bindParam(':module_data', $_module_data, PDO::PARAM_STR);
                $sth->bindParam(':module_upload', $setmodule, PDO::PARAM_STR);
                $sth->bindParam(':module_theme', $modrow['basename'], PDO::PARAM_STR);
                $sth->bindParam(':custom_title', $custom_title, PDO::PARAM_STR);
                $sth->bindValue(':icon', $module_version['icon'] ?? '', PDO::PARAM_STR);
                $sth->execute();
            } catch (PDOException $e) {
                trigger_error($e->getMessage());
            }

            $nv_Cache->delMod('modules');
            if (!defined('NV_MODULE_ADD')) {
                define('NV_MODULE_ADD', true);
            }
            $return = nv_setup_data_module(NV_LANG_DATA, $setmodule, $sample);
            if ($return['success']) {
                nv_setup_block_module($setmodule);

                $sth = $db->prepare('UPDATE ' . NV_MODULES_TABLE . ' SET act=1 WHERE title=:title');
                $sth->bindParam(':title', $setmodule, PDO::PARAM_STR);
                $sth->execute();

                // Cài đặt hook
                $email_pids = [];
                if (!empty($array_hooks)) {
                    foreach ($array_hooks as $hook) {
                        try {
                            // Lấy vị trí mới
                            $_sql = 'SELECT max(weight) FROM ' . $db_config['prefix'] . '_plugins WHERE plugin_lang=' . $db->quote(NV_LANG_DATA) . ' AND plugin_area=' . $db->quote($hook['plugin_area']) . ' AND hook_module=' . $db->quote($hook['hook_module']);
                            $weight = $db->query($_sql)->fetchColumn();
                            $weight = (int) $weight + 1;

                            $db->query('INSERT INTO ' . $db_config['prefix'] . '_plugins (
                                plugin_lang, plugin_file, plugin_area, plugin_module_name, plugin_module_file, hook_module, weight
                            ) VALUES (
                                ' . $db->quote(NV_LANG_DATA) . ',
                                ' . $db->quote($hook['plugin_file']) . ',
                                ' . $db->quote($hook['plugin_area']) . ',
                                ' . $db->quote($setmodule) . ',
                                ' . $db->quote($modrow['basename']) . ',
                                ' . $db->quote($hook['hook_module']) . ',
                                ' . $weight . '
                            )');
                            $pid = $db->lastInsertId();

                            if ($hook['plugin_area'] == 'get_email_merge_fields') {
                                $email_pids[$hook['plugin_file']] = $pid;
                            }
                        } catch (PDOException $e) {
                            trigger_error(print_r($e, true));
                        }
                    }
                    nv_save_file_config_global();
                }

                // Kết nối hook và các mẫu email nếu có
                if (!empty($email_pids) and !empty($return['emails'])) {
                    foreach ($return['emails'] as $emailid => $pfiles) {
                        $pids = array_intersect_key($email_pids, array_flip($pfiles));
                        if (empty($pids)) {
                            continue;
                        }
                        $pids = implode(',', $pids);
                        $sql = "UPDATE " . NV_EMAILTEMPLATES_GLOBALTABLE . " SET sys_pids=" . $db->quote($pids). " WHERE emailid=" . $emailid;
                        $db->query($sql);
                    }
                }

                // Tự động thêm rule chặn vào file robots.txt
                nv_update_robots(false, true);

                nv_insert_logs(NV_LANG_DATA, $module_name, $nv_Lang->getModule('modules') . ' ' . $setmodule, '', $admin_info['userid']);
                nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=edit&mod=' . $setmodule);
            }
        }
    }

    nv_redirect_location(NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $op);
}

$page_title = $nv_Lang->getModule('modules');
$modules_exit = array_flip(nv_scandir(NV_ROOTDIR . '/modules', $global_config['check_module']));
$modules_data = [];

$is_delCache = false;

$sql_data = 'SELECT * FROM ' . $db_config['prefix'] . '_setup_extensions WHERE type=\'module\' ORDER BY addtime ASC';
$result = $db->query($sql_data);

while ($row = $result->fetch()) {
    if (array_key_exists($row['basename'], $modules_exit)) {
        $modules_data[$row['title']] = $row;
    } else {
        $sth = $db->prepare('DELETE FROM ' . $db_config['prefix'] . '_setup_extensions WHERE title= :title AND type=\'module\'');
        $sth->bindParam(':title', $row['title'], PDO::PARAM_STR);
        $sth->execute();

        $sth = $db->prepare('UPDATE ' . NV_MODULES_TABLE . ' SET act=2 WHERE title=:title');
        $sth->bindParam(':title', $row['title'], PDO::PARAM_STR);
        $sth->execute();

        $is_delCache = true;
    }
}

if ($is_delCache) {
    $nv_Cache->delMod('modules');
}

$check_addnews_modules = false;
$arr_module_news = array_diff_key($modules_exit, $modules_data);

foreach ($arr_module_news as $module_name_i => $arr) {
    $check_file_main = NV_ROOTDIR . '/modules/' . $module_name_i . '/funcs/main.php';
    $check_file_functions = NV_ROOTDIR . '/modules/' . $module_name_i . '/functions.php';

    $check_admin_main = NV_ROOTDIR . '/modules/' . $module_name_i . '/admin/main.php';
    $check_admin_functions = NV_ROOTDIR . '/modules/' . $module_name_i . '/admin.functions.php';

    if ((file_exists($check_file_main) and filesize($check_file_main) != 0 and file_exists($check_file_functions) and filesize($check_file_functions) != 0) or (file_exists($check_admin_main) and filesize($check_admin_main) != 0 and file_exists($check_admin_functions) and filesize($check_admin_functions) != 0)) {
        $check_addnews_modules = true;

        $module_version = [];
        $version_file = NV_ROOTDIR . '/modules/' . $module_name_i . '/version.php';

        if (file_exists($version_file)) {
            require_once $version_file;
        }

        if (empty($module_version)) {
            $timestamp = NV_CURRENTTIME - date('Z', NV_CURRENTTIME);
            $module_version = [
                'name' => $module_name_i,
                'modfuncs' => 'main',
                'is_sysmod' => 0,
                'virtual' => 0,
                'version' => $global_config['version'],
                'date' => date('D, j M Y H:i:s', $timestamp) . ' GMT',
                'author' => '',
                'note' => ''
            ];
        }

        $date_ver = (int) (strtotime($module_version['date']));

        if ($date_ver == 0) {
            $date_ver = NV_CURRENTTIME;
        }

        $version = $module_version['version'] . ' ' . $date_ver;
        $note = $module_version['note'];
        $author = $module_version['author'];
        $module_data = preg_replace('/(\W+)/i', '_', $module_name_i);

        // Chỉ cho phép ảo hóa module khi virtual = 1, Khi virtual = 2, chỉ đổi được tên các func
        $module_version['virtual'] = ($module_version['virtual'] == 1) ? 1 : 0;

        $sth = $db->prepare('INSERT INTO ' . $db_config['prefix'] . '_setup_extensions (type, title, is_sys, is_virtual, basename, table_prefix, version, addtime, author, note) VALUES (
            \'module\', :title, ' . (int) ($module_version['is_sysmod']) . ', ' . (int) ($module_version['virtual']) . ', :basename, :table_prefix, :version, ' . NV_CURRENTTIME . ', :author, :note)');

        $sth->bindParam(':title', $module_name_i, PDO::PARAM_STR);
        $sth->bindParam(':basename', $module_name_i, PDO::PARAM_STR);
        $sth->bindParam(':table_prefix', $module_data, PDO::PARAM_STR);
        $sth->bindParam(':version', $version, PDO::PARAM_STR);
        $sth->bindParam(':author', $author, PDO::PARAM_STR);
        $sth->bindParam(':note', $note, PDO::PARAM_STR);
        $sth->execute();
    }
}

if ($check_addnews_modules) {
    $result = $db->query($sql_data);
    while ($row = $result->fetch()) {
        $modules_data[$row['title']] = $row;
    }
}

// Lay danh sach cac module co trong ngon ngu
$modules_for_title = [];
$modules_for_file = [];

$result = $db->query('SELECT * FROM ' . NV_MODULES_TABLE . ' ORDER BY weight ASC');
while ($row = $result->fetch()) {
    $modules_for_title[$row['title']] = $row;
    if ($row['title'] == $row['module_file']) {
        $modules_for_file[$row['module_file']] = $row;
    }
}

// Kiem tra module moi
$news_modules_for_file = array_diff_key($modules_data, $modules_for_file);
$array_modules = $array_virtual_modules = $mod_virtual = [];

foreach ($modules_data as $row) {
    if (array_key_exists($row['basename'], $modules_exit)) {
        if (!empty($array_site_cat_module) and !in_array($row['basename'], $array_site_cat_module, true)) {
            continue;
        }

        if (array_key_exists($row['title'], $news_modules_for_file)) {
            $mod = [];
            $mod['title'] = $row['title'];
            $mod['is_sys'] = $row['is_sys'];
            $mod['virtual'] = $row['is_virtual'];
            $mod['module_file'] = $row['basename'];
            $mod['version'] = preg_replace_callback('/^([0-9a-zA-Z]+\.[0-9a-zA-Z]+\.[0-9a-zA-Z]+)\s+(\d+)$/', 'nv_parse_vers', $row['version']);
            $mod['addtime'] = nv_datetime_format($row['addtime'], 1);
            $mod['author'] = nv_htmlspecialchars($row['author']);
            $mod['note'] = $row['note'];
            $mod['url_setup'] = array_key_exists($row['title'], $modules_for_title) ? '' : NV_BASE_ADMINURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $op . '&amp;setmodule=' . $row['title'] . '&amp;checkss=' . md5('setmodule' . $row['title'] . NV_CHECK_SESSION);

            if ($mod['module_file'] == $mod['title']) {
                $array_modules[] = $mod;

                if ($row['is_virtual']) {
                    $mod_virtual[] = $mod['title'];
                }
            } else {
                $array_virtual_modules[] = $mod;
            }
        }
    }
}
if (!empty($autosetup) and !array_key_exists($autosetup, $modules_exit) and !array_key_exists($autosetup, $news_modules_for_file)) {
    $autosetup = '';
}

$tpl = new \NukeViet\Template\NVSmarty();
$tpl->setTemplateDir(get_module_tpl_dir('setup.tpl'));
$tpl->assign('LANG', $nv_Lang);
$tpl->assign('MODULE_NAME', $module_name);
$tpl->assign('OP', $op);

$tpl->assign('AUTOSETUP', $autosetup);
$tpl->assign('MODULES', $array_modules);
$tpl->assign('VMODULES', $array_virtual_modules);

$contents = $tpl->fetch('setup.tpl');

include NV_ROOTDIR . '/includes/header.php';
echo nv_admin_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
