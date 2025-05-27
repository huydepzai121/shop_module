{if $main}
{include file="shipping_menu.tpl"}

<div class="card mb-4">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h5 class="card-title mb-0">{$LANG->getModule('shops_list')}</h5>
        <div class="card-tools">
            <a href="{$NV_BASE_ADMINURL}index.php?{$NV_LANG_VARIABLE}={$NV_LANG_DATA}&{$NV_NAME_VARIABLE}={$MODULE_NAME}&{$NV_OP_VARIABLE}={$OP}#add"
                class="btn btn-primary btn-sm">
                <i class="fa fa-plus"></i> {$LANG->getModule('shops_add')}
            </a>
        </div>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-striped table-bordered table-hover">
                <thead>
                    <tr>
                        <th class="w100">{$LANG->getModule('weight')}</th>
                        <th>{$LANG->getModule('shops_name')}</th>
                        <th>{$LANG->getModule('shops_location')}</th>
                        <th class="w150 text-center">{$LANG->getModule('active')}</th>
                        <th class="w200 text-center">{$LANG->getModule('action')}</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$DATA item=VIEW}
                    <tr>
                        <td>
                            <select class="form-select" id="id_weight_{$VIEW.id}"
                                onchange="nv_chang_weight({$VIEW.id});">
                                {foreach from=$VIEW.weight_options item=WEIGHT}
                                <option value="{$WEIGHT.key}" {$WEIGHT.selected}>{$WEIGHT.title}</option>
                                {/foreach}
                            </select>
                        </td>
                        <td>{$VIEW.name}</td>
                        <td>{$VIEW.location_string}</td>
                        <td class="text-center">
                            <div class="form-check form-switch d-flex justify-content-center">
                                <input class="form-check-input" type="checkbox" id="change_active_{$VIEW.id}"
                                    onclick="nv_change_status({$VIEW.id})" {$VIEW.status}>
                            </div>
                        </td>
                        <td class="text-center">
                            <div class="btn-group">
                                <a class="btn btn-primary btn-sm" href="{$VIEW.link_edit}">
                                    <i class="fa fa-edit"></i> {$LANG->getModule('edit')}
                                </a>
                                <button class="btn btn-danger btn-sm" onclick="nv_del_shop('{$VIEW.id}', '{$VIEW.delete_checkss}')">
                                    <i class="fa fa-trash"></i> {$LANG->getModule('delete')}
                                </button>
                            </div>
                        </td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>
    </div>
</div>

