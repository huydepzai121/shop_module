<link rel="stylesheet" href="{$NV_BASE_SITEURL}{$NV_ASSETS_DIR}/js/select2/select2.min.css">
<script type="text/javascript" src="{$NV_BASE_SITEURL}{$NV_ASSETS_DIR}/js/select2/select2.min.js"></script>
<div class="table-responsive">
    <table class="table table-striped table-bordered table-hover">
        <thead>
            <tr class="text-center">
                <th class="w100">{$LANG->getModule('weight')}</th>
                <th>{$LANG->getModule('catalog_name')}</th>
                <th class="w150">{$LANG->getModule('inhome')}</th>
                <th>{$LANG->getModule('viewcat_page')}</th>
                <th class="w100">{$LANG->getModule('numlinks')}</th>
                <th>{$LANG->getModule('newday')}</th>
                <th class="text-center w250">{$LANG->getModule('function')}</th>
            </tr>
        </thead>
        <tbody>
            {foreach from=$DATA item=ROW}
            <tr>
                <td class="text-center">
                    <select class="form-select" id="id_weight_{$ROW.catid}" onchange="nv_chang_cat('{$ROW.catid}','{$ROW.parentid}', 'weight', this);">
                        {foreach from=$ROW.weight_options item=WEIGHT}
                            <option value="{$WEIGHT.key}" {if $WEIGHT.selected} selected="selected" {/if}>{$WEIGHT.title}
                            </option>
                        {/foreach}
                    </select>
                </td>
                <td>
                    <a
                        href="{$NV_BASE_ADMINURL}index.php?{$NV_LANG_VARIABLE}={$NV_LANG_DATA}&amp;{$NV_NAME_VARIABLE}={$MODULE_NAME}&amp;{$NV_OP_VARIABLE}=cat&amp;parentid={$ROW.catid}">
                        <strong>{$ROW.title}</strong>
                    </a>
                    {$ROW.numsubcat}
                </td>
                <td class="text-center">
                    <select class="form-select" id="id_inhome_{$ROW.catid}" onchange="nv_chang_cat('{$ROW.catid}','{$ROW.parentid}', 'inhome', this);">
                        {foreach from=$ROW.inhome_options item=INHOME}
                        <option value="{$INHOME.key}" {$INHOME.selected}>{$INHOME.title}</option>
                        {/foreach}
                    </select>
                </td>
                <td>
                    <select class="form-select" id="id_viewcat_{$ROW.catid}"
                        onchange="nv_chang_cat('{$ROW.catid}','{$ROW.parentid}', 'viewcat', this);">
                        {foreach from=$ROW.viewcat_options item=VIEWCAT}
                        <option value="{$VIEWCAT.key}" {$VIEWCAT.selected}>{$VIEWCAT.title}</option>
                        {/foreach}
                    </select>
                </td>
                <td class="text-center">
                    <select class="form-select" id="id_numlinks_{$ROW.catid}"
                        onchange="nv_chang_cat('{$ROW.catid}','{$ROW.parentid}', 'numlinks', this);">
                        {foreach from=$ROW.numlinks_options item=NUMLINKS}
                        <option value="{$NUMLINKS.key}" {$NUMLINKS.selected}>{$NUMLINKS.title}</option>
                        {/foreach}
                    </select>
                </td>
                <td class="text-center">
                    <select class="form-select" id="id_newday_{$ROW.catid}"
                        onchange="nv_chang_cat('{$ROW.catid}','{$ROW.parentid}', 'newday', this);">
                        {foreach from=$ROW.newday_options item=NEWDAY}
                        <option value="{$NEWDAY.key}" {$NEWDAY.selected}>{$NEWDAY.title}</option>
                        {/foreach}
                    </select>
                </td>
                <td class="text-center">
                    <i class="fa fa-plus fa-lg">&nbsp;</i>
                    <a
                        href="{$NV_BASE_ADMINURL}index.php?{$NV_LANG_VARIABLE}={$NV_LANG_DATA}&amp;{$NV_NAME_VARIABLE}={$MODULE_NAME}&amp;{$NV_OP_VARIABLE}=content&amp;catid={$ROW.catid}&amp;parentid={$ROW.parentid}">
                        {$LANG->getModule('content_add')}
                    </a>
                    &nbsp;
                    <i class="fa fa-edit fa-lg">&nbsp;</i>
                    <a
                        href="{$NV_BASE_ADMINURL}index.php?{$NV_LANG_VARIABLE}={$NV_LANG_DATA}&amp;{$NV_NAME_VARIABLE}={$MODULE_NAME}&amp;{$NV_OP_VARIABLE}=cat&amp;catid={$ROW.catid}&amp;parentid={$ROW.parentid}#edit">
                        {$LANG->getGlobal('edit')}
                    </a>
                    &nbsp;
                    <i class="fa fa-trash-o fa-lg">&nbsp;</i>
                    <a href="javascript:void(0)" onclick="nv_del_cat({$ROW.catid})">
                        {$LANG->getGlobal('delete')}
                    </a>
                </td>
            </tr>
            {/foreach}
        </tbody>
    </table>
