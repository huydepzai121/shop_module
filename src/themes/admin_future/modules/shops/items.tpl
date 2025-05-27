<link type="text/css" href="{$smarty.const.ASSETS_STATIC_URL}/js/jquery-ui/jquery-ui.min.css" rel="stylesheet">
<link rel="stylesheet" href="{$smarty.const.NV_BASE_SITEURL}themes/admin_future/css/dataTables.bootstrap5.min.css">
<script src="{$smarty.const.NV_BASE_SITEURL}themes/admin_future/js/jquery.dataTables.min.js"></script>

<script src="{$smarty.const.ASSETS_STATIC_URL}/js/select2/select2.min.js"></script>
<script src="{$smarty.const.ASSETS_STATIC_URL}/js/select2/i18n/{$smarty.const.NV_LANG_INTERFACE}.js"></script>
<script type="text/javascript" src="{$smarty.const.ASSETS_STATIC_URL}/js/jquery-ui/jquery-ui.min.js"></script>
<script type="text/javascript"src="{$smarty.const.ASSETS_STATIC_URL}/js/language/jquery.ui.datepicker-{$smarty.const.NV_LANG_INTERFACE}.js"></script>

<div class="card">
    <div class="card-body">
        <form method="get" action="{$smarty.const.NV_BASE_ADMINURL}index.php" id="form-search"
            onsubmit="return nv_search_submit();">
            <input type="hidden" name="{$smarty.const.NV_LANG_VARIABLE}" value="{$smarty.const.NV_LANG_DATA}">
            <input type="hidden" name="{$smarty.const.NV_NAME_VARIABLE}" value="{$MODULE_NAME}">
            <input type="hidden" name="{$smarty.const.NV_OP_VARIABLE}" value="{$OP}">
            <input type="hidden" name="checkss" value="{$CHECKSESS}">
            <div class="row g-3">
                <div class="col-sm-12 col-md-6 col-lg-4">
                    <div class="form-group">
                        <select class="form-select" name="stype">
                            <option value="-">---{$LANG->getModule('search_type')}---</option>
                            {foreach from=$SEARCH_TYPE key=key item=title}
                            <option value="{$key}" {if $key eq $SEARCH.stype} selected{/if}>{$title}</option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <div class="col-sm-12 col-md-6 col-lg-4">
                    <div class="form-group">
                        <input class="form-control" type="text" value="{$SEARCH.q}" name="q"
                            placeholder="{$LANG->getModule('search_key')}">
                    </div>
                </div>
                <div class="col-sm-12 col-md-6 col-lg-1">
                    <div class="form-group">
                        <button type="button" class="btn btn-secondary text-nowrap w-100" data-bs-toggle="collapse"
                            data-bs-target="#search-adv" aria-expanded="false" aria-controls="search-adv">
                            <i class="fa-solid fa-expand"></i>
                        </button>
                    </div>
                </div>
                <div class="col-sm-12 col-md-6 col-lg-3">
                    <div class="form-group">
                        <button class="btn btn-primary w-100" type="submit">
                            <i class="fa-solid fa-magnifying-glass"></i> {$LANG->getModule('search')}
                        </button>
                    </div>
                </div>
            </div>

            <div class="collapse mt-3" id="search-adv">
                <input type="hidden" name="adv" value="0">
                <div class="row g-3">
                    <div class="col-sm-12 col-md-6 col-lg-4">
                        <div class="form-group">
                            <select class="form-select select2" name="catid" id="catid">
                                <option value="0">---{$LANG->getModule('search_cat')}---</option>
                                {foreach from=$SEARCH_CAT item=cat}
                                <option value="{$cat.catid}" {if $cat.catid eq $SEARCH.catid} selected{/if}>{$cat.title}
                                </option>
                                {/foreach}
                            </select>
                        </div>
                    </div>
                    <div class="col-sm-12 col-md-6 col-lg-4">
                        <div class="form-group">
                            <div class="input-group">
                                <input type="text" class="form-control datepicker" name="from" id="from"
                                    value="{$SEARCH.from}" placeholder="{$LANG->getModule('date_from')}"
                                    autocomplete="off">
                                <button class="btn btn-secondary" type="button" id="from-btn">
                                    <i class="fa-regular fa-calendar"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-12 col-md-6 col-lg-4">
                        <div class="form-group">
                            <div class="input-group">
                                <input type="text" class="form-control datepicker" name="to" id="to"
                                    value="{$SEARCH.to}" placeholder="{$LANG->getModule('date_to')}" autocomplete="off">
                                <button class="btn btn-secondary" type="button" id="to-btn">
                                    <i class="fa-regular fa-calendar"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-12 col-md-6 col-lg-4">
                        <div class="form-group">
                            <select class="form-select" name="per_page">
                                <option value="">---{$LANG->getModule('search_per_page')}---</option>
                                {for $per_page=5 to 500 step 5}
                                <option value="{$per_page}" {if $per_page eq $PER_PAGE} selected{/if}>{$per_page}
                                </option>
                                {/for}
                            </select>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<div class="card mt-4">
    <div class="card-body">
        <form name="myform" id="myform" method="post">
            <div class="table-responsive">
                <table id="table_one" class="table table-striped table-bordered table-hover">
                    <thead class="bg-primary text-white">
                        <tr>
                            <td>
                                <input type="checkbox" class="form-check-input"
                                    onclick="nv_checkAll(this.form, 'idcheck[]', 'check_all[]',this.checked);">
                            </td>
                            <th style="width:100px">&nbsp;</th>
                            <th>{$LANG->getModule('name')}</th>
                            <th class="text-center w-150px">{$LANG->getModule('content_publ_date')}</th>
                            <th class="text-end w-150px">{$LANG->getModule('order_product_price')}</th>
                            <th class="text-center w-100px">{$LANG->getModule('views')}</th>
                            <th class="text-center w-100px">{$LANG->getModule('content_product_number1')}</th>
                            <th class="text-center w-100px">{$LANG->getModule('num_selled')}</th>
                            <th class="text-center w-100px">{$LANG->getModule('status')}</th>
                            <th class="text-end w-150px">{$LANG->getModule('function')}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach from=$DATA item=row}
                        <tr>
                            <td>
                                <input type="checkbox" name="idcheck[]" value="{$row.id}" class="form-check-input">
                            </td>
                            <td>
                                <img src="{$row.thumb}" alt="{$row.title}" class="img-thumbnail"
                                    style="max-width:100px">
                            </td>
                            <td>
                                <h6 class="mb-1">
                                    <a href="{$row.link}">{$row.title}</a>
                                </h6>
                                <small class="text-muted">
                                    {$LANG->getModule('order_update')}: {$row.edittime} |
                                    {$LANG->getModule('content_admin')}: {$row.admin_id}
                                </small>
                            </td>
                            <td class="text-center">{$row.publtime}</td>
                            <td class="text-end">
                                {if $row.product_price > 0}
                                    <div class="price-container">
                                        {if $row.discount_amount > 0}
                                            <div class="original-price">
                                                <del class="text-muted fs-13">{$row.product_price|number_format:0:'.':','} {$row.money_unit}</del>
                                                <span class="badge bg-danger ms-2">
                                                    {if $row.discount_unit == 'p'}
                                                        -{$row.discount_percent|number_format:1}%
                                                    {else}
                                                        -{$row.discount_amount|number_format:0:'.':','} {$row.money_unit}
                                                    {/if}
                                                </span>
                                            </div>
                                            <div class="final-price mt-1">
                                                <span class="text-danger fw-bold">{$row.final_price|number_format:0:'.':','} {$row.money_unit}</span>
                                            </div>
                                            <div class="discount-info mt-1">
                                                <small class="text-success">
                                                    {if $row.discount_unit == 'p'}
                                                        Giảm {$row.discount_percent|number_format:1}% khi mua từ {$row.discount_from} đến {$row.discount_to} sản phẩm
                                                    {else}
                                                        Giảm {$row.discount_amount|number_format:0:'.':','} {$row.money_unit} khi mua từ {$row.discount_from} đến {$row.discount_to} sản phẩm
                                                    {/if}
                                                </small>
                                            </div>
                                        {else}
                                            <div class="regular-price">
                                                <span class="fw-bold">{$row.product_price|number_format:0:'.':','} {$row.money_unit}</span>
                                            </div>
                                        {/if}
                                    </div>
                                {else}
                                    <span class="text-muted fst-italic">Chưa có giá</span>
                                {/if}
                            </td>
                            <td class="text-center">{$row.hitstotal|number_format:0:'.':','}</td>
                            <td class="text-center">{$row.product_number|number_format:0:'.':','}</td>
                            <td class="text-center">
                                {if $row.num_sell > 0}
                                <a href="{$row.link_seller}">
                                    {$row.num_sell|number_format:0:'.':','} {$row.product_unit}
                                </a>
                                {else}
                                {$row.num_sell|number_format:0:'.':','} {$row.product_unit}
                                {/if}
                            </td>
                            <td class="text-center">{$row.status}</td>
                            <td class="text-end">
                                <div class="btn-group">
                                    {if $WAREHOUSE_ACTIVE}
                                    <a href="{$row.link_warehouse}" class="btn btn-sm btn-info">
                                        <i class="fa-solid fa-cubes"></i>
                                    </a>
                                    {/if}
                                    <a href="{$row.link_copy}" class="btn btn-sm btn-success">
                                        <i class="fa-solid fa-copy"></i>
                                    </a>
                                    {$row.link_edit}
                                    {$row.link_delete}
                                </div>
                            </td>
                        </tr>
                        {/foreach}
                    </tbody>
                    <tfoot>
                        <tr align="left">
                            <td colspan="10">
                                <div class="d-flex align-items-center gap-2">
                                    <select class="form-control" name="action" id="action" style="width: 200px;">
                                        {foreach from=$ACTIONS item=action}
                                        <option value="{$action.key}">{$action.title}</option>
                                        {/foreach}
                                    </select>
                                    <input type="button" class="btn btn-primary" id="action-button" onclick="nv_main_action(this.form, '{$ACTION_CHECKSESS}', '{$LANG->getModule('msgnocheck')}')" value="{$LANG->getModule('action')}">
                                </div>
                            </td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </form>
    </div>
