<?php

/**
 * @Project NUKEVIET 4.x
 * @Author VINADES.,JSC <contact@vinades.vn>
 * @Copyright (C) 2017 VINADES.,JSC. All rights reserved
 * @License GNU/GPL version 2 or any later version
 * @Createdate 04/18/2017 09:47
 */

if (!defined('NV_MAINFILE')) {
    die('Stop!!!');
}

if (!nv_function_exists('nv_global_product_center')) {
    /**
     * nv_block_config_product_center_blocks()
     *
     * @param mixed $module
     * @param mixed $data_block
     * @return
     */
    function nv_block_config_product_center_blocks($module, $data_block)
    {
        global $nv_Cache, $db_config, $site_mods, $nv_Lang;

        $html = "<div class=\"form-group\">";
        $html .= "	<label class=\"control-label col-sm-6\">" . $nv_Lang->getModule('blockid') . "</label>";
        $html .= "	<td><select name=\"config_blockid\" class=\"form-control w200\">\n";

        $sql = "SELECT bid, " . NV_LANG_DATA . "_title," . NV_LANG_DATA . "_alias FROM " . $db_config['prefix'] . "_" . $site_mods[$module]['module_data'] . "_block_cat ORDER BY weight ASC";
        $list = $nv_Cache->db($sql, 'catid', $module);

        foreach ($list as $l) {
            $sel = ($data_block['blockid'] == $l['bid']) ? ' selected' : '';
            $html .= "<option value=\"" . $l['bid'] . "\" " . $sel . ">" . $l[NV_LANG_DATA . '_title'] . "</option>\n";
        }

        $html .= "	</select></div>\n";
        $html .= '<script type="text/javascript">';
        $html .= '	$("select[name=config_blockid]").change(function() {';
        $html .= '		$("input[name=title]").val($("select[name=config_blockid] option:selected").text());';
        $html .= '	});';
        $html .= '</script>';
        $html .= "</div>";

        $html .= "<div class=\"form-group\">";
        $html .= "	<label class=\"control-label col-sm-6\">" . $nv_Lang->getModule('numget') . "</label>";
        $html .= "	<div class=\"col-sm-18\"><input class=\"form-control w100\" type=\"text\" name=\"config_numget\" size=\"5\" value=\"" . $data_block['numget'] . "\"/></div>";
        $html .= "</div>";

        $html .= "<div class=\"form-group\">";
        $html .= "	<label class=\"control-label col-sm-6\">" . $nv_Lang->getModule('numrow') . "</label>";
        $html .= "	<div class=\"col-sm-18\"><input class=\"form-control w100\" type=\"text\" name=\"config_numrow\" size=\"5\" value=\"" . $data_block['numrow'] . "\"/></div>";
        $html .= "</div>";

        return $html;
    }

    /**
     * nv_block_config_product_center_blocks_submit()
     *
     * @param mixed $module
     * @return
     */
    function nv_block_config_product_center_blocks_submit($module)
    {
        global $nv_Request;
        $return = array();
        $return['error'] = array();
        $return['config'] = array();
        $return['config']['blockid'] = $nv_Request->get_int('config_blockid', 'post', 0);
        $return['config']['numrow'] = $nv_Request->get_int('config_numrow', 'post', 0);
        $return['config']['numget'] = $nv_Request->get_int('config_numget', 'post', 0);
        return $return;
    }

    if (!nv_function_exists('nv_get_price_tmp')) {
        function nv_get_price_tmp($module_name, $module_data, $module_file, $pro_id)
        {
            global $nv_Cache, $db, $db_config, $module_config, $discounts_config;

            $price = array();
            $pro_config = $module_config[$module_name];

            require_once NV_ROOTDIR . '/modules/' . $module_file . '/site.functions.php';
            $price = nv_get_price($pro_id, $pro_config['money_unit'], 1, false, $module_name);

            return $price;
        }
    }

    /**
     * nv_global_product_center()
     *
     * @param mixed $block_config
     * @return
     */
    function nv_global_product_center($block_config)
    {
        global $nv_Cache, $site_mods, $global_config, $module_config, $module_name, $global_array_shops_cat, $db_config, $my_head, $db, $pro_config, $money_config, $blockID, $nv_Lang;

        $module = $block_config['module'];
        $mod_data = $site_mods[$module]['module_data'];
        $mod_file = $site_mods[$module]['module_file'];
        $num_view = $block_config['numrow'];
        $num_get = $block_config['numget'];

        $i = 1;
        $j = 1;
        $page_i = '';
        if (file_exists(NV_ROOTDIR . "/themes/" . $global_config['module_theme'] . "/modules/" . $mod_file . "/block.product_center.tpl")) {
            $block_theme = $global_config['module_theme'];
        } else {
            $block_theme = 'default';
        }

        if ($module != $module_name) {
            // Css
            if (file_exists(NV_ROOTDIR . '/themes/' . $global_config['module_theme'] . '/css/' . $mod_file . '.css')) {
                $block_css = $global_config['module_theme'];
            } else {
                $block_css = 'default';
            }
            $my_head .= '<link rel="stylesheet" href="' . NV_STATIC_URL . 'themes/' . $block_css . '/css/' . $mod_file . '.css' . '" type="text/css" />';

            // Language
            if (file_exists(NV_ROOTDIR . '/modules/' . $mod_file . '/language/' . NV_LANG_DATA . '.php')) {
                require_once NV_ROOTDIR . '/modules/' . $mod_file . '/language/' . NV_LANG_DATA . '.php';
            }

            $sql = 'SELECT catid, parentid, lev, ' . NV_LANG_DATA . '_title AS title, ' . NV_LANG_DATA . '_alias AS alias, viewcat, numsubcat, subcatid, numlinks, ' . NV_LANG_DATA . '_description AS description, inhome, ' . NV_LANG_DATA . '_keywords AS keywords, groups_view, typeprice FROM ' . $db_config['prefix'] . '_' . $mod_data . '_catalogs ORDER BY sort ASC';
            $list = $nv_Cache->db($sql, 'catid', $module);
            foreach ($list as $row) {
                $global_array_shops_cat[$row['catid']] = array(
                    'catid' => $row['catid'],
                    'parentid' => $row['parentid'],
                    'title' => $row['title'],
                    'alias' => $row['alias'],
                    'link' => NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module . '&amp;' . NV_OP_VARIABLE . '=' . $row['alias'],
                    'viewcat' => $row['viewcat'],
                    'numsubcat' => $row['numsubcat'],
                    'subcatid' => $row['subcatid'],
                    'numlinks' => $row['numlinks'],
                    'description' => $row['description'],
                    'inhome' => $row['inhome'],
                    'keywords' => $row['keywords'],
                    'groups_view' => $row['groups_view'],
                    'lev' => $row['lev'],
                    'typeprice' => $row['typeprice']
                );
            }
            unset($list, $row);
            $pro_config = $module_config[$module];

            // Lay ty gia ngoai te
            $sql = 'SELECT code, currency, symbol, exchange, round, number_format FROM ' . $db_config['prefix'] . '_' . $mod_data . '_money_' . NV_LANG_DATA;
            $cache_file = NV_LANG_DATA . '_' . md5($sql) . '_' . NV_CACHE_PREFIX . '.cache';
            if (($cache = $nv_Cache->getItem($module, $cache_file)) != false) {
                $money_config = unserialize($cache);
            } else {
                $money_config = array();
                $result = $db->query($sql);
                while ($row = $result->fetch()) {
                    $money_config[$row['code']] = array(
                        'code' => $row['code'],
                        'currency' => $row['currency'],
                        'exchange' => $row['exchange'],
                        'round' => $row['round'],
                        'number_format' => $row['number_format'],
                        'decimals' => $row['round'] > 1 ? $row['round'] : strlen($row['round']) - 2,
                        'is_config' => ($row['code'] == $pro_config['money_unit']) ? 1 : 0
                    );
                }
                $result->closeCursor();
                $cache = serialize($money_config);
                $nv_Cache->setItem($module, $cache_file, $cache);
            }
        }

        $xtpl = new XTemplate('block.product_center.tpl', NV_ROOTDIR . '/themes/' . $block_theme . '/modules/' . $mod_file);
        $xtpl->assign('LANG', \NukeViet\Core\Language::$lang_module);
        $xtpl->assign('THEME_TEM', NV_BASE_SITEURL . 'themes/' . $block_theme);
        $xtpl->assign('NUMVIEW', $num_view);
        $xtpl->assign('MODULE_FILE', $mod_file);

        if ($pro_config['sortdefault'] == 0) {
            $orderby = 't1.id DESC';
        } elseif ($pro_config['sortdefault'] == 1) {
            $orderby = 't1.product_price ASC, t1.id DESC';
        } else {
            $orderby = 't1.product_price DESC, t1.id DESC';
        }

        $db->sqlreset()
            ->select('t1.id, t1.listcatid, t1.' . NV_LANG_DATA . '_title AS title, t1.' . NV_LANG_DATA . '_alias AS alias, t1.homeimgfile, t1.homeimgthumb , t1.homeimgalt, t1.showprice')
            ->from($db_config['prefix'] . '_' . $mod_data . '_rows t1')
            ->join('INNER JOIN ' . $db_config['prefix'] . '_' . $mod_data . '_block t2 ON t1.id = t2.id')
            ->where('t2.bid= ' . $block_config['blockid'] . ' AND t1.status =1')
            ->order($orderby)
            ->limit($num_get);

        $list = $nv_Cache->db($db->sql(), '', $module);
        foreach ($list as $row) {
            $link = NV_BASE_SITEURL . 'index.php?' . NV_LANG_VARIABLE . '=' . NV_LANG_DATA . '&amp;' . NV_NAME_VARIABLE . '=' . $module . '&amp;' . NV_OP_VARIABLE . '=' . $global_array_shops_cat[$row['listcatid']]['alias'] . '/' . $row['alias'] . $global_config['rewrite_exturl'];

            if ($row['homeimgthumb'] == 1) {
                //image thumb

                $src_img = NV_BASE_SITEURL . NV_FILES_DIR . '/' . $site_mods[$module]['module_upload'] . '/' . $row['homeimgfile'];
            } elseif ($row['homeimgthumb'] == 2) {
                //image file

                $src_img = NV_BASE_SITEURL . NV_UPLOADS_DIR . '/' . $site_mods[$module]['module_upload'] . '/' . $row['homeimgfile'];
            } elseif ($row['homeimgthumb'] == 3) {
                //image url

                $src_img = $row['homeimgfile'];
            } else {
                //no image

                $src_img = NV_STATIC_URL . 'themes/' . $block_theme . '/images/shops/no-image.jpg';
            }

            $xtpl->assign('LINK', $link);
            $xtpl->assign('TITLE', $row['title']);
            $xtpl->assign('TITLE0', nv_clean60($row['title'], 30));
            $xtpl->assign('SRC_IMG', $src_img);
            $xtpl->assign('BLOCKID', $blockID);

            if ($pro_config['active_price'] == '1') {
                if ($row['showprice'] == '1') {
                    $price = nv_get_price_tmp($module, $mod_data, $mod_file, $row['id']);
                    $xtpl->assign('PRICE', $price);
                    if ($price['discount_percent'] > 0) {
                        $xtpl->parse('main.items.price.discounts');
                    } else {
                        $xtpl->parse('main.items.price.no_discounts');
                    }
                    $xtpl->parse('main.items.price');
                } else {
                    $xtpl->parse('main.items.contact');
                }
            }

            $xtpl->parse('main.items');
        }

        $xtpl->parse('main');
        return $xtpl->text('main');
    }
}

if (defined('NV_SYSTEM')) {
    $content = nv_global_product_center($block_config);
}