<div class="card">
    <div class="card-header">
        <h5 class="card-title mb-0">{if
            $ROW.id}{$LANG->getModule('shops_edit')}{else}{$LANG->getModule('shops_add')}{/if}</h5>
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
                        <label class="form-label required">{$LANG->getModule('shops_name')}</label>
                        <input class="form-control" type="text" name="name" value="{$ROW.name}" required="required" />
                    </div>

                    <div class="form-group mb-3">
                        <label class="form-label required">{$LANG->getModule('shops_location')}</label>
                        <select name="location" class="form-select">
                            <option value="">---{$LANG->getModule('location_chose')}---</option>
                            {foreach from=$LOCATIONS item=LOCATION}
                            <option value="{$LOCATION.id}" {$LOCATION.selected}>{$LOCATION.title}</option>
                            {/foreach}
                        </select>
                        <input class="form-control mt-2" type="text" name="address" value="{$ROW.address}"
                            placeholder="{$LANG->getModule('address_detail')}" />
                    </div>

                    <div class="form-group mb-3">
                        <label class="form-label required">{$LANG->getModule('carrier_config')}</label>
                        <div class="table-responsive">
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>{$LANG->getModule('carrier')}</th>
                                        <th>{$LANG->getModule('carrier_config')}</th>
                                        <th style="width: 60px" class="text-center"></th>
                                    </tr>
                                </thead>
                                <tbody id="config-container">
                                    {foreach from=$CONFIGS item=CONFIG}
                                    <tr id="config_{$CONFIG.id}">
                                        <td>
                                            <select name="config_carrier[{$CONFIG.id}][carrier]" class="form-select">
                                                <option value="">---{$LANG->getModule('carrier_chose')}---</option>
                                                {foreach from=$CONFIG.carriers item=CARRIER}
                                                <option value="{$CARRIER.key}" {$CARRIER.selected}>{$CARRIER.value}
                                                </option>
                                                {/foreach}
                                            </select>
                                        </td>
                                        <td>
                                            <select name="config_carrier[{$CONFIG.id}][config]" class="form-select">
                                                <option value="">---{$LANG->getModule('carrier_config_chose')}---
                                                </option>
                                                {foreach from=$CONFIG.carrier_configs item=CARRIER_CONFIG}
                                                <option value="{$CARRIER_CONFIG.id}" {$CARRIER_CONFIG.selected}>
                                                    {$CARRIER_CONFIG.title}</option>
                                                {/foreach}
                                            </select>
                                        </td>
                                        <td class="text-center">
                                            <button type="button" class="btn btn-danger btn-sm"
                                                onclick="$('#config_{$CONFIG.id}').remove()">
                                                <i class="fa fa-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    {/foreach}
                                </tbody>
                            </table>
                        </div>
                        <div class="text-end">
                            <button type="button" class="btn btn-info btn-sm" onclick="nv_add_carrier_config()">
                                <i class="fa fa-plus"></i> {$LANG->getModule('carrier_config_add')}
                            </button>
                        </div>
                    </div>

                    <div class="form-group mb-3">
                        <label class="form-label">{$LANG->getModule('shops_description')}</label>
                        {$ROW.description}
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
    var config_carrier_count = { $config_carrier_count };

    function nv_chang_weight(id) {
        var new_weight = $('#id_weight_' + id).val();
        $.ajax({
            type: 'POST',
            url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=shops&nocache=' + new Date().getTime(),
            data: {
                'ajax_action': 1,
                'id': id,
                'new_vid': new_weight
            },
            success: function (res) {
                if (res['status'] == 'OK') {
                    location.reload();
                } else {
                    alert(nv_is_change_act_confirm[2]);
                }
            }
        });
    }

    function nv_change_status(id) {
        var new_status = $('#change_active_' + id).is(':checked') ? 1 : 0;
        if (confirm(nv_is_change_act_confirm[0])) {
            $.ajax({
                type: 'POST',
                url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=shops&nocache=' + new Date().getTime(),
                data: {
                    'change_active': 1,
                    'id': id,
                    'new_status': new_status
                },
                success: function (res) {
                    if (res['status'] == 'OK') {
                        location.reload();
                    } else {
                        alert(nv_is_change_act_confirm[2]);
                    }
                }
            });
        } else {
            $('#change_active_' + id).prop('checked', !new_status);
        }
    }

    function nv_del_shop(id, delete_checkss) {
        if (confirm(nv_is_del_confirm[0])) {
            $.ajax({
                type: 'POST',
                url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=shops&nocache=' + new Date().getTime(),
                data: {
                    'delete_id': id,
                    'delete_checkss': delete_checkss
                },
                success: function (res) {
                    if (res['status'] == 'OK') {
                        location.reload();
                    } else {
                        alert(nv_is_del_confirm[2]);
                    }
                }
            });
        }
    }

    function nv_add_carrier_config() {
        var html = '<tr id="config_' + config_carrier_count + '">';
        html += '<td>';
        html += '<select name="config_carrier[' + config_carrier_count + '][carrier]" class="form-select">';
        html += '<option value="">---{$LANG->getModule('carrier_chose')}---</option>';
        {foreach from = $global_array_carrier key = carrier_id item = carrier }
        html += '<option value="{$carrier_id}">{$carrier.name}</option>';
        {/foreach }
        html += '</select>';
        html += '</td>';
        html += '<td>';
        html += '<select name="config_carrier[' + config_carrier_count + '][config]" class="form-select">';
        html += '<option value="">---{$LANG->getModule('carrier_config_chose')}---</option>';
        {foreach from = $global_array_carrier_config key = config_id item = config }
        html += '<option value="{$config_id}">{$config.title}</option>';
        {/foreach }
        html += '</select>';
        html += '</td>';
        html += '<td class="text-center">';
        html += '<button type="button" class="btn btn-danger btn-sm" onclick="$(\'#config_' + config_carrier_count + '\').remove()">';
        html += '<i class="fa fa-trash"></i>';
        html += '</button>';
        html += '</td>';
        html += '</tr>';

        $('#config-container').append(html);
        config_carrier_count++;
    }
</script>
{/if}