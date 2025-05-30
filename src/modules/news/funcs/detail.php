<?php

/**
 * NukeViet Content Management System
 * @version 5.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2025 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_IS_MOD_NEWS')) {
    exit('Stop!!!');
}

$contents = '';
$publtime = 0;

if (empty($module_config[$module_name]['identify_cat_change'])) {
    // Không hỗ trợ đổi chuyên mục lấy thẳng bảng cat sẽ nhanh hơn
    $query = $db_slave->query('SELECT * FROM ' . NV_PREFIXLANG . '_' . $module_data . '_' . $catid . ' WHERE id = ' . $id);
} else {
    // Hỗ trợ đổi chuyên mục => Lấy bảng rows để xác định catid mới
    $query = $db_slave->query('SELECT * FROM ' . NV_PREFIXLANG . '_' . $module_data . '_rows WHERE id = ' . $id);
}
$news_contents = $query->fetch();

if (empty($news_contents)) {
    $redirect = '<meta http-equiv="Refresh" content="3;URL=' . nv_url_rewrite(NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name, true) . '" />';
    nv_info_die($nv_Lang->getGlobal('error_404_title'), $nv_Lang->getGlobal('error_404_title'), $nv_Lang->getGlobal('error_404_content') . $redirect, 404);
}

$body_contents = $db_slave->query('SELECT
    titlesite, description, bodyhtml, voicedata, keywords, sourcetext, files, layout_func, imgposition,
    copyright, allowed_send, allowed_print, allowed_save, auto_nav,
    group_view, localization, related_ids, related_pos, schema_type
FROM ' . NV_PREFIXLANG . '_' . $module_data . '_detail where id=' . $news_contents['id'])->fetch();
$news_contents = array_merge($news_contents, $body_contents);
unset($body_contents);

$localversions = !empty($news_contents['localization']) ? json_decode($news_contents['localization'], true) : [];

$news_contents['files'] = empty($news_contents['files']) ? [] : explode(',', $news_contents['files']);

// Tải về đính kèm
if ($nv_Request->isset_request('download', 'get')) {
    $fileid = $nv_Request->get_int('id', 'get', 0);
    if (!isset($news_contents['files'][$fileid])) {
        nv_redirect_location(NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name, true);
    }

    if (!file_exists(NV_UPLOADS_REAL_DIR . '/' . $module_upload . '/' . $news_contents['files'][$fileid])) {
        nv_redirect_location(NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name, true);
    }

    $file_info = pathinfo(NV_UPLOADS_REAL_DIR . '/' . $module_upload . '/' . $news_contents['files'][$fileid]);
    $download = new NukeViet\Files\Download(NV_UPLOADS_REAL_DIR . '/' . $module_upload . '/' . $news_contents['files'][$fileid], $file_info['dirname'], $file_info['basename'], true);
    $download->download_file();
    exit();
}

// Xem đính kèm dạng PDF
if ($nv_Request->isset_request('pdf', 'get')) {
    $fileid = $nv_Request->get_int('id', 'get', 0);
    if (!isset($news_contents['files'][$fileid])) {
        nv_error404();
    }

    if (!file_exists(NV_UPLOADS_REAL_DIR . '/' . $module_upload . '/' . $news_contents['files'][$fileid])) {
        nv_error404();
    }

    $file_url = nv_url_rewrite(NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&' . NV_NAME_VARIABLE . '=' . $module_name . '&' . NV_OP_VARIABLE . '=' . $global_array_cat[$news_contents['catid']]['alias'] . '/' . $news_contents['alias'] . '-' . $news_contents['id'] . $global_config['rewrite_exturl'], true) . '?download=1&id=' . $fileid;

    $contents = nv_theme_viewpdf($file_url);
    nv_htmlOutput($contents);
}

// Kiểm tra URL, không cho đánh tùy ý phần alias
$page_url = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $global_array_cat[$news_contents['catid']]['alias'] . '/' . $news_contents['alias'] . '-' . $news_contents['id'] . $global_config['rewrite_exturl'];
$news_contents['link'] = $canonicalUrl = getCanonicalUrl($page_url, true);
if (!empty($localversions)) {
    $localversions[NV_LANG_DATA] = $canonicalUrl;
    foreach ($localversions as $l => $u) {
        $nv_html_links[] = [
            'rel' => 'alternate',
            'href' => $u,
            'hreflang' => $l
        ];
    }
}

/*
 * Không có quyền xem bài viết thì dừng
 * Lưu ý tới đây thì $catid này đã là $catid chính thức vì không chính thức thì
 * bên trên đã được chuyển hướng
 */
