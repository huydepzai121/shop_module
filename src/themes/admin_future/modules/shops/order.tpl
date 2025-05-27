<!-- Thêm CSS và JS cho jQuery UI Datepicker -->
<link type="text/css" href="{$smarty.const.NV_STATIC_URL}{$smarty.const.NV_ASSETS_DIR}/js/jquery-ui/jquery-ui.min.css"
    rel="stylesheet" />
<script type="text/javascript"
    src="{$smarty.const.NV_STATIC_URL}{$smarty.const.NV_ASSETS_DIR}/js/jquery-ui/jquery-ui.min.js"></script>
<script type="text/javascript"
    src="{$smarty.const.NV_STATIC_URL}{$smarty.const.NV_ASSETS_DIR}/js/language/jquery.ui.datepicker-{$smarty.const.NV_LANG_INTERFACE}.js"></script>

<div class="card border-primary border-3 border-bottom-0 border-start-0 border-end-0">
    <div class="card-header fs-5 fw-medium">{$LANG->getModule('order_title')}</div>
    <div class="card-body pt-4">
        <div class="well">
            <form action="{$smarty.const.NV_BASE_ADMINURL}index.php" method="GET">
                <input type="hidden" name="{$smarty.const.NV_NAME_VARIABLE}" value="{$MODULE_NAME}" />
                <input type="hidden" name="{$smarty.const.NV_OP_VARIABLE}" value="{$OP}" />
                <div class="row">
                    <div class="col-sm-6 col-md-4 mb-3">
                        <input type="text" name="order_code" value="{$SEARCH.order_code}" class="form-control"
                            placeholder="{$LANG->getModule('order_code')}" />
                    </div>
                    <div class="col-sm-6 col-md-4 mb-3">
                        <div class="input-group">
                            <input type="text" name="from" id="from" value="{$SEARCH.date_from}" class="form-control"
                                placeholder="{$LANG->getModule('date_from')}" readonly />
                            <button class="btn btn-secondary" type="button" id="from-btn">
                                <i class="fa fa-calendar"></i>
                            </button>
                        </div>
                    </div>
                    <div class="col-sm-6 col-md-4 mb-3">
                        <div class="input-group">
                            <input type="text" name="to" id="to" value="{$SEARCH.date_to}" class="form-control"
                                placeholder="{$LANG->getModule('date_to')}" readonly />
                            <button class="btn btn-secondary" type="button" id="to-btn">
                                <i class="fa fa-calendar"></i>
                            </button>
                        </div>
                    </div>
                    <div class="col-sm-6 col-md-4 mb-3">
                        <input type="email" name="order_email" value="{$SEARCH.order_email}" class="form-control"
                            placeholder="{$LANG->getModule('order_email')}" />
                    </div>
                    <div class="col-sm-6 col-md-4 mb-3">
                        <select class="form-select" name="order_payment">
                            <option value="">{$LANG->getModule('order_payment')}</option>
                            {foreach from=$STATUS_OPTIONS item=STATUS}
                            <option value="{$STATUS.key}" {if $STATUS.selected}selected="selected" {/if}>{$STATUS.title}
                            </option>
                            {/foreach}
                        </select>
                    </div>
                    <div class="col-sm-6 col-md-4 mb-3">
                        <input type="hidden" name="checkss" value="{$CHECKSESS}" />
                        <button type="submit" class="btn btn-primary" name="search">
                            <i class="fa fa-search"></i> {$LANG->getModule('search')}
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <div class="mb-3">
            <div class="float-end">
                <span>{$LANG->getModule('siteinfo_order')}: <strong
                        class="text-danger">{$ORDER_INFO.num_items}</strong></span>
                <span class="ms-3">{$LANG->getModule('order_total')}: <strong
                        class="text-danger">{$ORDER_INFO.sum_price} {$ORDER_INFO.sum_unit}</strong></span>
            </div>
            <div class="clearfix"></div>
        </div>

        <div class="table-responsive">
            <table class="table table-striped table-bordered table-hover">
                <thead>
                    <tr>
                        <th width="10px" class="text-center"></th>
                        <th>{$LANG->getModule('order_code')}</th>
                        <th>{$LANG->getModule('order_time')}</th>
                        <th>{$LANG->getModule('order_email')}</th>
                        <th class="text-end">{$LANG->getModule('order_total')}</th>
                        <th>{$LANG->getModule('order_payment')}</th>
                        <th width="130px" class="text-center">{$LANG->getModule('function')}</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$ORDERS item=ORDER}
                    <tr id="{$ORDER.order_id}" {if $ORDER.bg_view}class="table-warning" {/if}>
                        <td>
                            <input type="checkbox" class="form-check-input" value="{$ORDER.order_id}"
                                {$ORDER.disabled} />
                        </td>
                        <td>
                            <a href="{$ORDER.link_view}">{$ORDER.order_code}</a>
                        </td>
                        <td>{$ORDER.order_time}</td>
                        <td>
                            <a href="{$ORDER.link_user}" class="text-decoration-underline"
                                target="_blank">{$ORDER.order_email}</a>
                        </td>
                        <td class="text-end">{$ORDER.order_total} {$ORDER.unit_total}</td>
                        <td>{$ORDER.status_payment}</td>
                        <td class="text-center">
                            <a href="{$ORDER.link_view}" class="btn btn-primary btn-xs">
                                <i class="fa fa-eye"></i>
                            </a>
                            {if !empty($ORDER.link_delete)}
                            <a href="{$ORDER.link_delete}" class="btn btn-danger btn-xs ms-1 delete">
                                <i class="fa fa-trash"></i>
                            </a>
                            {/if}
                        </td>
                    </tr>
                    {/foreach}
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="2">
                            <button type="button" class="btn btn-secondary btn-xs" id="check-all">
                                <i class="fa fa-check-square"></i> {$LANG->getModule('prounit_select')}
                            </button>
                            <button type="button" class="btn btn-secondary btn-xs ms-1" id="uncheck-all">
                                <i class="fa fa-square"></i> {$LANG->getModule('prounit_unselect')}
                            </button>
                            <button type="button" class="btn btn-danger btn-xs ms-1" id="delete-all">
                                <i class="fa fa-trash"></i> {$LANG->getModule('prounit_del_select')}
                            </button>
                        </td>
                        <td colspan="5">
                            {$PAGES}
                        </td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(function () {
        // Datepicker
        $("#from").datepicker({
            dateFormat: "dd/mm/yy",
            changeMonth: true,
            changeYear: true,
            showOtherMonths: true,
            showOn: 'focus',
            onSelect: function (selectedDate) {
                $("#to").datepicker("option", "minDate", selectedDate);
            }
        });

        $("#to").datepicker({
            dateFormat: "dd/mm/yy",
            changeMonth: true,
            changeYear: true,
            showOtherMonths: true,
            showOn: 'focus',
            onSelect: function (selectedDate) {
                $("#from").datepicker("option", "maxDate", selectedDate);
            }
        });

        $('#to-btn').click(function () {
            $("#to").datepicker('show');
        });

        $('#from-btn').click(function () {
            $("#from").datepicker('show');
        });

        // Checkbox
        $('#check-all').click(function () {
            $('input:checkbox:not([disabled])').prop('checked', true);
        });

        $('#uncheck-all').click(function () {
            $('input:checkbox').prop('checked', false);
        });

        // Delete
        $('#delete-all').click(function () {
            nvConfirm('{$LANG->getModule('delete_confirm')}', () => {
                var listid = [];
                $('input.ck:checked').each(function () {
                    listid.push($(this).val());
                });
                if (listid.length < 1) {
                    nvAlert('{$LANG->getModule('please_select_one')}', 'error');
                    return false;
                }
                $.ajax({
                    type: 'POST',
                    url: '{$URL_DEL}',
                    data: 'listid=' + listid,
                    success: function (res) {
                        if (res == 'OK') {
                            window.location.href = window.location.href;
                        } else {
                            nvAlert('{$LANG->getModule('error_delete')}', 'error');
                        }
                    }
                });
            });
        });

        // Delete single
        $('.delete').click(function (e) {
            e.preventDefault();
            var href = $(this).attr('href');
            nvConfirm('{$LANG->getModule('delete_confirm')}', () => {
                $.ajax({
                    type: 'POST',
                    url: href,
                    success: function (res) {
                        if (res == 'OK') {
                            window.location.href = window.location.href;
                        } else {
                            nvAlert('{$LANG->getModule('error_delete')}', 'error');
                        }
                    }
                });
            });
        });
    });
</script>