</div>

<div class="modal fade" id="imageModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">{$LANG->getModule('product_image')}</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"
                    aria-label="{$LANG->getGlobal('close')}"></button>
            </div>
            <div class="modal-body text-center">
            </div>
        </div>
    </div>
</div>

<script>
    window.onerror = function(message, source, lineno, colno, error) {
        console.error('JavaScript Error:', message, 'at', source, 'line', lineno, 'column', colno);
        console.error('Error object:', error);
        return true;
    };

    function nv_main_action(oForm, checkss, msgnocheck) {
        
        var listid = '';
        // Lấy tất cả checkbox được chọn
        $('input[name="idcheck[]"]:checked', oForm).each(function () {
            listid = listid + $(this).val() + ',';
        });
        // Bỏ dấu phẩy cuối cùng
        listid = listid.slice(0, -1);

        if (listid != '') {
            var action = document.getElementById('action').value;
            if (action == 'delete') {
                if (confirm('{$LANG->getModule("product_del_confirm")}')) {
                    $.ajax({
                        type: 'POST',
                        url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=del_content',
                        data: {
                            listid: listid,
                            checkss: checkss,
                            action: action
                        },
                        success: function (res) {
                            var r_split = res.split('_');
                            console.log(r_split);
                            if (r_split[0] == 'OK') {
                                location.reload();
                            } else {
                                alert(r_split[1]);
                            }
                        }
                    });
                }
            } else if (action == 'addtoblock') {
                window.location.href = script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=block&listid=' + listid + '#add';
            } else if (action == 'publtime') {
                window.location.href = script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=publtime&listid=' + listid + '&checkss=' + checkss;
            } else if (action == 'exptime') {
                window.location.href = script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=exptime&listid=' + listid + '&checkss=' + checkss;
            } else if (action == 'warehouse') {
                window.location.href = script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=warehouse&listid=' + listid + '&checkss=' + checkss;
            } else if (action == 'import') {
                 window.location.href = script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=import&listid=' + listid + '&checkss=' + checkss;
            }
        } else {
            alert(msgnocheck);
            return;
        }
    }

    $(function () {
        // Mở rộng thu gọn tìm kiếm
        const searchAdv = document.getElementById('search-adv');
        if (searchAdv) {
            searchAdv.addEventListener('hide.bs.collapse', () => {
                $('[name="adv"]').val('0');
            });
            searchAdv.addEventListener('show.bs.collapse', () => {
                $('[name="adv"]').val('1');
            });
        }

        $("#catid").select2();

        $('.datepicker').datepicker({
            dateFormat: 'dd/mm/yy',
            changeMonth: true,
            changeYear: true,
            showOtherMonths: true,
            showOn: 'focus'
        });

        $('#to-btn').click(function () {
            $("#to").datepicker('show');
        });

        $('#from-btn').click(function () {
            $("#from").datepicker('show');
        });

        $('.open_modal').click(function (e) {
            e.preventDefault();
            $('#imageModal .modal-body').html('<img src="' + $(this).data('src') + '" class="img-fluid">');
            $('#imageModal').modal('show');
        });

        $('[data-toggle="checkAll"]').on('change', function () {
            $('[data-toggle="checkSingle"]').prop('checked', $(this).prop('checked'));
        });

        window.nv_search_submit = function () {
            var q = $('#form-search input[name="q"]').val();
            var stype = $('#form-search select[name="stype"]').val();
            var catid = $('#form-search select[name="catid"]').val();
            var from = $('#form-search input[name="from"]').val();
            var to = $('#form-search input[name="to"]').val();
            var per_page = $('#form-search select[name="per_page"]').val();

            if (stype != '-' && q == '') {
                nvToast({
                    text: '{$LANG->getModule('search_key_empty')}',
                    type: 'error'
                });
                $('#form-search input[name="q"]').focus();
                return false;
            }

            var link = '{$smarty.const.NV_BASE_ADMINURL}index.php?' +
                '{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&' +
                '{$smarty.const.NV_NAME_VARIABLE}={$MODULE_NAME}&' +
                '{$smarty.const.NV_OP_VARIABLE}={$OP}';

            if (q != '') {
                link += '&q=' + encodeURIComponent(q);
            }
            if (stype != '-') {
                link += '&stype=' + stype;
            }
            if (catid != '0') {
                link += '&catid=' + catid;
            }
            if (from != '') {
                link += '&from=' + from;
            }
            if (to != '') {
                link += '&to=' + to;
            }
            if (per_page != '') {
                link += '&per_page=' + per_page;
            }

            window.location.href = link;
            return false;
        }

    });
