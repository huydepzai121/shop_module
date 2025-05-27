{include file="shipping_menu.tpl"}

<div class="card">
    <div class="card-header">{$LANG->getModule('carrier_list')}</div>
    <div class="card-body">
        <form action="{$smarty.const.NV_BASE_ADMINURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&amp;{$smarty.const.NV_NAME_VARIABLE}={$MODULE_NAME}&amp;{$smarty.const.NV_OP_VARIABLE}={$OP}" method="post">
            <div class="table-responsive">
                <table class="table table-striped table-bordered table-hover">
                    <colgroup>
                        <col class="w100" />
                        <col />
                        <col class="w150" />
                        <col />
                        <col span="2" class="w150" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th>{$LANG->getModule('weight')}</th>
                            <th>{$LANG->getModule('currency')}</th>
                            <th>{$LANG->getModule('order_phone')}</th>
                            <th>{$LANG->getModule('order_address')}</th>
                            <th class="text-center">{$LANG->getModule('carrier_active')}</th>
                            <th>&nbsp;</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach from=$VIEWS item=VIEW}
                        <tr>
                            <td>
                                <select class="form-control" id="id_weight_{$VIEW.id}" onchange="nv_change_weight('{$VIEW.id}');">
                                {foreach from=$VIEW.weight_options item=WEIGHT}
                                    <option value="{$WEIGHT.key}"{$WEIGHT.selected}>{$WEIGHT.title}</option>
                                {/foreach}
                                </select>
                            </td>
                            <td>{$VIEW.name}</td>
                            <td>{$VIEW.phone}</td>
                            <td>{$VIEW.address}</td>
                            <td class="text-center">
                                <div class="form-check form-switch d-flex justify-content-center">
                                    <input class="form-check-input" type="checkbox" id="change_active_{$VIEW.id}" role="switch" onclick="nv_change_active({$VIEW.id})" {$VIEW.status}>
                                </div>
                            </td>
                            <td class="text-center">
                                <a class="btn btn-success btn-sm" href="{$VIEW.link_edit}">
                                    <i class="fa fa-edit fa-lg"></i> {$LANG->getModule('edit')}
                                </a>
                                <a class="btn btn-danger btn-sm" onclick="nv_delete_carrier({$VIEW.id})">
                                    <i class="fa fa-trash-o fa-lg"></i> {$LANG->getModule('delete')}
                                </a>
                            </td>
                        </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
        </form>
    </div>
</div>

{if $ERROR}
<div class="alert alert-warning">{$ERROR}</div>
{/if}

<div class="card">
    <div class="card-header">{$CAPTION}</div>
    <div class="card-body">
        <form action="{$smarty.const.NV_BASE_ADMINURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&amp;{$smarty.const.NV_NAME_VARIABLE}={$MODULE_NAME}&amp;{$smarty.const.NV_OP_VARIABLE}={$OP}" method="post">
            <input type="hidden" name="id" value="{$ROW.id}" />
            <div class="table-responsive">
                <table class="table table-striped table-bordered table-hover">
                    <tbody>
                        <tr>
                            <td style="width: 20%;">{$LANG->getModule('currency')} <span class="red">*</span></td>
                            <td><input class="form-control" style="width: 40%;" type="text" name="name" value="{$ROW.name}" required="required" oninvalid="setCustomValidity( nv_required )" oninput="setCustomValidity('')" /></td>
                        </tr>
                        <tr>
                            <td>{$LANG->getModule('order_phone')}</td>
                            <td><input class="form-control" style="width: 40%;" type="text" name="phone" value="{$ROW.phone}" /></td>
                        </tr>
                        <tr>
                            <td>{$LANG->getModule('order_address')}</td>
                            <td><input class="form-control" style="width: 40%;" type="text" name="address" value="{$ROW.address}" /></td>
                        </tr>
                        <tr>
                            <td>{$LANG->getModule('logo')}</td>
                            <td>
                                <input class="form-control pull-left mb-3" type="text" name="logo" value="{$ROW.logo}" id="logo" />&nbsp;
                                <input type="button" value="{$LANG->getModule('browse_image')}" name="selectimg" class="btn btn-info" id="select_logo" />
                            </td>
                        </tr>
                        <tr>
                            <td>{$LANG->getModule('carrier_description')}</td>
                            <td>{$ROW.description}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div style="text-align: center">
                <input class="btn btn-primary" name="submit" type="submit" value="{$LANG->getModule('save')}" />
            </div>
        </form>
    </div>
</div>

<script type="text/javascript">
    
//<![CDATA[
    var nv_timer = null;
    function nv_change_weight(id) {
        var nv_timer = nv_settimeout_disable('id_weight_' + id, 5000);
        var new_vid = $('#id_weight_' + id).val();
        $.ajax({
            url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=carrier&nocache=' + new Date().getTime(),
            type: 'POST',
            dataType: 'json',
            data: {
                change_weight: 1,
                id: id,
                new_vid: new_vid
            },
            success: function(res) {
                if (res['status'] == 'OK') {
                    location.reload();
                }
                else {
                    alert(res['message']);
                }
            }
        });
        return;
    }

    function nv_change_active(id) {
        var new_status = $('#change_active_' + id).is(':checked') ? 1 : 0;
        var nv_timer = nv_settimeout_disable('change_active_' + id, 3000);
        $.ajax({
            url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=carrier&nocache=' + new Date().getTime(),
            type: 'POST',
            dataType: 'json',
            data: {
                change_active: 1,
                id: id,
                new_status: new_status
            },
            success: function(res) {
                if (res['status'] == 'OK') {
                    location.reload();
                } else {
                    alert(res['message']);
                }
            }
        });
    }

    function nv_delete_carrier(id) {
        if (confirm(nv_is_change_act_confirm[0])) {
            $.ajax({
                url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=carrier&nocache=' + new Date().getTime(),
                type: 'POST',
                dataType: 'json',
                data: {
                    delete_carrier: 1,
                    id: id
                },
                success: function(res) {
                    if (res['status'] == 'OK') {
                        location.reload();
                    } else {
                        alert(res['message']);
                    }
                }
            });
        }
    }

    $("#select_logo").click(function() {
        var area = "logo";
        var path = "{$UPLOAD_CURRENT}";
        var currentpath = "{$UPLOAD_CURRENT}";
        var type = "image";
        console.log(path);
        nv_open_browse(script_name + "?" + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + "=upload&popup=1&area=" + area + "&path=" + path + "&type=" + type + "&currentpath=" + currentpath, "NVImg", 850, 420, "resizable=no,scrollbars=no,toolbar=no,location=no,status=no");
        return false;
    });
//]]>
</script>
