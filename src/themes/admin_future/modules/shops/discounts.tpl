<link type="text/css" href="{$smarty.const.ASSETS_STATIC_URL}/js/jquery-ui/jquery-ui.min.css" rel="stylesheet">
<script src="{$smarty.const.ASSETS_STATIC_URL}/js/jquery-ui/jquery-ui.min.js"></script>
<script
    src="{$smarty.const.ASSETS_STATIC_URL}/js/language/jquery.ui.datepicker-{$smarty.const.NV_LANG_INTERFACE}.js"></script>

<div class="card">
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-bordered align-middle">
                <thead class="bg-primary text-white">
                    <tr>
                        <th>{$LANG->getModule('title')}</th>
                        <th class="text-center">{$LANG->getModule('begin_time')}</th>
                        <th class="text-center">{$LANG->getModule('end_time')}</th>
                        <th>{$LANG->getModule('config_discounts')}</th>
                        <th class="text-center w-100px">{$LANG->getModule('discounts_dis_detail')}</th>
                        <th class="text-end w-200px">{$LANG->getModule('function')}</th>
                    </tr>
                </thead>
                {if !empty($GENERATE_PAGE)}
                <tfoot>
                    <tr>
                        <td colspan="6" class="text-center">{$GENERATE_PAGE}</td>
                    </tr>
                </tfoot>
                {/if}
                <tbody>
                    {foreach from=$DATA item=VIEW}
                    <tr>
                        <td class="fw-bold">{$VIEW.title}</td>
                        <td class="text-center">{$VIEW.begin_time}</td>
                        <td class="text-center">{$VIEW.end_time}</td>
                        <td>
                            <table class="table table-bordered mb-0">
                                <thead class="bg-light">
                                    <tr>
                                        <th class="text-center">{$LANG->getModule('discount_from')}</th>
                                        <th class="text-center">{$LANG->getModule('discount_to')}</th>
                                        <th class="text-center">{$LANG->getModule('discount_number')}</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {foreach from=$VIEW.discounts item=DISCOUNT}
                                    <tr>
                                        <td class="text-center fw-medium">{$DISCOUNT.discount_from}</td>
                                        <td class="text-center fw-medium">{$DISCOUNT.discount_to}</td>
                                        <td class="text-center fw-medium">
                                            {$DISCOUNT.discount_number}{$DISCOUNT.discount_unit}</td>
                                    </tr>
                                    {/foreach}
                                </tbody>
                            </table>
                        </td>
                        <td class="text-center">
                            <span
                                class="badge {if $VIEW.detail eq $LANG->getGlobal('yes')}bg-success{else}bg-secondary{/if} fs-6">{$VIEW.detail}</span>
                        </td>
                        <td class="text-end">
                            <div class="btn-group">
                                <a href="{$VIEW.link_edit}" class="btn btn-primary" title="{$LANG->getModule('edit')}">
                                    <i class="fa fa-edit"></i>
                                </a>
                                <a href="{$VIEW.link_delete}" onclick="return confirm(nv_is_del_confirm[0]);"
                                    class="btn btn-danger" title="{$LANG->getModule('delete')}">
                                    <i class="fa fa-trash"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>
    </div>
</div>

