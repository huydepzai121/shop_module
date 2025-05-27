<link rel="stylesheet" href="{$NV_BASE_SITEURL}{$NV_ASSETS_DIR}/js/select2/select2.min.css">
<script type="text/javascript" src="{$NV_BASE_SITEURL}{$NV_ASSETS_DIR}/js/select2/select2.min.js"></script>
{if $main}
{if !empty($group_nav)}
<div class="divbor1">
    {foreach from=$group_nav item=nav name=navloop}
    <a href="{$nav.link}"><strong>{$nav.title}</strong></a>
    {if !$smarty.foreach.navloop.last} &raquo; {/if}
    {/foreach}
</div>
{/if}

{if !empty($DATA)}
<div class="table-responsive">
    <table class="table table-striped table-bordered table-hover">
        <thead>
            <tr>
                <th class="w100">{$LANG->getModule('weight')}</th>
                <th>{$LANG->getModule('group_name')}</th>
                <th>{$LANG->getModule('groupview_page')}</th>
                <th class="text-center">{$LANG->getModule('inhome')}</th>
                <th class="text-center">{$LANG->getModule('indetail')}
                    <span class="info_icon" data-toggle="tooltip" title=""
                        data-original-title="{$LANG->getModule('indetail_note')}">&nbsp;</span>
                </th>
                <th class="text-center">{$LANG->getModule('in_order')}</th>
                <th class="w150">&nbsp;</th>
            </tr>
        </thead>
        <tbody>
            {foreach from=$DATA item=ROW}
            <tr>
                <td class="text-center">
                    <select class="form-control" id="id_weight_{$ROW.groupid}"
                        onchange="nv_chang_group('{$ROW.groupid}', '{$ROW.parentid}', 'weight');">
                        {foreach from=$ROW.weight_options item=OPTION}
                        <option value="{$OPTION.key}" {$OPTION.selected}>{$OPTION.title}</option>
                        {/foreach}
                    </select>
                </td>
                <td>
                    <a data-toggle="tooltip" title="" data-original-title="{$ROW.description}" href="{$ROW.group_link}">
                        <strong>{$ROW.title}</strong>
                    </a>
                    {$ROW.numsubgroup}
                </td>
                <td>
                    <select class="form-control" id="id_viewgroup_{$ROW.groupid}"
                        onchange="nv_chang_group('{$ROW.groupid}', '{$ROW.parentid}', 'viewgroup');">
                        {foreach from=$ROW.viewgroup_options item=OPTION}
                        <option value="{$OPTION.key}" {$OPTION.selected}>{$OPTION.title}</option>
                        {/foreach}
                    </select>
                </td>
                <td class="text-center">
                    <select class="form-control" id="id_inhome_{$ROW.groupid}"
                        onchange="nv_chang_group('{$ROW.groupid}', '{$ROW.parentid}', 'inhome');">
                        {foreach from=$ROW.inhome_options item=OPTION}
                        <option value="{$OPTION.key}" {$OPTION.selected}>{$OPTION.title}</option>
                        {/foreach}
                    </select>
                </td>
                <td class="text-center">
                    <select class="form-control" id="id_indetail_{$ROW.groupid}"
                        onchange="nv_chang_group('{$ROW.groupid}', '{$ROW.parentid}', 'indetail');">
                        {foreach from=$ROW.indetail_options item=OPTION}
                        <option value="{$OPTION.key}" {$OPTION.selected}>{$OPTION.title}</option>
                        {/foreach}
                    </select>
                </td>
                <td class="text-center">
                    <select class="form-control" id="id_in_order_{$ROW.groupid}"
                        onchange="nv_chang_group('{$ROW.groupid}', '{$ROW.parentid}', 'in_order');">
                        {foreach from=$ROW.in_order_options item=OPTION}
                        <option value="{$OPTION.key}" {$OPTION.selected}>{$OPTION.title}</option>
                        {/foreach}
                    </select>
                </td>
                <td class="text-center">
                    <i class="fa fa-edit fa-lg">&nbsp;</i>
                    <a
                        href="{$NV_BASE_ADMINURL}index.php?{$NV_LANG_VARIABLE}={$NV_LANG_DATA}&amp;{$NV_NAME_VARIABLE}={$MODULE_NAME}&amp;{$NV_OP_VARIABLE}=group&amp;groupid={$ROW.groupid}&amp;parentid={$ROW.parentid}#edit">{$LANG->getGlobal('edit')}</a>
                    &nbsp; - <i class="fa fa-trash-o fa-lg">&nbsp;</i>
                    <a href="javascript:void(0);"
                        onclick="nv_del_group('{$ROW.groupid}')">{$LANG->getGlobal('delete')}</a>
                </td>
            </tr>
            {/foreach}
        </tbody>
    </table>