if (!nv_user_in_groups($global_array_cat[$catid]['groups_view'])) {
    $nv_BotManager->setPrivate();
    $contents = no_permission();

    include NV_ROOTDIR . '/includes/header.php';
    echo nv_site_theme($contents);
    include NV_ROOTDIR . '/includes/footer.php';
}

if (!empty($news_contents['group_view'])) {
    if (!nv_user_in_groups($news_contents['group_view'])) {
        $nv_BotManager->setPrivate();
        $contents = no_permission();

        include NV_ROOTDIR . '/includes/header.php';
        echo nv_site_theme($contents);
        include NV_ROOTDIR . '/includes/footer.php';
    }
}

if (!(defined('NV_IS_MODADMIN') or ($news_contents['status'] == 1 and $news_contents['publtime'] < NV_CURRENTTIME and ($news_contents['exptime'] == 0 or $news_contents['exptime'] > NV_CURRENTTIME)))) {
    $nv_BotManager->setPrivate();
    nv_error404();
}

// Cập nhật lượt xem
$time_set = $nv_Request->get_int($module_data . '_' . $op . '_' . $id, 'session');
if (empty($time_set)) {
    $nv_Request->set_Session($module_data . '_' . $op . '_' . $id, NV_CURRENTTIME);
    $query = 'UPDATE ' . NV_PREFIXLANG . '_' . $module_data . '_rows SET hitstotal=hitstotal+1 WHERE id=' . $id;
    $db->query($query);

    $array_catid = explode(',', $news_contents['listcatid']);
    foreach ($array_catid as $catid_i) {
        $query = 'UPDATE ' . NV_PREFIXLANG . '_' . $module_data . '_' . $catid_i . ' SET hitstotal=hitstotal+1 WHERE id=' . $id;
        $db->query($query);
    }
}

// Mở bài viết sang nguồn tin chính thức
if ($news_contents['external_link']) {
    nv_apply_hook($module_name, 'before_redirect_external_link', [$news_contents]);
    nv_redirect_location($news_contents['sourcetext'], 0, true);
}

$page_title = empty($news_contents['titlesite']) ? $news_contents['title'] : $news_contents['titlesite'];

$show_no_image = $module_config[$module_name]['show_no_image'];
$news_contents['showhometext'] = $module_config[$module_name]['showhometext'];
if (!empty($news_contents['homeimgfile'])) {
    $homeimgfile = $news_contents['homeimgfile'];
    $news_contents['srcset'] = '';

    $src = $alt = $note = '';
    $width = $height = 0;
    if ($news_contents['homeimgthumb'] == 1 and $news_contents['imgposition'] == 1) {
        $src = NV_BASE_SITEURL . NV_FILES_DIR . '/' . $module_upload . '/' . $homeimgfile;
        $news_contents['homeimgfile'] = NV_BASE_SITEURL . NV_UPLOADS_DIR . '/' . $module_upload . '/' . $homeimgfile;
        $width = $module_config[$module_name]['homewidth'];

        if (file_exists(NV_ROOTDIR . '/' . NV_MOBILE_FILES_DIR . '/' . $module_upload . '/' . $homeimgfile)) {
            $imagesize = @getimagesize(NV_UPLOADS_REAL_DIR . '/' . $module_upload . '/' . $homeimgfile);
            $news_contents['srcset'] = NV_BASE_SITEURL . NV_MOBILE_FILES_DIR . '/' . $module_upload . '/' . $homeimgfile . ' ' . NV_MOBILE_MODE_IMG . 'w, ';
            $news_contents['srcset'] .= $news_contents['homeimgfile'] . ' ' . $imagesize[0] . 'w';
        }
    } elseif ($news_contents['homeimgthumb'] == 3) {
        $src = $news_contents['homeimgfile'];
        $width = ($news_contents['imgposition'] == 1) ? $module_config[$module_name]['homewidth'] : $module_config[$module_name]['imagefull'];
    } elseif (file_exists(NV_UPLOADS_REAL_DIR . '/' . $module_upload . '/' . $news_contents['homeimgfile'])) {
        $src = NV_BASE_SITEURL . NV_UPLOADS_DIR . '/' . $module_upload . '/' . $news_contents['homeimgfile'];
        $imagesize = @getimagesize(NV_UPLOADS_REAL_DIR . '/' . $module_upload . '/' . $news_contents['homeimgfile']);
        if ($news_contents['imgposition'] == 1) {
            $width = $module_config[$module_name]['homewidth'];
        } else {
            if ($imagesize[0] > 0 and $imagesize[0] > $module_config[$module_name]['imagefull']) {
                $width = $module_config[$module_name]['imagefull'];
            } else {
                $width = $imagesize[0];
            }
        }
        $news_contents['homeimgfile'] = $src;

        if (file_exists(NV_ROOTDIR . '/' . NV_MOBILE_FILES_DIR . '/' . $module_upload . '/' . $homeimgfile)) {
            $news_contents['srcset'] = NV_BASE_SITEURL . NV_MOBILE_FILES_DIR . '/' . $module_upload . '/' . $homeimgfile . ' ' . NV_MOBILE_MODE_IMG . 'w, ';
            $news_contents['srcset'] .= $news_contents['homeimgfile'] . ' ' . $imagesize[0] . 'w';
        }
    }

    if (!empty($src)) {
        $meta_property['og:image'] = (preg_match('/^(http|https|ftp|gopher)\:\/\//', $news_contents['homeimgfile'])) ? $news_contents['homeimgfile'] : NV_MY_DOMAIN . $news_contents['homeimgfile'];
        if ($news_contents['imgposition'] > 0) {
            $news_contents['image'] = [
                'src' => $src,
                'width' => $width,
                'alt' => (empty($news_contents['homeimgalt'])) ? $news_contents['title'] : $news_contents['homeimgalt'],
                'note' => $news_contents['homeimgalt'],
                'position' => $news_contents['imgposition']
            ];
        }
    } elseif (!empty($show_no_image)) {
        $meta_property['og:image'] = NV_MY_DOMAIN . NV_BASE_SITEURL . $show_no_image;
    }
} elseif (!empty($show_no_image)) {
    $meta_property['og:image'] = NV_MY_DOMAIN . NV_BASE_SITEURL . $show_no_image;
}

