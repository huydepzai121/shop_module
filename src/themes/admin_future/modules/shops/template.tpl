<!-- BEGIN: main -->
<div class="row mb-3">
    <div class="col-24">
        <div class="d-flex justify-content-between">
            <div>
                <a href="{$TEM_ADD}" class="btn btn-primary">
                    <i class="fa fa-plus"></i> {$LANG->getModule('template_add')}
                </a>
            </div>
            <div class="dropdown">
                <button type="button" class="btn btn-primary" id="field">
                    {$LANG->getModule('field_id')}
                </button>
                <button type="button" class="btn btn-primary dropdown-toggle" data-bs-toggle="dropdown">
                    <i class="fa fa-caret-down"></i>
                </button>
                <ul class="dropdown-menu">
                    <li>
                        <a class="dropdown-item" href="{$FIELD_ADD}">
                            <i class="fa fa-plus fa-fw"></i> {$LANG->getModule('captionform_add')}
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</div>

{if !empty($DATA_LIST)}
<div class="card">
    <div class="card-body">
        <form action="" method="post">
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th class="w50 text-center">
                                <input type="checkbox" class="form-check-input" value="yes" name="check_all[]"
                                    onclick="nv_checkAll(this.form, 'idcheck[]', 'check_all[]',this.checked);">
                            </th>
                            <th class="w100">{$LANG->getModule('weight')}</th>
                            <th>{$LANG->getModule('template_name')}</th>
                            <th class="w150 text-center">{$LANG->getModule('status')}</th>
                            <th class="w200 text-center">{$LANG->getModule('function')}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach from=$DATA_LIST item=ROW}
                        <tr id="row_{$ROW.id}">
                            <td class="text-center">
                                <input type="checkbox" class="form-check-input" name="idcheck[]" value="{$ROW.id}">
                            </td>
                            <td>
                                <select class="form-select" id="change_weight_{$ROW.id}" onchange="nv_chang_weight({$ROW.id});">
                                    {foreach from=$ROW.weight_options item=WEIGHT}
                                    <option value="{$WEIGHT.key}" {$WEIGHT.selected}>{$WEIGHT.title}</option>
                                    {/foreach}
                                </select>
                            </td>
                            <td>
                                <a href="{$ROW.link_field_tab}">{$ROW.title}</a>
                            </td>
                            <td class="text-center">
                                <div class="form-check form-switch d-flex justify-content-center">
                                    <input class="form-check-input" type="checkbox" id="change_active_{$ROW.id}"
                                        onclick="nv_change_status({$ROW.id})" {if $ROW.status}checked{/if}>
                                </div>
                            </td>
                            <td class="text-center">
                                <a class="btn btn-primary btn-sm" href="{$ROW.link_edit}"
                                    title="{$LANG->getGlobal('edit')}">
                                    <i class="fa fa-edit"></i>
                                </a>
                                <a class="btn btn-danger btn-sm" href="javascript:void(0);"
                                    onclick="nv_del_template({$ROW.id})" title="{$LANG->getGlobal('delete')}">
                                    <i class="fa fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                        {/foreach}
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="5">
                                <div class="d-flex gap-2">
                                    <button type="button" class="btn btn-secondary btn-sm"
                                        onclick="nv_checkAll(this.form, 'idcheck[]', 'check',true);">
                                        <i class="fa fa-check-square-o"></i> {$LANG->getModule('prounit_select')}
                                    </button>
                                    <button type="button" class="btn btn-secondary btn-sm"
                                        onclick="nv_checkAll(this.form, 'idcheck[]', 'check',false);">
                                        <i class="fa fa-square-o"></i> {$LANG->getModule('prounit_unselect')}
                                    </button>
                                    <button type="button" class="btn btn-danger btn-sm" id="delall">
                                        <i class="fa fa-trash"></i> {$LANG->getModule('prounit_del_select')}
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </form>
    </div>
</div>
{/if}

{if !empty($ERROR)}
<div class="alert alert-danger">{$ERROR}</div>
{/if}

<div class="card">
    <div class="card-header">
        <h3 class="card-title">{$CAPTION}</h3>
    </div>
    <div class="card-body">
        <form action="" method="post" id="add">
            <input type="hidden" name="savecat" value="1" />
            <div class="row">
                <div class="col-md-18">
                    <div class="form-group">
                        <label class="form-label required">{$LANG->getModule('template_name')}</label>
                        <input class="form-control" name="title" type="text" value="{$DATA.title}" maxlength="150"
                            required="required" oninvalid="setCustomValidity(nv_required)"
                            oninput="setCustomValidity('')" />
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="form-label">&nbsp;</label>
                        <div class="form-control-plaintext">
                            <button class="btn btn-primary" type="submit">
                                <i class="fa fa-save"></i> {$LANG->getModule('template_save')}
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<script type="text/javascript">
    $(function () {
        // Nút Field
        $('#field').on('click', function () {
            window.location.href = script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' +
                nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=fields';
        });

        // Delete selected
        $('#delall').on('click', function () {
            if (confirm("{$LANG->getModule('prounit_del_confirm')}")) {
                var listid = [];
                $('input[name="idcheck[]"]:checked').each(function () {
                    listid.push($(this).val());
                });
                if (listid.length < 1) {
                    alert("{$LANG->getModule('prounit_del_no_items')}");
                    return false;
                }
                $.ajax({
                    type: 'POST',
                    url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=template&nocache=' + new Date().getTime(),
                    data: 'del_all=1&listid=' + listid,
                    success: function (data) {
                        if (data['status'] == 'OK') {
                            location.reload();
                        } else {
                            alert(data['message']);
                        }
                    }
                });
            }
        });
    });

    function nv_change_status(id) {
        var new_status = $('#change_active_' + id).is(':checked') ? 1 : 0;
        if (confirm(nv_is_change_act_confirm[0])) {
            var nv_timer = nv_settimeout_disable('change_active_' + id, 3000);
            $.ajax({
                type: 'POST',
                url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=template&nocache=' + new Date().getTime(),
                data: 'change_status=1&id=' + id + '&new_status=' + new_status,
                success: function (data) {
                    console.log(data);
                    if (data['status'] == 'OK') {
                        location.reload();
                    } else {
                        alert(data['message']);
                    }
                }
            });
        } else {
            $('#change_active_' + id).prop('checked', new_status ? false : true);
        }
    }

    function nv_chang_weight(id) {
        var nv_timer = nv_settimeout_disable('change_weight_' + id, 3000);
        var new_weight = $('#change_weight_' + id).val();
        $.ajax({
            type: 'POST',
            url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=template&nocache=' + new Date().getTime(),
            data: 'changeweight=1&id=' + id + '&new_weight=' + new_weight,
            success: function (data) {
                if (data['status'] == 'OK') {
                    location.reload();
                } else {
                    alert(data['error']);
                }
            }
        });
    }

    function nv_del_template(id) {
        if (confirm(nv_is_del_confirm[0])) {
            $.ajax({
                type: 'POST',
                url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=template&nocache=' + new Date().getTime(),
                data: 'del=1&id=' + id,
                success: function (data) {
                    if (data['status'] == 'OK') {
                        location.reload();
                    } else {
                        alert(data['message']);
                    }
                }
            });
        }
    }
</script>
<!-- END: main -->