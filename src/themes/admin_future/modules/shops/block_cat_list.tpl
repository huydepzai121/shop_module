<div class="table-responsive">
    <table class="table table-striped table-bordered table-hover">
        <colgroup>
            <col class="w50" />
            <col span="2" />
            <col class="w100" />
            <col class="w150" />
        </colgroup>
        <thead>
            <tr>
                <th class="text-center">{$LANG->getModule('weight')}</th>
                <th>{$LANG->getModule('name')}</th>
                <th class="text-center">{$LANG->getModule('adddefaultblock')}</th>
                <th class="text-center">{$LANG->getModule('function')}</th>
            </tr>
        </thead>
        <tbody>
            {foreach from=$BLOCKS item=BLOCK}
            <tr>
                <td class="text-center">
                    <select class="form-select" id="id_weight_{$BLOCK.bid}" onchange="nvChangeWeight({$BLOCK.bid})">
                        {foreach from=$BLOCK.weight_options item=WEIGHT}
                        <option value="{$WEIGHT.pos}"{if $WEIGHT.selected} selected="selected"{/if}>{$WEIGHT.pos}</option>
                        {/foreach}
                    </select>
                </td>
                <td>
                    <a href="{$BLOCK.link_edit}#edit"><strong>{$BLOCK.title}</strong></a>
                    {if !empty($BLOCK.numnews)} ({$BLOCK.numnews}){/if}
                </td>
                <td class="text-center">
                    <select class="form-select" id="change_status_{$BLOCK.bid}" onchange="nvChangeStatus({$BLOCK.bid}, this.value)">
                        {foreach from=$STATUS_OPTIONS item=STATUS}
                        <option value="{$STATUS.key}" {if $BLOCK.adddefault==$STATUS.key} selected="selected" {/if}>
                            {$STATUS.value}</option>
                        {/foreach}
                    </select>
                </td>
                <td class="text-center">
                    <a href="{$BLOCK.link_edit}#edit" class="btn btn-primary btn-xs"><i class="fa-solid fa-edit"></i></a>
                    <a href="javascript:void(0)" class="btn btn-danger btn-xs" onclick="nvDelBlock({$BLOCK.bid})"><i class="fa-solid fa-trash"></i></a>
                </td>
            </tr>
            {/foreach}
        </tbody>
    </table>
</div>

<script type="text/javascript">
    function nvChangeWeight(bid) {
        var nv_timer = nv_settimeout_disable('id_weight_' + bid, 5000);
        var new_weight = $('#id_weight_' + bid).val();
        $.ajax({
            type: 'POST',
            url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=blockcat&nocache=' + new Date().getTime(),
            data: 'changeweight=1&bid=' + bid + '&new_weight=' + new_weight,
            success: function (result) {
                if (result != 'OK') {
                    alert(nv_is_change_act_confirm[2]);
                }
                clearTimeout(nv_timer);
                window.location.href = window.location.href;
            }
        });
    }

    function nvChangeStatus(bid, new_status) {
        if (confirm(nv_is_change_act_confirm[0])) {
            var nv_timer = nv_settimeout_disable('change_status_' + bid, 5000);
            $.ajax({
                type: 'POST',
                url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=blockcat&nocache=' + new Date().getTime(),
                data: 'changeactive=1&bid=' + bid + '&new_status=' + new_status,
                success: function (result) {
                    if (result != 'OK') {
                        alert(nv_is_change_act_confirm[2]);
                        $('#change_status_' + bid).val(new_status == 1 ? 0 : 1);
                    }
                    clearTimeout(nv_timer);
                }
            });
        } else {
            $('#change_status_' + bid).val(new_status == 1 ? 0 : 1);
        }
    }

    function nvDelBlock(bid) {
        if (confirm(nv_is_del_confirm[0])) {
            $.ajax({
                type: 'POST',
                url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=blockcat&nocache=' + new Date().getTime(),
                data: 'del=1&bid=' + bid,
                success: function (result) {
                    if (result == 'OK') {
                        window.location.href = window.location.href;
                    } else {
                        alert(nv_is_del_confirm[2]);
                    }
                }
            });
        }
    }
</script>