if (!empty($meta_property['og:image'])) {
    $meta_property['og:image:alt'] = !empty($news_contents['homeimgalt']) ? $news_contents['homeimgalt'] : $news_contents['title'];
}

// File download
if (!empty($news_contents['files'])) {
    $files = $news_contents['files'];
    $news_contents['files'] = [];

    foreach ($files as $file_id => $file) {
        $is_localfile = (!nv_is_url($file));
        $path_parts = pathinfo(strtolower($file));
        $file_title = $is_localfile ? $path_parts['basename'] : $nv_Lang->getModule('click_to_download');
        $news_contents['files'][$file_id] = [
            'is_localfile' => $is_localfile,
            'title' => $file_title,
            'key' => md5($file_id . $file_title),
            'ext' => !empty($path_parts['extension']) ? $path_parts['extension'] : '',
            'filename' => $path_parts['filename'],
            'titledown' => $nv_Lang->getModule('download') . ' ' . (count($files) > 1 ? $file_id + 1 : ''),
            'src' => NV_BASE_SITEURL . NV_UPLOADS_DIR . '/' . $module_upload . '/' . $file,
            'url' => $is_localfile ? ($page_url . '&amp;download=1&amp;id=' . $file_id) : $file
        ];
        if ($news_contents['files'][$file_id]['ext'] == 'pdf') {
            if ($is_localfile) {
                $news_contents['files'][$file_id]['urlfile'] = $page_url . '&amp;pdf=1&amp;id=' . $file_id;
            } else {
                $news_contents['files'][$file_id]['urlfile'] = 'https://docs.google.com/viewerng/viewer?embedded=true&url=' . urlencode($file);
            }
        } elseif (in_array($news_contents['files'][$file_id]['ext'], ['doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx'], true)) {
            if (!$is_localfile) {
                $news_contents['files'][$file_id]['urlfile'] = 'https://view.officeapps.live.com/op/embed.aspx?src=' . urlencode($file);
            } elseif (!$ips->is_localhost()) {
                $url = NV_MY_DOMAIN . '/' . NV_UPLOADS_DIR . '/' . $module_upload . '/' . $file;
                $news_contents['files'][$file_id]['urlfile'] = 'https://view.officeapps.live.com/op/embed.aspx?src=' . urlencode($url);
            }
        }
    }
}

[$post_username, $post_first_name, $post_last_name] = $db_slave->query('SELECT username, first_name, last_name FROM ' . NV_USERS_GLOBALTABLE . ' WHERE userid = ' . $news_contents['admin_id'])->fetch(3);
$news_contents['post_name'] = nv_show_name_user($post_first_name, $post_last_name, $post_username);

