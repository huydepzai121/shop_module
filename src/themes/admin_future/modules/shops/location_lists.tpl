{if !empty($location_nav)}
<div class="divbor1">
    {foreach from=$location_nav item=NAV name=navloop}
    <a href="{$NAV.link}"><strong>{$NAV.title}</strong></a>
    {if !$smarty.foreach.navloop.last} &raquo; {/if}
    {/foreach}
</div>
{/if}

{if !empty($DATA)}
<div class="table-responsive">
    <table class="table table-striped table-bordered table-hover">
        <thead>
            <tr>
                <th style="width: 5%;">{$LANG->getModule('weight')}</th>
                <th style="width: 80%;">{$LANG->getModule('location_name')}</th>
                <th style="width: 150px;">&nbsp;</th>
            </tr>
        </thead>
        <tbody>
            {foreach from=$DATA item=ROW}
            <tr>
                <td class="text-center">
                    <select class="form-control" id="id_weight_{$ROW.id}"
                        onchange="nv_chang_location('{$ROW.id}', 'weight','{$ROW.parentid}')">
                        {foreach from=$ROW.weight_options item=WEIGHT}
                        <option value="{$WEIGHT.key}" {$WEIGHT.selected}>{$WEIGHT.title}</option>
                        {/foreach}
                    </select>
                </td>
                <td>
                    <a href="{$ROW.link}"><strong>{$ROW.title}</strong></a>
                    {$ROW.numsub}
                </td>
                <td class="text-center">
                    <div class="btn-group">
                        <a class="btn btn-primary btn-sm" href="{$ROW.edit_link}">
                            <i class="fa fa-edit"></i> {$LANG->getGlobal('edit')}
                        </a>
                        <button class="btn btn-danger btn-sm" onclick="nv_del_location({$ROW.id},'del',{$ROW.parentid})">
                            <i class="fa fa-trash"></i> {$LANG->getGlobal('delete')}
                        </button>
                    </div>
                </td>
            </tr>
            {/foreach}
        </tbody>
        {if !empty($GENERATE_PAGE)}
        <tfoot>
            <tr>
                <td colspan="3" class="text-center">
                    {$GENERATE_PAGE}
                </td>
            </tr>
        </tfoot>
        {/if}
    </table>
</div>
<script type="text/javascript">
    function nv_chang_location(locationid, mod, parentid) {
        var nv_timer = nv_settimeout_disable('id_' + mod + '_' + locationid, 5000);
        var new_vid = $('#id_' + mod + '_' + locationid).val();
        $.ajax({
            url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=location&nocache=' + new Date().getTime(),
            type: 'POST',
            data: {
                locationid: locationid,
                mod: mod,
                new_vid: new_vid,
                parentid: parentid
            },
            success: function (res) {
                console.log(res);
                if (res['status'] == 'OK') {
                    location.reload();
                } else {
                    alert(res['mess']);
                }
            }
        });
    }

    function nv_show_list_location(parentid) {
        if (document.getElementById('module_show_list')) {
            $('#module_show_list').load(
                script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=location&parentid=' + parentid + '&nocache=' + new Date().getTime()
            );
        }
        return;
    }

    function nv_del_location(locationid, mod, parentid) {
        if (confirm(nv_is_del_confirm[0])) {
            $.ajax({
                url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=location&nocache=' + new Date().getTime(),
                type: 'POST',
                data: {
                    locationid: locationid,
                    mod: mod,
                    parentid: parentid
                },
                success: function (res) {
                    console.log(res);
                    if (res['status'] == 'OK') {
                        location.reload();
                    } else {
                        alert(res['mess']);
                    }
                }
            });
        }
        return false;
    }

    $(document).ready(function () {
        // Xử lý thay đổi thứ tự
        $('[id^="change_weight_"]').change(function () {
            var id = $(this).attr('id').replace('change_weight_', '');
            nv_chang_location(id, 'weight');
        });
    });
</script>
{/if}