{if $main}
{include file="shipping_menu.tpl"}

<!-- Phần danh sách -->
<div class="card mb-4">
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-striped table-bordered table-hover">
                <thead>
                    <tr>
                        <th class="w100">{$LANG->getModule('weight')}</th>
                        <th>{$LANG->getModule('carrier_config_name')}</th>
                        <th class="text-center">{$LANG->getModule('active')}</th>
                        <th class="w200">&nbsp;</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$VIEW item=ROW}
                    <tr>
                        <td>
                            <select class="form-select" id="id_weight_{$ROW.id}" onchange="nv_chang_weight({$ROW.id});">
                                {foreach from=$ROW.weight_options item=WEIGHT}
                                <option value="{$WEIGHT.key}" {$WEIGHT.selected}>{$WEIGHT.title}</option>
                                {/foreach}
                            </select>
                        </td>
                        <td>{$ROW.title}</td>
                        <td class="text-center">
                            <div class="form-check form-switch d-flex justify-content-center">
                                <input class="form-check-input" type="checkbox" id="change_status_{$ROW.id}"
                                    onclick="nv_change_status({$ROW.id})" {if $ROW.status}checked{/if}>
                            </div>
                        </td>
                        <td class="text-center">
                            <div class="btn-group">
                                <a class="btn btn-info btn-sm" href="{$ROW.link_config_items}">
                                    <i class="fa fa-cogs"></i> {$LANG->getModule('detail_info')}
                                </a>
                                <a class="btn btn-primary btn-sm" href="{$ROW.link_edit}">
                                    <i class="fa fa-edit"></i> {$LANG->getModule('edit')}
                                </a>
                                <button class="btn btn-danger btn-sm" onclick="nv_del_carrier_config('{$ROW.id}', '{$ROW.delete_checkss}')">
                                    <i class="fa fa-trash"></i> {$LANG->getModule('delete')}
                                </button>
                            </div>
                        </td>
                    </tr>
                    {/foreach}
                </tbody>
                {if !empty($GENERATE_PAGE)}
                <tfoot>
                    <tr>
                        <td colspan="4" class="text-center">{$GENERATE_PAGE}</td>
                    </tr>
                </tfoot>
                {/if}
            </table>
        </div>
    </div>
</div>

<!-- Form thêm/sửa -->
<div class="card">
    <div class="card-header">
        <h3 class="card-title">{$CAPTION}</h3>
    </div>
    <div class="card-body">
        {if !empty($ERROR)}
        <div class="alert alert-warning">{$ERROR}</div>
        {/if}

        <form
            action="{$NV_BASE_ADMINURL}index.php?{$NV_LANG_VARIABLE}={$NV_LANG_DATA}&{$NV_NAME_VARIABLE}={$MODULE_NAME}&{$NV_OP_VARIABLE}={$OP}"
            method="post">
            <input type="hidden" name="id" value="{$ROW.id}" />
            <div class="row">
                <div class="col-md-18">
                    <div class="form-group mb-3">
                        <label class="form-label required">{$LANG->getModule('carrier_config_name')}</label>
                        <input class="form-control" type="text" name="title" value="{$ROW.title}" required="required"
                            oninvalid="setCustomValidity(nv_required)" oninput="setCustomValidity('')" />
                    </div>

                    <div class="form-group mb-3">
                        <label class="form-label">{$LANG->getModule('carrier_config_description')}</label>
                        <textarea class="form-control" name="description" rows="5">{$ROW.description}</textarea>
                    </div>
                </div>
            </div>
            <div class="text-center">
                <button class="btn btn-primary" type="submit" name="submit">
                    <i class="fa fa-save"></i> {$LANG->getModule('save')}
                </button>
            </div>
        </form>
    </div>
</div>

<script type="text/javascript">
    var nv_timer = null;
    function nv_chang_weight(id) {
        var nv_timer = nv_settimeout_disable('id_weight_' + id, 5000);
        var new_vid = $('#id_weight_' + id).val();
        $.ajax({
            type: 'POST',
            url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=carrier_config&nocache=' + new Date().getTime(),
            data: {
                'change_weight': 1,
                'id': id,
                'new_vid': new_vid
            },
            success: function (res) {
                if (res['status'] == 'OK') {
                    location.reload();
                } else {
                    alert(res['message']);
                }
            }
        });
    }

    function nv_change_status(id) {
        var new_status = $('#change_status_' + id).is(':checked') ? 1 : 0;
        var nv_timer = nv_settimeout_disable('change_status_' + id, 3000);
        $.ajax({
            type: 'POST',
                url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=carrier_config&nocache=' + new Date().getTime(),
                data: {
                    'change_status': 1,
                    'id': id,
                    'new_status': new_status
                },
                success: function (res) {
                    if (res['status'] == 'OK') {
                        location.reload();
                    } else {
                        alert(res['message']);
                    }
                }
        });
    }

    function nv_del_carrier_config(id, delete_checkss) {
        if (confirm(nv_is_del_confirm[0])) {
            $.ajax({
                type: 'POST',
                url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=carrier_config&nocache=' + new Date().getTime(),
                data: {
                    'delete_id': id,
                    'delete_checkss': delete_checkss
                },
                success: function (res) {
                    if (res['status'] == 'OK') {
                        location.reload();
                    } else {
                        alert(res['message']);
                    }
                }
            });
        }
    }
</script>
{/if}