</div>
<!-- Modal xác nhận xóa -->
<div class="modal fade" id="deleteConfirmModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">{$LANG->getModule('cat_delete')}</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p id="modal-message"></p>
                <div id="move-category-form" style="display:none">
                    <div class="form-group mb-3">
                        <label class="form-label">{$LANG->getModule('cat_move_to')}</label>
                        <div class="col-sm-12 col-lg-12 col-xxl-12">
                            <select class="form-control select2" name="catidnews" id="catidnews" style="width: 100%">
                                <option value="0" data-label="1">---{$LANG->getModule('cat_move_select')}---</option>
                                {foreach from=$CATS item=CAT}
                                <option value="{$CAT.catid}" data-level="{$CAT.lev}">{$CAT.title}</option>
                                {/foreach}
                            </select>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary"
                    data-bs-dismiss="modal">{$LANG->getModule('cancel')}</button>
                <div id="delete-buttons" style="display:none">
                    <button type="button" class="btn btn-primary"
                        onclick="nv_del_cat_submit(1)">{$LANG->getModule('cat_delete_and_move')}</button>
                    <button type="button" class="btn btn-danger"
                        onclick="nv_del_cat_submit(2)">{$LANG->getModule('cat_delete_and_del')}</button>
                </div>
                <button type="button" id="delete-confirm" class="btn btn-danger"
                    onclick="nv_del_cat_confirm()">{$LANG->getModule('delete')}</button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    var current_catid = 0;

    function nv_del_cat(catid) {
        current_catid = catid;
        $('#move-category-form').hide();
        $('#delete-buttons').hide();
        $('#delete-confirm').show();
        $('#modal-message').text('{$LANG->getModule('cat_delete_confirm')}');
        $('#deleteConfirmModal').modal('show');
    }

    function nv_del_cat_confirm() {
        $.ajax({
            type: 'POST',
            url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=cat',
            data: {
                catid: current_catid,
                delete_group: 1
            },
            dataType: 'json',
            success: function (res) {
                if (res.error == 0) {
                    window.location.href = script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=cat&parentid=' + res.parentid;
                } else if (res.error == 2) {
                    // Có sản phẩm, hiển thị form di chuyển
                    $('#modal-message').html(res.msg);
                    $('#move-category-form').show();
                    $('#delete-buttons').show();
                    $('#delete-confirm').hide();

                    $('#catidnews').select2({
                        dropdownParent: $('#deleteConfirmModal')
                    });
                } else {
                    $('#modal-message').html(res.msg);
                    $('#delete-confirm').hide();
                }
            }
        });
    }

    function nv_del_cat_submit(action) {
        var catidnews = $('#catidnews').val();

        if (action == 1 && catidnews == 0) {
            alert('{$LANG->getModule('cat_move_select_empty')}');
            return;
        }

        $.ajax({
            type: 'POST',
            url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=cat',
            data: {
                catid: current_catid,
                action: action,
                catidnews: catidnews,
                delete_group: 1
            },
            dataType: 'json',
            success: function (res) {
                if (res.error == 0) {
                    window.location.href = script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=cat&parentid=' + res.parentid;
                } else {
                    $('#modal-message').html(res.msg);
                }
            }
        });
    }

    function nv_chang_cat(catid, parentid, mod, obj) {
        var nv_timer = nv_settimeout_disable('id_' + mod + '_' + catid, 5000);
        var newvid = $(obj).val();
        $.ajax({
            type: 'POST',
            url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=cat',
            data: {
                catid: catid,
                mod: mod,
                newvid: newvid,
                parentid: parentid
            },
            success: function (response) {
                if (response['status'] == 'success') {
                    location.reload();
                } else {
                    alert(response['message']);
                }
            }
        });
    }

    $(document).ready(function () {
        $('#catidnews').select2({
            dropdownParent: $('#deleteConfirmModal')
        });
    });
</script>