$publtime = (int) ($news_contents['publtime']);
$meta_property['og:type'] = 'article';
$meta_property['article:published_time'] = date('Y-m-dTH:i:s', $publtime);
$meta_property['article:modified_time'] = date('Y-m-dTH:i:s', $news_contents['edittime']);
if ($news_contents['exptime']) {
    $meta_property['article:expiration_time'] = date('Y-m-dTH:i:s', $news_contents['exptime']);
}
$meta_property['article:section'] = $global_array_cat[$news_contents['catid']]['title'];

// Dữ liệu có cấu trúc cho bài viết
$schema_supported = [
    'newsarticle' => 'NewsArticle',
    'blogposting' => 'BlogPosting',
    'article' => 'Article'
];
$schema = [
    '@context' => 'https://schema.org',
    '@type' => $schema_supported[$news_contents['schema_type']] ?? 'NewsArticle',
    'headline' => $news_contents['title'],
    'description' => strip_tags($news_contents['hometext']),
    'mainEntityOfPage' => $news_contents['link']
];
if (!empty($meta_property['og:image'])) {
    $schema['image'] = [
        '@type' => 'ImageObject',
        'url' => $meta_property['og:image']
    ];
}
if ($news_contents['schema_type'] != 'BlogPosting') {
    $schema['publisher'] = [
        '@type' => 'Organization',
        'name' => $global_config['site_name'],
    ];
    if (!empty($global_config['site_logo'])) {
        $schema['publisher']['logo'] = [
            '@type' => 'ImageObject',
            'url' => NV_MY_DOMAIN . NV_BASE_SITEURL . $global_config['site_logo']
        ];
    }
}

if (defined('NV_IS_MODADMIN') and $news_contents['status'] != 1) {
    $alert = $nv_Lang->getModule('status_alert', $nv_Lang->getModule('status_' . $news_contents['status']));
    $my_footer .= '<script' . (defined('NV_SCRIPT_NONCE') ? ' nonce="' . NV_SCRIPT_NONCE . '"' : '') . ">alert('" . $alert . "')</script>";
    $news_contents['allowed_send'] = 0;
    $module_config[$module_name]['socialbutton'] = 0;
}