<div class="card mt-4">
    <div class="card-header bg-primary text-white">
        <h3 class="card-title mb-0">{$CAPTION}</h3>
    </div>
    <div class="card-body">
        <form
            action="{$NV_BASE_ADMINURL}index.php?{$NV_LANG_VARIABLE}={$NV_LANG_DATA}&amp;{$NV_NAME_VARIABLE}={$MODULE_NAME}&amp;{$NV_OP_VARIABLE}={$OP}"
            method="post">
            <input type="hidden" name="did" value="{$ROW.did}" />
            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label class="form-label fw-bold required">{$LANG->getModule('title')}</label>
                        <input class="form-control" type="text" name="title" value="{$ROW.title}" required
                            oninvalid="setCustomValidity(nv_required)" oninput="setCustomValidity('')" />
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="mb-3">
                        <label class="form-label fw-bold required">{$LANG->getModule('begin_time')}</label>
                        <div class="input-group">
                            <input class="form-control" type="text" name="begin_time" value="{$ROW.begin_time}"
                                id="begin_time" />
                            <button class="btn btn-primary" type="button" id="begin_time-btn">
                                <i class="fa fa-calendar"></i>
                            </button>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="mb-3">
                        <label class="form-label fw-bold">{$LANG->getModule('end_time')}</label>
                        <div class="input-group">
                            <input class="form-control" type="text" name="end_time" value="{$ROW.end_time}"
                                id="end_time" />
                            <button class="btn btn-primary" type="button" id="end_time-btn">
                                <i class="fa fa-calendar"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="mb-3">
                <div class="form-check">
                    <input type="checkbox" class="form-check-input" name="detail" value="1" id="detail"
                        {$ROW.detail_ck} />
                    <label class="form-check-label fw-medium"
                        for="detail">{$LANG->getModule('discounts_dis_detail')}</label>
                </div>
            </div>
            <div class="mb-3">
                <label class="form-label fw-bold">{$LANG->getModule('categories')}</label>
                <div id="vcatid">
                </div>
            </div>
            <div class="mb-3">
                <label class="form-label fw-bold">{$LANG->getModule('config_discounts')}</label>
                <div class="table-responsive">
                    <table class="table table-bordered align-middle">
                        <thead class="bg-light">
                            <tr>
                                <th>{$LANG->getModule('discount_from')}</th>
                                <th>{$LANG->getModule('discount_to')}</th>
                                <th>{$LANG->getModule('discount_number')}</th>
                                <th class="w-100px"></th>
                            </tr>
                        </thead>
                        <tbody id="discount_items">
                            {foreach from=$CONFIG item=CONFIG_ITEM}
                            <tr id="discount_{$CONFIG_ITEM.id}">
                                <td>
                                    <input class="form-control" type="number"
                                        name="config[{$CONFIG_ITEM.id}][discount_from]"
                                        value="{$CONFIG_ITEM.discount_from}" />
                                </td>
                                <td>
                                    <input class="form-control" type="number"
                                        name="config[{$CONFIG_ITEM.id}][discount_to]"
                                        value="{$CONFIG_ITEM.discount_to}" />
                                </td>
                                <td>
                                    <div class="input-group">
                                        <input class="form-control" type="text"
                                            name="config[{$CONFIG_ITEM.id}][discount_number]"
                                            value="{$CONFIG_ITEM.discount_number}" />
                                        <select name="config[{$CONFIG_ITEM.id}][discount_unit]"
                                            class="form-select w-auto">
                                            {foreach from=$CONFIG_ITEM.units item=UNIT}
                                            <option value="{$UNIT.key}" {$UNIT.selected}>{$UNIT.value}</option>
                                            {/foreach}
                                        </select>
                                    </div>
                                </td>
                                <td class="text-center">
                                    <button type="button" class="btn btn-danger"
                                        onclick="$('#discount_{$CONFIG_ITEM.id}').remove();">
                                        <i class="fa fa-trash"></i>
                                    </button>
                                </td>
                            </tr>
                            {/foreach}
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="4">
                                    <button type="button" class="btn btn-success" onclick="nv_add_discount_item();">
                                        <i class="fa fa-plus"></i> {$LANG->getModule('add_discount')}
                                    </button>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
            <div class="text-center">
                <button class="btn btn-primary btn-lg" type="submit" name="submit">
                    <i class="fa fa-save"></i> {$LANG->getModule('save')}
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Template for discount options -->
<template id="discount_unit_options">
    {foreach from=$CONFIG[0].units item=UNIT}
    <option value="{$UNIT.key}">{$UNIT.value}</option>
    {/foreach}
</template>

<script>
    $(function () {
        $('#begin_time-btn').click(function () {
            $("#begin_time").datepicker('show');
        });

        $('#end_time-btn').click(function () {
            $("#end_time").datepicker('show');
        });

        $("#begin_time,#end_time").datepicker({
            dateFormat: "dd/mm/yy",
            changeMonth: true,
            changeYear: true,
            showOtherMonths: true,
            showOn: "focus"
        });

        // Load danh mục sản phẩm
        $.get('{$CATALOG_LINK}', function(data) {
            $('#vcatid').html(data);
        });
    });

    function nv_add_discount_item() {
        var count = $('#discount_items tr').length;
        var options = $('#discount_unit_options').html();
        var newRow = '<tr id="discount_' + count + '">';
        newRow += '<td><input class="form-control" type="number" name="config[' + count + '][discount_from]" value="" /></td>';
        newRow += '<td><input class="form-control" type="number" name="config[' + count + '][discount_to]" value="" /></td>';
        newRow += '<td><div class="input-group">';
        newRow += '<input class="form-control" type="text" name="config[' + count + '][discount_number]" value="" />';
        newRow += '<select name="config[' + count + '][discount_unit]" class="form-select w-auto">' + options + '</select>';
        newRow += '</div></td>';
        newRow += '<td class="text-center"><button type="button" class="btn btn-danger" onclick="$(\'#discount_' + count + '\').remove();"><i class="fa fa-trash"></i></button></td>';
        newRow += '</tr>';
        $('#discount_items').append(newRow);
    }
</script>