</div>
{/if}
{/if}

<!-- Modal xác nhận xóa -->
<div class="modal fade" id="deleteConfirmModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">{$LANG->getModule('group_delete')}</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div id="modal-message"></div>

                <div id="move-group-form" style="display:none">
                    <select class="form-control" name="groupidnews" id="groupidnews">
                        <option value="0">-- {$LANG->getModule('group_select')} --</option>
                        {foreach from=$GROUPS item=GROUP}
                        <option value="{$GROUP.groupid}">{$GROUP.title}</option>
                        {/foreach}
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <div id="delete-confirm">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">
                        {$LANG->getGlobal('cancel')}
                    </button>
                    <button type="button" class="btn btn-danger" onclick="nv_del_group_confirm()">
                        {$LANG->getGlobal('delete')}
                    </button>
                </div>

                <div id="delete-buttons" style="display:none">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">
                        {$LANG->getGlobal('cancel')}
                    </button>
                    <button type="button" class="btn btn-primary" onclick="nv_del_group_submit(1)">
                        {$LANG->getModule('group_move_items')}
                    </button>
                    <button type="button" class="btn btn-danger" onclick="nv_del_group_submit(2)">
                        {$LANG->getModule('group_delete_items')}
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    var current_groupid = 0;

    function nv_del_group(groupid) {
        current_groupid = groupid;
        $('#move-group-form').hide();
        $('#delete-buttons').hide();
        $('#delete-confirm').show();
        $('#modal-message').text('{$LANG->getModule('group_delete_confirm')}');
        $('#deleteConfirmModal').modal('show');
    }

    function nv_del_group_confirm() {
        $.ajax({
            type: 'POST',
            url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=group',
            data: {
                groupid: current_groupid,
                delete_group: 1
            },
            dataType: 'json',
            success: function (res) {
                if (res.error == 0) {
                    window.location.href = script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=group&parentid=' + res.parentid;
                } else if (res.error == 2) {
                    $('#modal-message').html(res.msg);
                    $('#move-group-form').show();
                    $('#delete-buttons').show();
                    $('#delete-confirm').hide();

                    $('#groupidnews').select2({
                        dropdownParent: $('#deleteConfirmModal')
                    });
                } else {
                    $('#modal-message').html(res.msg);
                    $('#delete-confirm').hide();
                }
            }
        });
    }

    function nv_del_group_submit(action) {
        var groupidnews = $('#groupidnews').val();

        if (action == 1 && groupidnews == 0) {
            alert('{$LANG->getModule('group_move_select_empty')}');
            return;
        }

        $.ajax({
            type: 'POST',
            url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=group',
            data: {
                groupid: current_groupid,
                action: action,
                groupidnews: groupidnews,
                delete_group: 1
            },
            dataType: 'json',
            success: function (res) {
                if (res.error == 0) {
                    window.location.href = script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=group&parentid=' + res.parentid;
                } else {
                    $('#modal-message').html(res.msg);
                }
            }
        });
    }

    function nv_chang_group(groupid, parentid, mod) {
        var nv_timer = nv_settimeout_disable('id_' + mod + '_' + groupid, 5000);
        var new_vid = $('#id_' + mod + '_' + groupid).val();
        $.ajax({
            type: 'POST',
            url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=group',
            data: {
                groupid: groupid,
                mod: mod,
                newvid: new_vid,
                parentid: parentid
            },
            dataType: 'json',
            success: function (res) {
                if (res.status == 'success') {
                    location.reload();
                } else {
                    alert(res.message);
                }
            }
        });
    }

    $(document).ready(function () {
        $('#groupidnews').select2({
            dropdownParent: $('#deleteConfirmModal')
        });
    });
</script>