$news_contents['url_sendmail'] = nv_url_rewrite(NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=sendmail/' . $global_array_cat[$catid]['alias'] . '/' . $news_contents['alias'] . '-' . $news_contents['id'] . $global_config['rewrite_exturl'], true);
$news_contents['url_print'] = nv_url_rewrite(NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=print/' . $global_array_cat[$catid]['alias'] . '/' . $news_contents['alias'] . '-' . $news_contents['id'] . $global_config['rewrite_exturl'], true);
$news_contents['url_savefile'] = nv_url_rewrite(NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=savefile/' . $global_array_cat[$catid]['alias'] . '/' . $news_contents['alias'] . '-' . $news_contents['id'] . $global_config['rewrite_exturl'], true);

$news_contents['source'] = '';
if ($news_contents['sourceid']) {
    $sql = 'SELECT title, link, logo FROM ' . NV_PREFIXLANG . '_' . $module_data . '_sources WHERE sourceid = ' . $news_contents['sourceid'];
    $result = $db_slave->query($sql);
    [$sourcetext, $source_link, $source_logo] = $result->fetch(3);
    unset($sql, $result);
    if ($module_config[$module_name]['config_source'] == 0) {
        $news_contents['source'] = $sourcetext; // Hiển thị tiêu đề nguồn tin
    } elseif ($module_config[$module_name]['config_source'] == 1) {
        $news_contents['source'] = '<a title="' . $sourcetext . '" rel="nofollow" href="' . $news_contents['sourcetext'] . '">' . $source_link . '</a>'; // Hiển thị link của nguồn tin
    } elseif ($module_config[$module_name]['config_source'] == 3) {
        $news_contents['source'] = '<a title="' . $sourcetext . '" href="' . $news_contents['sourcetext'] . '">' . $source_link . '</a>'; // Hiển thị link của nguồn tin
    } elseif ($module_config[$module_name]['config_source'] == 2 and !empty($source_logo)) {
        $news_contents['source'] = '<img width="100px" src="' . NV_BASE_SITEURL . NV_UPLOADS_DIR . '/' . $module_upload . '/source/' . $source_logo . '">';
    }
}

$authors = $schema_author = [];

// Lấy tác giả thuộc quyền quản lí
$db->sqlreset()
    ->select('l.alias,l.pseudonym')
    ->from(NV_PREFIXLANG . '_' . $module_data . '_authorlist l LEFT JOIN ' . NV_PREFIXLANG . '_' . $module_data . '_author a ON l.aid=a.id')
    ->where('l.id = ' . $id . ' AND a.active=1');
$result = $db->query($db->sql());
while ($row = $result->fetch()) {
    $url = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=author/' . $row['alias'];
    if (empty($module_config[$module_name]['hide_inauthor'])) {
        $authors[] = '<a href="' . $url . '">' . $row['pseudonym'] . '</a>';
    }
    $schema_author[] = [
        '@type' => 'Person',
        'name' => $row['pseudonym'],
        'url' => urlRewriteWithDomain($url, NV_MAIN_DOMAIN)
    ];
}

// Tác giả bên ngoài
$url_aguest = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=author/guests';
if (!empty($news_contents['author'])) {
    if (empty($module_config[$module_name]['hide_author'])) {
        $authors[] = '<a href="' . $url_aguest . '">' . $news_contents['author'] . '</a>';
    }
    $schema_author[] = [
        '@type' => 'Person',
        'name' => $news_contents['author'],
        'url' => urlRewriteWithDomain($url_aguest, NV_MAIN_DOMAIN)
    ];
}
$news_contents['author'] = !empty($authors) ? implode(', ', $authors) : '';

// Không có tác giả lấy tên người đăng
if (empty($schema_author)) {
    $schema_author[] = [
        '@type' => 'Person',
        'name' => $news_contents['post_name'] ?: 'Unknow Author',
        'url' => urlRewriteWithDomain($url_aguest, NV_MAIN_DOMAIN)
    ];
}
$schema['author'] = array_values($schema_author);
if (count($schema['author']) == 1) {
    $schema['author'] = $schema['author'][0];
}

$news_contents['number_publtime'] = $news_contents['publtime'];
$news_contents['number_edittime'] = (empty($news_contents['edittime']) or $news_contents['edittime'] < $news_contents['number_publtime']) ? $news_contents['number_publtime'] : $news_contents['edittime'];

$schema['datePublished'] = date('c', $news_contents['number_publtime']);
$schema['dateModified'] = date('c', $news_contents['number_edittime']);

$news_contents['publtime'] = nv_date_format(0, $news_contents['publtime']) . ' ' . nv_time_format(1, $news_contents['publtime']);
$news_contents['newscheckss'] = md5($news_contents['id'] . NV_CHECK_SESSION);

$related_new_array = [];
$related_array = [];
if ($st_links > 0) {
    $db_slave->sqlreset()
        ->select('id, title, alias, publtime, homeimgfile, homeimgthumb, hometext, external_link')
        ->from(NV_PREFIXLANG . '_' . $module_data . '_' . $catid)
        ->where('status=1 AND publtime > ' . $publtime)
        ->order('publtime ASC')
        ->limit($st_links);

    $related = $db_slave->query($db_slave->sql());
    while ($row = $related->fetch()) {
        $row['imghome'] = $row['imgmobile'] = '';
        get_homeimgfile($row);

        $link = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $global_array_cat[$catid]['alias'] . '/' . $row['alias'] . '-' . $row['id'] . $global_config['rewrite_exturl'];
        $related_new_array[] = [
            'title' => $row['title'],
            'time' => $row['publtime'],
            'link' => $link,
            'newday' => $global_array_cat[$catid]['newday'],
            'hometext' => $row['hometext'],
            'imghome' => $row['imghome'],
            'external_link' => $row['external_link']
        ];
    }
    $related->closeCursor();

    sort($related_new_array, SORT_NUMERIC);

    $db_slave->sqlreset()
        ->select('id, title, alias, publtime, homeimgfile, homeimgthumb, hometext, external_link')
        ->from(NV_PREFIXLANG . '_' . $module_data . '_' . $catid)
        ->where('status=1 AND publtime < ' . $publtime)
        ->order('publtime DESC')
        ->limit($st_links);

    $related = $db_slave->query($db_slave->sql());
    while ($row = $related->fetch()) {
        $row['imghome'] = $row['imgmobile'] = '';
        get_homeimgfile($row);

        $link = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $global_array_cat[$catid]['alias'] . '/' . $row['alias'] . '-' . $row['id'] . $global_config['rewrite_exturl'];
        $related_array[] = [
            'title' => $row['title'],
            'time' => $row['publtime'],
            'link' => $link,
            'newday' => $global_array_cat[$catid]['newday'],
            'hometext' => $row['hometext'],
            'imghome' => $row['imghome'],
            'external_link' => $row['external_link']
        ];
    }

    $related->closeCursor();
    unset($related, $row);
}

$topic_array = [];
if ($news_contents['topicid'] > 0 & $st_links > 0) {
    [$topic_title, $topic_alias] = $db_slave->query('SELECT title, alias FROM ' . NV_PREFIXLANG . '_' . $module_data . '_topics WHERE topicid = ' . $news_contents['topicid'])->fetch(3);

    $topiclink = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $module_info['alias']['topic'] . '/' . $topic_alias;

    $db_slave->sqlreset()
        ->select('id, catid, title, alias, publtime, homeimgfile, homeimgthumb, hometext, external_link')
        ->from(NV_PREFIXLANG . '_' . $module_data . '_rows t1')
        ->where('status=1 AND topicid = ' . $news_contents['topicid'] . ' AND id != ' . $id)
        ->order($order_articles_by . ' DESC')
        ->limit($st_links);
    $topic = $db_slave->query($db_slave->sql());
    while ($row = $topic->fetch()) {
        if ($row['homeimgthumb'] == 1) {
            // image thumb
            $row['imghome'] = NV_BASE_SITEURL . NV_FILES_DIR . '/' . $module_upload . '/' . $row['homeimgfile'];
        } elseif ($row['homeimgthumb'] == 2) {
            // image file
            $row['imghome'] = NV_BASE_SITEURL . NV_UPLOADS_DIR . '/' . $module_upload . '/' . $row['homeimgfile'];
        } elseif ($row['homeimgthumb'] == 3) {
            // image url
            $row['imghome'] = $row['homeimgfile'];
        } elseif (!empty($show_no_image)) {
            // no image
            $row['imghome'] = NV_BASE_SITEURL . $show_no_image;
        } else {
            $row['imghome'] = '';
        }

        $link = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $global_array_cat[$row['catid']]['alias'] . '/' . $row['alias'] . '-' . $row['id'] . $global_config['rewrite_exturl'];
        $topic_array[] = [
            'title' => $row['title'],
            'link' => $link,
            'time' => $row['publtime'],
            'newday' => $global_array_cat[$row['catid']]['newday'],
            'topiclink' => $topiclink,
            'topictitle' => $topic_title,
            'hometext' => $row['hometext'],
            'imghome' => $row['imghome'],
            'external_link' => $row['external_link']
        ];
    }
    $topic->closeCursor();
    unset($topic, $rows);
}

if (empty($module_config[$module_name]['allowed_rating'])) {
    $news_contents['allowed_rating'] = false;
}
if ($news_contents['allowed_rating']) {
    $time_set_rating = $nv_Request->get_int($module_name . '_' . $op . '_' . $news_contents['id'], 'cookie', 0);
    if ($time_set_rating > 0) {
        $news_contents['disablerating'] = 1;
    } else {
        $news_contents['disablerating'] = 0;
    }
    $news_contents['stringrating'] = $nv_Lang->getModule('stringrating', $news_contents['total_rating'], $news_contents['click_rating']);
    $news_contents['numberrating'] = ($news_contents['click_rating'] > 0) ? round($news_contents['total_rating'] / $news_contents['click_rating'], 1) : 0;
    $news_contents['numberrating_star'] = ($news_contents['click_rating'] > 0) ? round($news_contents['total_rating'] / $news_contents['click_rating']) : 0;
    $news_contents['stars'] = [
        [
            'val' => '1',
            'title' => $nv_Lang->getModule('star_verypoor'),
            'checked' => 1 == $news_contents['numberrating_star'] ? ' checked="checked"' : ''
        ],
        [
            'val' => '2',
            'title' => $nv_Lang->getModule('star_poor'),
            'checked' => 2 == $news_contents['numberrating_star'] ? ' checked="checked"' : ''
        ],
        [
            'val' => '3',
            'title' => $nv_Lang->getModule('star_ok'),
            'checked' => 3 == $news_contents['numberrating_star'] ? ' checked="checked"' : ''
        ],
        [
            'val' => '4',
            'title' => $nv_Lang->getModule('star_good'),
            'checked' => 4 == $news_contents['numberrating_star'] ? ' checked="checked"' : ''
        ],
        [
            'val' => '5',
            'title' => $nv_Lang->getModule('star_verygood'),
            'checked' => 5 == $news_contents['numberrating_star'] ? ' checked="checked"' : ''
        ]
    ];

    // Thêm đánh giá cho schema loại bài viết - Google đã không còn hỗ trợ
    /*
    if ($news_contents['numberrating'] >= $module_config[$module_name]['allowed_rating_point']) {
        $schema['aggregateRating'] = [
            '@type' => 'AggregateRating',
            'ratingValue' => $news_contents['numberrating'],
            'reviewCount' => $news_contents['click_rating']
        ];
    }*/
}

$array_keyword = [];
$key_words = [];
$_query = $db_slave->query('SELECT a1.keyword, a2.alias FROM ' . NV_PREFIXLANG . '_' . $module_data . '_tags_id a1 INNER JOIN ' . NV_PREFIXLANG . '_' . $module_data . '_tags a2 ON a1.tid=a2.tid WHERE a1.id=' . $news_contents['id']);
while ($row = $_query->fetch()) {
    $array_keyword[] = $row;
    $key_words[] = $row['keyword'];
    $meta_property['article:tag'][] = $row['keyword'];
}

// comment
if (isset($site_mods['comment']) and isset($module_config[$module_name]['activecomm'])) {
    define('NV_COMM_ID', $id); // ID bài viết hoặc
    define('NV_COMM_AREA', $module_info['funcs'][$op]['func_id']); // để đáp ứng comment ở bất cứ đâu không cứ là bài viết
    // check allow comemnt
    $allowed = $module_config[$module_name]['allowed_comm']; // tuy vào module để lấy cấu hình. Nếu là module news thì có cấu hình theo bài viết
    if ($allowed == '-1') {
        $allowed = $news_contents['allowed_comm'];
    }
    require_once NV_ROOTDIR . '/modules/comment/comment.php';
    $area = (defined('NV_COMM_AREA')) ? NV_COMM_AREA : 0;
    $checkss = md5($module_name . '-' . $area . '-' . NV_COMM_ID . '-' . $allowed . '-' . NV_CACHE_PREFIX);

    $content_comment = nv_comment_module($module_name, $checkss, $area, NV_COMM_ID, $allowed, 1);
} else {
    $content_comment = '';
}

// Xu ly Layout tuy chinh (khong ap dung cho theme mobile_default)
$module_info['layout_funcs'][$op_file] = (!empty($news_contents['layout_func']) and 'mobile_default' != $global_config['module_theme']) ? $news_contents['layout_func'] : $module_info['layout_funcs'][$op_file];

// Xử lý giọng đọc nếu có
$voicedata = empty($news_contents['voicedata']) ? [] : json_decode($news_contents['voicedata'], true);
$news_contents['voicedata'] = $news_contents['current_voice'] = [];
if (!empty($voicedata)) {
    $default_voice = $nv_Request->get_absint($module_file . '_voice', 'cookie', 0);
    $current_voice = [];

    foreach ($global_array_voices as $voice) {
        if (!empty($voice['status']) and !empty($voicedata[$voice['id']])) {
            $voice_path = $voicedata[$voice['id']];
            if (!nv_is_url($voice_path)) {
                $voice_path = NV_BASE_SITEURL . NV_UPLOADS_DIR . '/' . $module_info['module_upload'] . '/' . $voice_path;
            }
            $news_contents['voicedata'][$voice['id']] = [
                'id' => $voice['id'],
                'title' => $voice['title'],
                'path' => $voice_path
            ];

            // Xác định giọng đọc mặc định
            if (empty($current_voice) or $default_voice == $voice['id']) {
                $current_voice = $news_contents['voicedata'][$voice['id']];
            }
        }
    }
    $news_contents['current_voice'] = $current_voice;
    unset($voicedata, $current_voice);
}
$news_contents['autoplay'] = (int) $nv_Request->get_bool($module_file . '_autoplayvoice', 'cookie', false);

// Tạo mục lục cho bài viết dựa theo h2 và h3
$news_contents['navigation'] = [];
if (!empty($news_contents['auto_nav']) and !empty($news_contents['bodyhtml'])) {
    unset($matches);
    preg_match_all('/\<[\s]*(h2|h3)([^\>]*)\>(.*?)\<[\s]*\/[\s]*(h2|h3)[\s]*\>/is', $news_contents['bodyhtml'], $matches, PREG_SET_ORDER);

    $idname = 'art-menu-';
    $i = 0;
    $y = 0;
    $location = nv_url_rewrite($page_url, true);
    $location = NV_MY_DOMAIN . $location . ((str_contains($location, '?') ? '&' : '?') . 'ml=');

    foreach ($matches as $match) {
        $text = trim(preg_replace('/\s[\s]+/is', ' ', strip_tags(nv_br2nl($match[3]))));
        $tag = strtolower($match[1]);
        if (empty($text)) {
            continue;
        }

        if ($tag == 'h2') {
            ++$y;
            ++$i;
            $attrid = $idname . $i;

            $html = '<div class="btns"><button type="button" class="gonav" title="' . $nv_Lang->getModule('go_menu') . '"><i class="fa fa-chevron-up fa-fw"></i></button><button type="button" class="copylink" data-clipboard-text="' . $location . $attrid . '"><i class="fa fa-files-o fa-fw" title="' . $nv_Lang->getModule('copy_link') . '"></i></button></div>';
            $html = '<' . $tag . $match[2] . ' data-id="' . $attrid . '">' . $html . $match[3] . '</' . $tag . '>';

            $news_contents['navigation'][$y]['item'] = [$text, $attrid, $location . $attrid];
            $news_contents['bodyhtml'] = str_replace($match[0], $html, $news_contents['bodyhtml']);
        } elseif ($y) {
            ++$i;
            $attrid = $idname . $i;

            $html = '<div class="btns"><button type="button" class="gonav" title="' . $nv_Lang->getModule('go_menu') . '"><i class="fa fa-chevron-up fa-fw"></i></button><button type="button" class="copylink" data-clipboard-text="' . $location . $attrid . '"><i class="fa fa-files-o fa-fw" title="' . $nv_Lang->getModule('copy_link') . '"></i></button></div>';
            $html = '<' . $tag . $match[2] . ' data-id="' . $attrid . '">' . $html . $match[3] . '</' . $tag . '>';

            !isset($news_contents['navigation'][$y]['subitems']) && $news_contents['navigation'][$y]['subitems'] = [];
            $news_contents['navigation'][$y]['subitems'][] = [$text, $attrid, $location . $attrid];
            $news_contents['bodyhtml'] = str_replace($match[0], $html, $news_contents['bodyhtml']);
        }
    }
}

// Tin liên quan cố định do người đăng bài viết chọn
$news_contents['related_articles'] = [];
if ($news_contents['related_pos'] != 0 and !empty($news_contents['related_ids'])) {
    $db_slave->sqlreset()
        ->select('id, catid, title, alias, publtime, homeimgfile, homeimgthumb, hometext, external_link')
        ->from(NV_PREFIXLANG . '_' . $module_data . '_rows')
        ->where('id IN(' . $news_contents['related_ids'] . ') AND status=1')
        ->order($order_articles_by . ' DESC');

    $result = $db_slave->query($db_slave->sql());
    while ($row = $result->fetch()) {
        $row['imghome'] = $row['imgmobile'] = '';
        get_homeimgfile($row);

        $link = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module_name . '&amp;' . NV_OP_VARIABLE . '=' . $global_array_cat[$row['catid']]['alias'] . '/' . $row['alias'] . '-' . $row['id'] . $global_config['rewrite_exturl'];
        $news_contents['related_articles'][] = [
            'title' => $row['title'],
            'time' => $row['publtime'],
            'link' => $link,
            'newday' => $global_array_cat[$row['catid']]['newday'],
            'hometext' => $row['hometext'],
            'imghome' => $row['imghome'],
            'external_link' => $row['external_link']
        ];
    }
    $result->closeCursor();
}

[$news_contents, $array_keyword, $related_new_array, $related_array, $topic_array, $content_comment] = nv_apply_hook($module_name, 'before_detail_theme', [$news_contents, $array_keyword, $related_new_array, $related_array, $topic_array, $content_comment], [$news_contents, $array_keyword, $related_new_array, $related_array, $topic_array, $content_comment]);
$contents = detail_theme($news_contents, $array_keyword, $related_new_array, $related_array, $topic_array, $content_comment);

$key_words = ($module_config[$module_name]['keywords_tag'] and empty($news_contents['keywords'])) ? implode(',', $key_words) : $news_contents['keywords'];
$description = empty($news_contents['description']) ? $news_contents['hometext'] : $news_contents['description'];
$nv_schemas[] = $schema;

include NV_ROOTDIR . '/includes/header.php';
echo nv_site_theme($contents);
include NV_ROOTDIR . '/includes/footer.php';
