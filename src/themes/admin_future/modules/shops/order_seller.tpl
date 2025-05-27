<!-- Thêm CSS và JS cho jQuery UI Datepicker -->
<link type="text/css" href="{$smarty.const.NV_STATIC_URL}{$smarty.const.NV_ASSETS_DIR}/js/jquery-ui/jquery-ui.min.css" rel="stylesheet" />
<script type="text/javascript" src="{$smarty.const.NV_STATIC_URL}{$smarty.const.NV_ASSETS_DIR}/js/jquery-ui/jquery-ui.min.js"></script>
<script type="text/javascript" src="{$smarty.const.NV_STATIC_URL}{$smarty.const.NV_ASSETS_DIR}/js/language/jquery.ui.datepicker-{$smarty.const.NV_LANG_INTERFACE}.js"></script>

<div class="card border-primary border-3 border-bottom-0 border-start-0 border-end-0">
    <div class="card-header fs-5 fw-medium">{$LANG->getModule('order_seller')}</div>
    <div class="card-body pt-4">
        <div class="well">
            <form action="{$smarty.const.NV_BASE_ADMINURL}index.php" method="GET">
                <input type="hidden" name="{$smarty.const.NV_NAME_VARIABLE}" value="{$MODULE_NAME}" />
                <input type="hidden" name="{$smarty.const.NV_OP_VARIABLE}" value="{$OP}" />
                <div class="row">
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
                            <option value="{$STATUS.key}" {if $STATUS.selected}selected="selected"{/if}>{$STATUS.title}</option>
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

        <div class="table-responsive">
            <table class="table table-striped table-bordered table-hover">
                <thead>
                    <tr>
                        <th>{$LANG->getModule('order_name')}</th>
                        <th>{$LANG->getModule('order_email')}</th>
                        <th class="w100">{$LANG->getModule('order_count')}</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$SELLERS item=SELLER}
                    <tr>
                        <td>{$SELLER.order_name}</td>
                        <td>{$SELLER.order_email}</td>
                        <td>
                            {$SELLER.num_total}
                            <a href="{$SELLER.order_list_url}" class="float-end" title="{$LANG->getModule('order_list')}">
                                <i class="fa fa-search fa-lg"></i>
                            </a>
                        </td>
                    </tr>
                    {/foreach}
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="3">{$PAGES}</td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </div>
</div>

<script type="text/javascript">
$(function() {
    // Datepicker
    $("#from").datepicker({
        dateFormat: "dd/mm/yy",
        changeMonth: true,
        changeYear: true,
        showOtherMonths: true,
        showOn: 'focus',
        onSelect: function(selectedDate) {
            $("#to").datepicker("option", "minDate", selectedDate);
        }
    });

    $("#to").datepicker({
        dateFormat: "dd/mm/yy",
        changeMonth: true,
        changeYear: true,
        showOtherMonths: true,
        showOn: 'focus',
        onSelect: function(selectedDate) {
            $("#from").datepicker("option", "maxDate", selectedDate);
        }
    });

    $('#to-btn').click(function() {
        $("#to").datepicker('show');
    });

    $('#from-btn').click(function() {
        $("#from").datepicker('show');
    });
});
</script> 