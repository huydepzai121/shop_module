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

/*
 * Load danh sách danh mục sản phẩm
 * Sử dụng tại phần Nhóm Sản phẩm
 */

$pid = $nv_Request->get_int('pid', 'get', 0);

if ($pid >= 0) {
    $cateid = $nv_Request->get_string('cid', 'get', '');
    $cateid = nv_base64_decode($cateid);
    $cateid = unserialize($cateid);
    $cateid = $cateid ? $cateid : array();
    $list_cat = '';
    if ($pid > 0) {
        $sql = "SELECT cateid FROM " . $db_config['prefix'] . "_" . $module_data . "_group_cateid WHERE groupid=" . $pid;
        $result_cat = $db->query($sql);
        while (list ($catid_i) = $result_cat->fetch(3)) {
            if (empty($list_cat)) {
                $list_cat .= $catid_i;
            } else {
                $list_cat .= ',' . $catid_i;
            }
        }
    }
    if (!empty($list_cat)) {
        $list_cat = ' WHERE catid in (' . $list_cat . ')';
    }
    $table = $db_config['prefix'] . "_" . $module_data . "_catalogs";

    $sql = "SELECT catid, parentid, " . NV_LANG_DATA . "_title, lev, numsubcat FROM " . $table . $list_cat . " ORDER BY sort ASC";
    $result_cat = $db->query($sql);

    // Tạo cấu trúc cây danh mục
    $catalog_tree = [];
    $catalog_parent = [];
    
    while (list ($catid_i, $parentid_i, $title_i, $lev_i, $numsubcat_i) = $result_cat->fetch(3)) {
        $catalog_tree[$parentid_i][$catid_i] = [
            'id' => $catid_i,
            'title' => $title_i,
            'lev' => $lev_i,
            'selected' => in_array($catid_i, $cateid) ? true : false
        ];
        
        if ($parentid_i > 0) {
            $catalog_parent[$catid_i] = $parentid_i;
        }
    }
    
    // Tạo dropdown select với cấu trúc cây và khả năng tìm kiếm
    $contents = '
    <div class="dropdown-select-tree">
        <div class="select-box">
            <div class="select-box-header">
                <input type="text" class="form-control" id="catalog-search" placeholder="' . $nv_Lang->getModule('search') . '">
            </div>
            <div class="select-box-body">
                <div class="catalog-tree">';
    
    // Hàm đệ quy để hiển thị danh mục
    function display_catalog_tree($catalog_tree, $parent_id = 0, $level = 0) {
        $html = '';
        if (isset($catalog_tree[$parent_id])) {
            if ($level == 0) {
                // Danh mục gốc
                foreach ($catalog_tree[$parent_id] as $cat) {
                    $checked = $cat['selected'] ? 'checked' : '';
                    $has_children = isset($catalog_tree[$cat['id']]) ? 'has-children' : '';
                    
                    $html .= '<div class="catalog-item ' . $has_children . '">';
                    $html .= '<div class="catalog-item-header">';
                    if ($has_children) {
                        $html .= '<span class="toggle-icon">▶</span>';
                    }
                    $html .= '<div class="form-check">';
                    $html .= '<input class="form-check-input" type="checkbox" name="cateid[]" value="' . $cat['id'] . '" id="cat_' . $cat['id'] . '" ' . $checked . '>';
                    $html .= '<label class="form-check-label" for="cat_' . $cat['id'] . '">' . $cat['title'] . '</label>';
                    $html .= '</div>';
                    $html .= '</div>';
                    
                    // Hiển thị danh mục con
                    if (isset($catalog_tree[$cat['id']])) {
                        $html .= '<div class="catalog-children" style="display:none;">';
                        $html .= display_catalog_tree($catalog_tree, $cat['id'], $level + 1);
                        $html .= '</div>';
                    }
                    
                    $html .= '</div>';
                }
            } else {
                // Danh mục con
                foreach ($catalog_tree[$parent_id] as $cat) {
                    $checked = $cat['selected'] ? 'checked' : '';
                    $padding_left = ($level - 1) * 20;
                    
                    $html .= '<div class="catalog-item" style="padding-left: ' . $padding_left . 'px;">';
                    $html .= '<div class="form-check">';
                    $html .= '<input class="form-check-input" type="checkbox" name="cateid[]" value="' . $cat['id'] . '" id="cat_' . $cat['id'] . '" ' . $checked . '>';
                    $html .= '<label class="form-check-label" for="cat_' . $cat['id'] . '">' . $cat['title'] . '</label>';
                    $html .= '</div>';
                    
                    // Hiển thị danh mục con
                    if (isset($catalog_tree[$cat['id']])) {
                        $html .= display_catalog_tree($catalog_tree, $cat['id'], $level + 1);
                    }
                    
                    $html .= '</div>';
                }
            }
        }
        return $html;
    }
    
    $contents .= display_catalog_tree($catalog_tree);
    $contents .= '
                </div>
            </div>
        </div>
    </div>
    
    <style>
    .dropdown-select-tree {
        position: relative;
        width: 100%;
    }
    .select-box {
        border: 1px solid #ced4da;
        border-radius: 0.25rem;
        background-color: #fff;
    }
    .select-box-header {
        padding: 10px;
        border-bottom: 1px solid #ced4da;
    }
    .select-box-body {
        max-height: 300px;
        overflow-y: auto;
        padding: 10px 0;
    }
    .catalog-tree {
        position: relative;
    }
    .catalog-item {
        padding: 5px 10px;
    }
    .catalog-item-header {
        display: flex;
        align-items: center;
    }
    .toggle-icon {
        margin-right: 5px;
        cursor: pointer;
        font-size: 10px;
    }
    .catalog-children {
        padding-left: 20px;
    }
    .has-children > .catalog-item-header .toggle-icon {
        display: inline-block;
    }
    </style>
    
    <script>
    $(document).ready(function() {
        // Xử lý tìm kiếm
        $("#catalog-search").on("keyup", function() {
            var value = $(this).val().toLowerCase();
            
            if (value.length > 0) {
                // Ẩn tất cả các mục trước
                $(".catalog-item").hide();
                
                // Tìm các mục phù hợp với từ khóa
                $(".catalog-item").each(function() {
                    var text = $(this).text().toLowerCase();
                    if (text.indexOf(value) > -1) {
                        // Hiển thị mục này
                        $(this).show();
                        
                        // Hiển thị tất cả các mục cha của mục này
                        var $parent = $(this).parents(".catalog-children");
                        $parent.each(function() {
                            $(this).show();
                            $(this).closest(".catalog-item").show();
                            $(this).prev(".catalog-item-header").find(".toggle-icon").html("▼");
                        });
                        
                        // Mở rộng danh mục cha
                        $parent.slideDown();
                    }
                });
            } else {
                // Khi xóa từ khóa tìm kiếm, hiển thị lại tất cả các mục và đóng các danh mục con
                $(".catalog-item").show();
                $(".catalog-children").slideUp();
                $(".toggle-icon").html("▶");
            }
        });
        
        // Xử lý mở/đóng danh mục
        $(document).on("click", ".toggle-icon", function() {
            var $parent = $(this).closest(".catalog-item");
            var $children = $parent.find("> .catalog-children");
            
            if ($children.is(":visible")) {
                $(this).html("▶");
                $children.slideUp();
            } else {
                $(this).html("▼");
                $children.slideDown();
            }
        });
    });
    </script>';
    
} else {
    $contents = '';
}

include NV_ROOTDIR . '/includes/header.php';
echo $contents;
include NV_ROOTDIR . '/includes/footer.php';