</script>

<style>
    /* CSS để đẩy phân trang sang phải */
    .dataTables_wrapper .row:last-child>div:last-child {
        display: flex;
    }

    .dataTables_paginate {
        margin-left: auto !important;
    }

    .price-container {
        min-width: 150px;
    }
    .price-container .original-price {
        text-decoration: line-through;
        color: #6c757d;
    }
    .price-container .final-price {
        font-size: 1.1em;
    }
    .price-container .badge {
        font-size: 0.85em;
        padding: 3px 6px;
    }
    .price-container .discount-info {
        font-size: 0.9em;
    }
    .fs-13 {
        font-size: 13px;
    }
</style>

<script>
    $(document).ready(function () {
        var otable = $('#table_one').DataTable({
            "timeout": 300000,
            "pageLength": 25,
            "lengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "Tất cả"]],
            "language": {
                "lengthMenu": "Hiển thị _MENU_ dữ liệu/trang",
                "search": "{$LANG->getModule('datatable_search')}",
                "info": "Hiển thị từ _START_ đến _END_ của _TOTAL_ dòng",
                "zeroRecords": "Không tìm thấy dữ liệu",
                "infoFiltered": "(lọc từ _MAX_ dòng)",
                "infoEmpty": "Không có dữ liệu",
                "paginate": {
                    "first": "&laquo;",
                    "last": "&raquo;",
                    "next": "&rsaquo;",
                    "previous": "&lsaquo;"
                }
            }
        });

        // Thêm class Bootstrap cho select box
        $('.dataTables_length select').addClass('form-select form-select-sm');
        $('.dataTables_filter input').addClass('form-control form-control-sm');

        // Căn lề
        $('.dataTables_length').addClass('float-start');
        $('.dataTables_filter').addClass('float-end');

    });
</script>