{if $main}
<div id="module_show_list">
    {$CAT_LIST}
</div>
<div id="cat-delete-area">&nbsp;</div>
<div id="edit" class="table-responsive">
    {if $error}
    <div class="alert alert-warning">{$error}</div>
    {/if}
    <form class="form-inline" action="{$FORM_ACTION}" method="post" id="frm-cat-content">
        <input type="hidden" name="catid" value="{$DATA.catid}" />
        <input type="hidden" name="parentid_old" value="{$DATA.parentid}" />
        <input name="savecat" type="hidden" value="1" />

        <div class="row mb-3">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title m-0">{$CAPTION}</h5>
                    </div>
                    <div class="card-body">
                        <table class="table table-striped table-bordered table-hover mb-0">
                            <tbody>
                                <tr>
                                    <th class="text-right">{$LANG->getModule('catalog_name')}</th>
                                    <td><input class="form-control" style="width: 500px" name="title" type="text"
                                            value="{$DATA.title}" maxlength="255" id="idtitle" required="required"
                                            oninvalid="setCustomValidity( nv_required )" oninput="setCustomValidity('')"
                                            onchange="nv_get_alias('cat', {$DATA.catid})"
                                            onkeyup="nv_get_alias('cat', {$DATA.catid})" /><span class="text-middle">
                                            {$LANG->getGlobal('length_characters')}: <span id="titlelength"
                                                class="red">0</span>.
                                            {$LANG->getGlobal('title_suggest_max')} </span></td>
                                </tr>
                                <tr>
                                    <th class="text-right">{$LANG->getModule('alias')} : </th>
                                    <td><input class="form-control" style="width: 500px" name="alias" type="text"
                                            value="{$DATA.alias}" maxlength="255" id="idalias" />&nbsp; <em
                                            class="fa fa-refresh fa-lg fa-pointer"
                                            onclick="nv_get_alias('cat', {$DATA.catid})">&nbsp;</em>
                                </tr>
                                <tr>
                                    <th class="text-right">{$LANG->getModule('cat_sub')}</th>
                                    <td>
                                        <select class="form-control" name="parentid">
                                            {foreach from=$parent_loop item=parent}
                                            <option value="{$parent.pcatid_i}" {$parent.pselect}>{$parent.ptitle_i}
                                            </option>
                                            {/foreach}
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="text-right">{$LANG->getModule('typeprice')} </th>
                                    <td>
                                        {foreach from=$typeprice_loop item=type}
                                        <label><input type="radio" name="typeprice" value="{$type.key}"
                                                {$type.checked} />{$type.value}</label>&nbsp;&nbsp;
                                        {/foreach}
                                    </td>
                                </tr>
                                <tr>
                                    <th class="text-right">{$LANG->getModule('keywords')}: </th>
                                    <td><input class="form-control" style="width: 500px" name="keywords" type="text"
                                            value="{$DATA.keywords}" maxlength="255" /></td>
                                </tr>
                                <tr>
                                    <th class="text-right">{$LANG->getModule('description')}</th>
                                    <td>
                                        <textarea style="width: 500px" name="description" id="description" cols="100"
                                            rows="5" class="form-control">{$DATA.description}</textarea> <span
                                            class="text-middle">
                                            {$LANG->getGlobal('length_characters')}: <span id="descriptionlength"
                                                class="red">0</span>.
                                            {$LANG->getGlobal('description_suggest_max')} </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="text-right">{$LANG->getModule('content_homeimg')}</th>
                                    <td>
                                        <input class="form-control" style="width: 500px" type="text" name="image"
                                            id="image" value="{$DATA.image}" />
                                        <a class="btn btn-info" name="selectimg"><em
                                                class="fa fa-folder-open-o">&nbsp;</em>{$LANG->getModule('file_selectfile')}</a>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="text-right">{$LANG->getModule('content_bodytext')}</th>
                                    <td>
                                        {$DESCRIPTIONHTML}
                                    </td>
                                </tr>
                                <tr>
                                    <th class="text-right">{$LANG->getModule('content_bodytext_display')}</th>
                                    <td>
                                        {foreach from=$viewdescriptionhtml item=view}
                                        <label><input type="radio" name="viewdescriptionhtml" value="{$view.value}"
                                                {$view.checked} />{$view.title}</label>&nbsp;&nbsp;&nbsp;
                                        {/foreach}
                                    </td>
                                </tr>
                                {if $cat_form}
                                <tr>
                                    <th class="text-right">{$LANG->getModule('cat_form')}: </th>
                                    <td>
                                        {foreach from=$cat_form.loop item=form}
                                        <div>
                                            <label><input type="checkbox" name="cat_form[]" value="{$form.value}"
                                                    {$form.checked}>
                                                {$form.title}</label>
                                        </div>
                                        {/foreach}
                                    </td>
                                </tr>
                                {/if}
                                <tr>
                                    <th class="text-right">{$LANG->getGlobal('groups_view')}</th>
                                    <td>
                                        {foreach from=$groups_view item=group}
                                        <div class="row">
                                            <label><input name="groups_view[]" type="checkbox" value="{$group.value}"
                                                    {$group.checked} />{$group.title}</label>
                                        </div>
                                        {/foreach}
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        {if $point}
        <div class="row mb-3">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title m-0">{$LANG->getModule('setting_point')}</h5>
                    </div>
                    <div class="card-body">
                        <table class="table table-striped table-bordered table-hover mb-0">
                            <tbody>
                                <tr>
                                    <td><strong>{$LANG->getModule('cat_allow_point')}</strong></td>
                                    <td><input type="checkbox" name="cat_allow_point" value="1"
                                            {$DATA.cat_allow_point} /></td>
                                </tr>
                                <tr>
                                    <td><strong>{$LANG->getModule('cat_number_point')}</strong></td>
                                    <td><input type="text" class="form-control" name="cat_number_point"
                                            value="{$DATA.cat_number_point}" {$DATA.cat_number_point_dis} /></td>
                                </tr>
                                <tr>
                                    <td><strong>{$LANG->getModule('cat_number_product')}</strong></td>
                                    <td><input type="text" class="form-control" name="cat_number_product"
                                            value="{$DATA.cat_number_product}" {$DATA.cat_number_product_dis} /></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        {/if}

        <div class="row mb-3">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title m-0">{$LANG->getModule('tag')}</h5>
                    </div>
                    <div class="card-body">
                        <table class="table table-striped table-bordered table-hover mb-0">
                            <colgroup>
                                <col class="w300" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <td class="text-right"><strong>{$LANG->getModule('tag_title')}</strong></td>
                                    <td>
                                        <input class="form-control" style="width: 500px" name="title_custom" type="text"
                                            value="{$DATA.title_custom}" maxlength="255" id="titlesite" /><span
                                            class="text-middle">
                                            {$LANG->getGlobal('length_characters')}: <span id="titlesitelength"
                                                class="red">0</span>.
                                            {$LANG->getGlobal('title_suggest_max')} </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="text-right"><strong>{$LANG->getModule('tag_description')}</strong></td>
                                    <td>
                                        <textarea class="form-control" style="width: 500px"
                                            name="tag_description">{$DATA.tag_description}</textarea>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title m-0">{$LANG->getModule('setting_group_price')}</h5>
                    </div>
                    <div class="card-body">
                        <table class="table table-striped table-bordered table-hover mb-0">
                            <colgroup>
                                <col class="w300" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <td><strong>{$LANG->getModule('setting_group_price_space')}</strong><em
                                            class="help-block">{$LANG->getModule('setting_group_price_space_note_cat')}</em>
                                    </td>
                                    <td>
                                        <textarea class="form-control" name="group_price" rows="9"
                                            style="width: 100%">{$DATA.group_price}</textarea>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="text-center mt-3 mb-3">
            <input class="btn btn-primary" name="submit1" type="submit" value="{$LANG->getModule('save')}" />
        </div>
    </form>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        $('input[name="cat_allow_point"]').change(function () {
            if ($(this).is(":checked")) {
                $('input[name="cat_number_point"]').removeAttr('readonly');
                $('input[name="cat_number_product"]').removeAttr('readonly');
            }
            else {
                $('input[name="cat_number_point"]').attr('readonly', 'readonly');
                $('input[name="cat_number_product"]').attr('readonly', 'readonly');
            }
        });

        $('#frm-cat-content').submit(function (e) {
            e.preventDefault();

            $.ajax({
                type: 'POST',
                url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=cat&nocache=' + new Date().getTime(),
                data: $(this).serialize(),
                success: function (json) {
                    if (json.error) {
                        alert(json.msg);
                    } else {
                        window.location.href = json.redirect;
                    }
                }
            });
        });
    });

    $("#titlelength").html($("#idtitle").val().length);
    $("#idtitle").bind("keyup paste", function () {
        $("#titlelength").html($(this).val().length);
    });

    $("#titlesitelength").html($("#titlesite").val().length);
    $("#titlesite").bind("keyup paste", function () {
        $("#titlesitelength").html($(this).val().length);
    });

    $("#descriptionlength").html($("#description").val().length);
    $("#description").bind("keyup paste", function () {
        $("#descriptionlength").html($(this).val().length);
    });

    $("a[name=selectimg]").click(function () {
        var area = "image";
        var path = "{$UPLOAD_CURRENT}";
        var currentpath = "{$UPLOAD_CURRENT}";
        var type = "image";
        nv_open_browse(script_name + "?" + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + "=upload&popup=1&area=" + area + "&path=" + path + "&type=" + type + "&currentpath=" + currentpath, "NVImg", 850, 420, "resizable=no,scrollbars=no,toolbar=no,location=no,status=no");
        return false;
    });
</script>

{if $getalias}
<script type="text/javascript">
    function nv_get_alias(mod, id) {
        var title = strip_tags(document.getElementById('idtitle').value);
        if (title != '') {
            $.post(script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=alias&nocache=' + new Date().getTime(), 'title=' + encodeURIComponent(title) + '&mod=' + mod + '&id=' + id, function (res) {
                if (res != "") {
                    document.getElementById('idalias').value = res;
                } else {
                    document.getElementById('idalias').value = '';
                }
            });
        }
        return false;
    }
</script>
{/if}
{/if}