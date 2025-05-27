{* Template for displaying block list *}
<form name="block_list">
    <div class="table-responsive">
        <table class="table table-striped table-hover">
            <colgroup>
                <col class="w50" />
                <col class="w100" />
                <col />
                <col class="w100" />
                <col class="w250" />
            </colgroup>
            <thead>
                <tr>
                    <th class="text-center">
                        <div class="form-check">
                            <input class="form-check-input" name="check_all[]" type="checkbox" value="yes" onclick="nv_checkAll(this.form, 'idcheck[]', 'check_all[]',this.checked);">
                        </div>
                    </th>
                    <th>{$LANG->getModule('weight')}</th>
                    <th>{$LANG->getModule('name')}</th>
                    <th class="text-center">{$LANG->getModule('status')}</th>
                    <th>&nbsp;</th>
                </tr>
            </thead>
            <tbody>
                {foreach from=$DATA item=ROW}
                <tr>
                    <td class="text-center">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" onclick="nv_UncheckAll(this.form, 'idcheck[]', 'check_all[]', this.checked);" value="{$ROW.id}" name="idcheck[]">
                        </div>
                    </td>
                    <td class="text-center">
                        <select class="form-select" id="id_weight_{$ROW.id}" onchange="nv_change_weight({$ROW.id});">
                            {foreach from=$ROW.weight_options item=WEIGHT}
                            <option value="{$WEIGHT.key}" {$WEIGHT.selected}>{$WEIGHT.title}</option>
                            {/foreach}
                        </select>
                    </td>
                    <td><a target="_blank" href="{$ROW.link}">{$ROW.title}</a></td>
                    <td class="text-center">{$ROW.status}</td>
                    <td class="text-center">
                        <a class="btn btn-primary btn-xs" href="{$smarty.const.NV_BASE_ADMINURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&amp;{$smarty.const.NV_NAME_VARIABLE}={$MODULE_NAME}&amp;{$smarty.const.NV_OP_VARIABLE}=content&amp;id={$ROW.id}">
                            <em class="fa fa-edit fa-fw"></em>{$LANG->getModule('edit')}
                        </a>
                        <a class="btn btn-danger btn-xs" href="javascript:void(0);" onclick="nv_chang_block_shops({$BID}, {$ROW.id}, {$ROW.id}, 'delete');">
                            <em class="fa fa-trash-o fa-fw"></em>{$LANG->getModule('delete_from_block')}
                        </a>
                    </td>
                </tr>
                {/foreach}
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="5">
                        <button type="button" class="btn btn-danger" onclick="nv_del_block_list(this.form, {$BID})">
                            {$LANG->getModule('delete_from_block')}
                        </button>
                    </td>
                </tr>
            </tfoot>
        </table>
    </div>
</form>
<script>
    function nv_change_weight(id) {
        var nv_timer = nv_settimeout_disable('id_weight_' + id, 5000);
        var new_vid = $('#id_weight_' + id).val();
        $.ajax({
            type: 'POST',
            url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=block&nocache=' + new Date().getTime(),
            data: {
                change_weight: 1,
                id: id,
                new_vid: new_vid
            },
            success: function(res) {
                console.log(res);
                if (res['status'] == 'success') {
                    location.reload();
                } else {
                    alert(res['message']);
                }
            }
        });
    }
</script>
