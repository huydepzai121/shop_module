{if $main}
<div class="card border-primary border-3 border-bottom-0 border-start-0 border-end-0">
    <div class="card-header fs-5 fw-medium">{$CAPTION}</div>
    <div class="card-body pt-4">
        <div id="module_show_list">
            {$GROUP_LIST}
        </div>
        <div id="group-delete-area">&nbsp;</div>
        <div id="edit">
            {if $error}
            <div class="alert alert-warning">{$error}</div>
            {/if}

            <form action="{$FORM_ACTION}" method="post">
                <input type="hidden" name="groupid" value="{$DATA.groupid}" />
                <input type="hidden" name="parentid_old" value="{$DATA.parentid}" />
                <input name="savegroup" type="hidden" value="1" />

                <div class="row mb-3">
                    <label class="col-sm-3 col-form-label text-end fw-bold">
                        {$LANG->getModule('group_name')} <span class="text-danger">*</span>
                    </label>
                    <div class="col-sm-9">
                        <input class="form-control" name="title" type="text" value="{$DATA.title}" maxlength="255" id="idtitle" 
                            required="required" oninvalid="setCustomValidity(nv_required)" oninput="setCustomValidity('')"
                            onchange="nv_get_alias('group', '{$DATA.groupid}')" onkeyup="nv_get_alias('group', '{$DATA.groupid}')" />
                        <small class="form-text text-muted">
                            {$LANG->getGlobal('length_characters')}: <span id="titlelength" class="text-danger">0</span>. 
                            {$LANG->getGlobal('title_suggest_max')}
                        </small>
                    </div>
                </div>

                <div class="row mb-3">
                    <label class="col-sm-3 col-form-label text-end fw-bold">
                        {$LANG->getModule('alias')}
                    </label>
                    <div class="col-sm-9">
                        <div class="input-group">
                            <input class="form-control" name="alias" type="text" value="{$DATA.alias}" maxlength="255" id="idalias" />
                            <button class="btn btn-outline-secondary" type="button" onclick="nv_get_alias('group', '{$DATA.groupid}')">
                                <i class="fa fa-refresh"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <div class="row mb-3">
                    <label class="col-sm-3 col-form-label text-end fw-bold">
                        {$LANG->getModule('group_sub')}
                    </label>
                    <div class="col-sm-9">
                        <select class="form-select" name="parentid" onchange="nv_getcatalog(this)">
                            {foreach from=$parent_loop item=parent}
                            <option value="{$parent.pgroup_i}" {$parent.pselect}>{$parent.ptitle_i}</option>
                            {/foreach}
                        </select>
                    </div>
                </div>

                <div class="row mb-3" id="require">
                    <label class="col-sm-3 col-form-label text-end fw-bold">
                        {$LANG->getModule('group_require')}
                    </label>
                    <div class="col-sm-9">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="require" value="1" id="require-check" 
                                {if isset($DATA.require_ck)}{$DATA.require_ck}{/if} />
                            <label class="form-check-label" for="require-check">
                                {$LANG->getModule('group_require')}
                            </label>
                        </div>
                    </div>
                </div>

                <div class="row mb-3" id="cat">
                    <label class="col-sm-3 col-form-label text-end fw-bold">
                        {$LANG->getModule('group_of')} <span class="text-danger">*</span>
                        <span class="info_icon" data-toggle="tooltip" title="" 
                            data-original-title="{$LANG->getModule('group_cat_note')}">&nbsp;</span>
                    </label>
                    <div class="col-sm-9">
                        <div id="vcatid"></div>
                        <small class="form-text text-muted">{$LANG->getModule('group_cat_note1')}</small>
                    </div>
                </div>

                <div class="row mb-3">
                    <label class="col-sm-3 col-form-label text-end fw-bold">
                        {$LANG->getModule('keywords')}
                    </label>
                    <div class="col-sm-9">
                        <input class="form-control" name="keywords" type="text" value="{$DATA.keywords}" maxlength="255" />
                    </div>
                </div>

                <div class="row mb-3">
                    <label class="col-sm-3 col-form-label text-end fw-bold">
                        {$LANG->getModule('description')}
                    </label>
                    <div class="col-sm-9">
                        <textarea name="description" id="description" rows="5" class="form-control">{$DATA.description}</textarea>
                        <small class="form-text text-muted">
                            {$LANG->getGlobal('length_characters')}: <span id="descriptionlength" class="text-danger">0</span>.
                            {$LANG->getGlobal('description_suggest_max')}
                        </small>
                    </div>
                </div>

                <div class="row mb-3">
                    <label class="col-sm-3 col-form-label text-end fw-bold">
                        {$LANG->getModule('content_homeimg')}
                    </label>
                    <div class="col-sm-9">
                        <div class="input-group">
                            <input class="form-control" type="text" name="image" id="image" value="{$DATA.image}" />
                            <button class="btn btn-info" type="button" name="selectimg">
                                <i class="fa fa-folder-open-o"></i> {$LANG->getModule('file_selectfile')}
                            </button>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-sm-9 offset-sm-3">
                        <button type="submit" class="btn btn-primary">
                            <i class="fa fa-save"></i> {$LANG->getModule('save')}
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<script type="text/javascript">
    $.get('{$URL}', function (data) {
        if (data == '') {
            $('#cat, #require').hide();
        } else {
            $('#vcatid').load('{$URL}');
            $('#cat, #require').show();
        }
    });

    $("#titlelength").html($("#idtitle").val().length);
    $("#idtitle").bind("keyup paste", function () {
        $("#titlelength").html($(this).val().length);
        nv_get_alias("group", '{$DATA.groupid}');
    });

    $("#descriptionlength").html($("#description").val().length);
    $("#description").bind("keyup paste", function () {
        $("#descriptionlength").html($(this).val().length);
    });

    $("button[name=selectimg]").click(function () {
        var area = "image";
        var path = "{$UPLOAD_CURRENT}";
        var currentpath = "{$UPLOAD_CURRENT}";
        var type = "image";
        nv_open_browse(script_name + "?" + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + "=upload&popup=1&area=" + area + "&path=" + path + "&type=" + type + "&currentpath=" + currentpath, "NVImg", 850, 420, "resizable=no,scrollbars=no,toolbar=no,location=no,status=no");
        return false;
    });

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
        } else {
            document.getElementById('idalias').value = '';
        }
        return false;
    }
</script>
{/if}