<?php

/**
 * NukeViet Content Management System
 * @version 5.x
 * @author VINADES.,JSC <contact@vinades.vn>
 * @copyright (C) 2009-2025 VINADES.,JSC. All rights reserved
 * @license GNU/GPL version 2 or any later version
 * @see https://github.com/nukeviet The NukeViet CMS GitHub project
 */

if (!defined('NV_ADMIN') or !defined('NV_MAINFILE') or !defined('NV_IS_MODADMIN')) {
    exit('Stop!!!');
}

$submenu['content'] = $nv_Lang->getModule('voting_add');

$allow_func = [
    'main',
    'content',
    'del',
    'setting',
    'change_act'
];

define('NV_IS_FILE_ADMIN', true);

// Document
$array_url_instruction['main'] = 'https://wiki.nukeviet.vn/nukeviet4:admin:voting';
$array_url_instruction['content'] = 'https://wiki.nukeviet.vn/nukeviet4:admin:voting#them_tham_do';
