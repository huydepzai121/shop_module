<div class="card mb-4">
    <div class="card-body">
        <div class="row g-1">
            <div class="col-auto">
                <a class="btn btn-{(!$COMPLETE and !$INCOMPLETE) ? 'primary' : 'secondary'} me-1"
                    href="{$smarty.const.NV_BASE_ADMINURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&amp;{$smarty.const.NV_NAME_VARIABLE}={$MODULE_NAME}&amp;{$smarty.const.NV_OP_VARIABLE}={$OP}">{$LANG->getModule('tags_all_title')}</a>
            </div>
            <div class="col-auto">
                <a class="btn btn-{$COMPLETE ? 'primary' : 'secondary'} me-1"
                    href="{$smarty.const.NV_BASE_ADMINURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&amp;{$smarty.const.NV_NAME_VARIABLE}={$MODULE_NAME}&amp;{$smarty.const.NV_OP_VARIABLE}={$OP}&amp;complete=1">{$LANG->getModule('tags_complete')}</a>
            </div>
            <div class="col-auto">
                <a class="btn btn-{$INCOMPLETE ? 'primary' : 'secondary'} me-1"
                    href="{$smarty.const.NV_BASE_ADMINURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&amp;{$smarty.const.NV_NAME_VARIABLE}={$MODULE_NAME}&amp;{$smarty.const.NV_OP_VARIABLE}={$OP}&amp;incomplete=1">{$LANG->getModule('tags_incomplete')}</a>
            </div>
            <div class="col-auto">
                <a class="btn btn-secondary" href="#" data-toggle="add_tags" data-fc="addTag"
                    data-mtitle="{$LANG->getModule('add_tags')}" data-tid="0">{$LANG->getModule('add_tags')}</a>
            </div>
            <div class="col-auto">
                <a class="btn btn-secondary" href="#" data-bs-toggle="modal"
                    data-bs-target="#mdTagMulti">{$LANG->getModule('add_multiple_tags')}</a>
            </div>
        </div>
    </div>
</div>
<div class="card">
    <div class="card-body">
        <form method="get" action="{$smarty.const.NV_BASE_ADMINURL}index.php">
            <input type="hidden" name="{$smarty.const.NV_LANG_VARIABLE}" value="{$smarty.const.NV_LANG_DATA}">
            <input type="hidden" name="{$smarty.const.NV_NAME_VARIABLE}" value="{$MODULE_NAME}">
            <input type="hidden" name="{$smarty.const.NV_OP_VARIABLE}" value="{$OP}">
            <input type="hidden" name="incomplete" value="{$INCOMPLETE}">
            <input type="hidden" name="complete" value="{$COMPLETE}">
            <div class="d-flex align-items-end flex-wrap justify-content-between g-3">
                <div>
                    <div class="input-group">
                        <input type="text" class="form-control" name="q" value="{$Q}" maxlength="64"
                            placeholder="{$LANG->getModule('search_key')}"
                            aria-label="{$LANG->getModule('search_key')}">
                        <button type="submit" class="btn btn-primary text-nowrap"><i
                                class="fa-solid fa-magnifying-glass"></i> {$LANG->getModule('search')}</button>
                    </div>
                </div>
                <div>
                    {if $COMPLETE}{$LANG->getModule('tags_complete_link')}{elseif
                    $INCOMPLETE}{$LANG->getModule('tags_incomplete_link')}{else}{$LANG->getModule('tags_all_link')}{/if}:
                    <strong class="text-danger">{if
                        !empty($NUM_ITEMS)}{$NUM_ITEMS|nv_number_format}{else}0{/if}</strong>
                </div>
            </div>
        </form>
    </div>
    {if not empty($DATA)}
    <div class="card-body">
        <div class="table-responsive-lg table-card" id="list-news-items">
            <table class="table table-striped align-middle table-sticky mb-0">
                <thead class="text-muted">
                    <tr>
                        <th class="text-nowrap" style="width: 1%;">
                            <input type="checkbox" data-toggle="checkAll" data-type="tag"
                                class="form-check-input m-0 align-middle"
                                aria-label="{$LANG->getGlobal('toggle_checkall')}">
                        </th>
                        <th class="text-nowrap" style="width: 38%;">{$LANG->getModule('name')}</th>
                        <th class="text-nowrap text-center" style="width: 1%;">{$LANG->getModule('description')}</th>
                        <th class="text-nowrap" style="width: 40%;">{$LANG->getModule('keywords')}</th>
                        <th class="text-nowrap" style="width: 20%;">{$LANG->getModule('function')}</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$DATA item=row}
                    <tr>
                        <td>
                            <input type="checkbox" data-toggle="checkSingle" data-type="tag" value="{$row.tid}"
                                class="form-check-input m-0 align-middle"
                                aria-label="{$LANG->getGlobal('toggle_checksingle')}">
                        </td>
                        <td>
                            <a href="{$row.link}" target="_blank">{$row.keywords}</a>
                        </td>
                        <td class="text-center">
                            {if empty($row.description)}
                            <i class="fa-solid fa-triangle-exclamation text-danger" data-bs-toggle="tooltip"
                                data-bs-title="{$LANG->getModule('tags_no_description')}"></i>
                            {else}
                            <i class="fa-solid fa-check text-success"></i>
                            {/if}
                        </td>
                        <td>{$row.alias}</td>
                        <td>
                            <div class="row g-1 flex-nowrap">
                                <div class="col-auto">
                                    <button type="button" class="btn btn-secondary btn-sm" {if empty($row.numpro)}
                                        disabled{/if} data-toggle="link_tags" data-tid="{$row.tid}"><i
                                            class="fa-solid fa-tags" data-icon="fa-tags"></i>
                                        {$LANG->getModule('tag_links')}: <strong>{if
                                            !empty($row.numpro)}{$row.numpro|nv_number_format}{else}0{/if}</strong></button>
                                </div>
                                <div class="col-auto">
                                    <button type="button" class="btn btn-secondary btn-sm" data-toggle="add_tags"
                                        data-fc="editTag" data-mtitle="{$LANG->getModule('edit_tags')}"
                                        data-tid="{$row.tid}"><i class="fa-solid fa-pen" data-icon="fa-pen"></i>
                                        {$LANG->getGlobal('edit')}</button>
                                </div>
                                <div class="col-auto">
                                    <button type="button" class="btn btn-danger btn-sm" data-toggle="nv_del_tag"
                                        data-tid="{$row.tid}"><i class="fa-solid fa-trash" data-icon="fa-trash"></i>
                                        {$LANG->getGlobal('delete')}</button>
                                </div>
                            </div>
                        </td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>
    </div>
    <div class="card-footer border-top">
        <div class="d-flex flex-wrap justify-content-between align-items-center">
            <div class="d-flex flex-wrap flex-sm-nowrap align-items-center">
                <div class="me-2">
                    <input type="checkbox" data-toggle="checkAll" data-type="tag"
                        class="form-check-input m-0 align-middle" aria-label="{$LANG->getGlobal('toggle_checkall')}">
                </div>
                <div class="input-group me-1 my-1">
                    <button type="button" class="btn btn-danger" data-toggle="nv_del_check_tags"><i
                            class="fa-solid fa-trash" data-icon="fa-trash"></i> {$LANG->getGlobal('delete')}</button>
                </div>
            </div>
            <div class="pagination-wrap">
                {$PAGINATION}
            </div>
        </div>
    </div>
    {/if}
</div>

<div class="modal fade" id="mdTagMulti" tabindex="-1" aria-labelledby="mdTagMultiLabel" aria-hidden="true"
    data-bs-backdrop="static">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title fs-5 fw-medium" id="mdTagMultiLabel">{$LANG->getModule('add_multiple_tags')}
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal"
                    aria-label="{$LANG->getGlobal('close')}"></button>
            </div>
            <div class="modal-body">
                <form action="#" method="post" class="ajax-submit-multi">
                    <input name="savetag" type="hidden" value="1">
                    <div class="mb-3">
                        <label for="element_mtag_mtitle" class="form-label">{$LANG->getModule('note_tags')}:</label>
                        <textarea class="form-control" name="mtitle" id="element_mtag_mtitle" rows="5"
                            maxlength="2000"></textarea>
                    </div>
                    <div class="text-center">
                        <button class="btn btn-primary" type="submit"><i class="fa-solid fa-floppy-disk"
                                data-icon="fa-floppy-disk"></i> {$LANG->getModule('save')}</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal thêm/sửa tag -->
<div class="modal fade" id="mdTagSingle" tabindex="-1" aria-labelledby="mdTagSingleLabel" aria-hidden="true"
    data-bs-backdrop="static">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title fs-5 fw-medium" id="mdTagSingleLabel"></div>
                <button type="button" class="btn-close" data-bs-dismiss="modal"
                    aria-label="{$LANG->getGlobal('close')}"></button>
            </div>
            <div class="modal-body">
                <form action="#" method="post" class="ajax-submit-single">
                    <input name="savecat" type="hidden" value="1">
                    <input name="tid" type="hidden" value="0">
                    <div class="row mb-3">
                        <label for="element_stag_keywords"
                            class="col-12 col-sm-3 col-form-label text-sm-end">{$LANG->getModule('keywords')} <span
                                class="text-danger">(*)</span></label>
                        <div class="col-12 col-sm-8">
                            <input type="text" class="form-control" id="element_stag_keywords" name="keywords" value=""
                                maxlength="250">
                            <div class="invalid-feedback">{$LANG->getModule('error_tag_keywords')}</div>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label for="element_stag_description"
                            class="col-12 col-sm-3 col-form-label text-sm-end">{$LANG->getModule('description')}</label>
                        <div class="col-12 col-sm-8">
                            <textarea class="form-control" id="element_stag_description" name="description"
                                rows="5"></textarea>
                            <div class="form-text">{$LANG->getGlobal('length_characters')}: <span
                                    data-toggle="descriptionlength" class="text-danger">0</span>.
                                {$LANG->getGlobal('description_suggest_max')}</div>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label for="element_stag_image"
                            class="col-12 col-sm-3 col-form-label text-sm-end">{$LANG->getModule('image')}</label>
                        <div class="col-12 col-sm-8">
                            <div class="input-group">
                                <input type="text" class="form-control" id="element_stag_image" name="image" value="">
                                <button type="button" class="btn btn-secondary" onclick="selectImage()"><i
                                        class="fa fa-folder-open"></i></button>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12 col-sm-8 offset-sm-3">
                            <button type="submit" class="btn btn-primary">{$LANG->getGlobal('save')}</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal xem liên kết -->
<div class="modal fade" id="mdTagLinks" tabindex="-1" aria-labelledby="mdTagLinksLabel" aria-hidden="true"
    data-bs-backdrop="static">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title fs-5 fw-medium" id="mdTagLinksLabel">{$LANG->getModule('tag_links')}</div>
                <button type="button" class="btn-close" data-bs-dismiss="modal"
                    aria-label="{$LANG->getGlobal('close')}"></button>
            </div>
            <div class="modal-body p-0">
            </div>
            <div class="modal-footer justify-content-start">
                <div class="tag-tools">
                    <div class="d-flex align-items-center">
                        <div class="me-2">
                            <input type="checkbox" data-toggle="checkAll" data-type="link"
                                class="form-check-input m-0 d-block" aria-label="{$LANG->getGlobal('toggle_checkall')}">
                        </div>
                        <div>
                            <button type="button" class="btn btn-danger" data-toggle="tags_id_check_del""><i
                                    class=" fa-solid fa-trash" data-icon="fa-trash"></i>
                                {$LANG->getGlobal('delete')}</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    var script_name = "{$NV_BASE_ADMINURL}index.php";
    var nv_lang_data = "{$NV_LANG_DATA}";
    var nv_name_variable = "{$NV_NAME_VARIABLE}";
    var nv_fc_variable = "{$NV_OP_VARIABLE}";
    var nv_module_name = "{$MODULE_NAME}";
    var uploaddir = "{$UPLOAD_PATH}";
    var currentpath = "{$UPLOAD_PATH}";
    var checkss = "{$NV_CHECK_SESSION}";

    $(document).ready(function () {
        // Xử lý nút xem liên kết tag
        $('[data-toggle="link_tags"]').on('click', function (e) {
            e.preventDefault();
            var btn = $(this);
            var icon = $('i', btn);
            if (icon.is('.fa-spinner')) {
                return;
            }
            var tid = btn.data('tid');
            icon.removeClass(icon.data('icon')).addClass('fa-spinner fa-spin-pulse');
            $.ajax({
                type: 'POST',
                cache: !1,
                url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=tags',
                data: {
                    tagLinks: 1,
                    tid: tid,
                    checkss: '{$smarty.const.NV_CHECK_SESSION}'
                },
                dataType: 'json',
                success: function (res) {
                    icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                    if (res.success) {
                        $('#mdTagLinks .modal-body').html(res.html);
                        $('#mdTagLinks').modal('show');
                        bindDeleteTagLinks();
                    } else {
                        nvToast(res.text, 'error');
                    }
                },
                error: function (xhr, text, err) {
                    icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                    nvToast(text, 'error');
                    console.log(xhr, text, err);
                }
            });
        });

        // Hàm bind sự kiện xóa liên kết tag
        function bindDeleteTagLinks() {
            $('[data-toggle="tags_id_check_del"]').off('click').on('click', function (e) {
                e.preventDefault();
                let btn = $(this);
                let icon = $('i', btn);
                if (icon.is('.fa-spinner')) {
                    return;
                }
                var tid = $('#mdTagLinks .list-group-item').data('id');
                var listid = [];
                $('#mdTagLinks input[data-toggle="checkSingle"][type="checkbox"]:checked').each(function () {
                    listid.push($(this).val());
                });
                if (listid.length < 1) {
                    nvAlert('{$LANG->getModule('please_select_one')}', 'error');
                    return false;
                }
                nvConfirm('{$LANG->getModule('delete_confirm')}', () => {
                    icon.removeClass(icon.data('icon')).addClass('fa-spinner fa-spin-pulse');
                    $.ajax({
                        type: 'POST',
                        cache: !1,
                        url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=tags',
                        data: {
                            tagsIdDel: 1,
                            tid: listid.join(','),
                            ids: tid,
                            checkss: '{$smarty.const.NV_CHECK_SESSION}'
                        },
                        dataType: 'json',
                        success: function (res) {
                            icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                            if (res.success) {
                                var btn = $('[data-toggle="link_tags"][data-tid="' + tid + '"]');
                                var numtag = parseInt(btn.find('strong').text()) - listid.length;
                                btn.find('strong').text(numtag);
                                if (numtag == 0) {
                                    btn.prop('disabled', true);
                                }
                                $('#mdTagLinks').modal('hide');
                                nvToast(res.text, 'success');
                                location.reload();
                            } else {
                                nvToast(res.text, 'error');
                            }
                        },
                        error: function (xhr, text, err) {
                            icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                            nvToast(text, 'error');
                            console.log(xhr, text, err);
                        }
                    });
                });
            });
        }

        // Bind sự kiện lần đầu
        bindDeleteTagLinks();

        // Xử lý nút thêm/sửa tag
        $('[data-toggle="add_tags"]').on('click', function (e) {
            e.preventDefault();
            let btn = $(this);
            let icon = $('i', btn);
            if (icon.is('.fa-spinner')) {
                return;
            }
            var tid = btn.data('tid');
            var mtitle = btn.data('mtitle');

            if (tid > 0) {
                // Sửa tag
                icon.removeClass(icon.data('icon')).addClass('fa-spinner fa-spin-pulse');
                $.ajax({
                    type: 'POST',
                    cache: !1,
                    url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=tags',
                    data: {
                        loadEditTag: 1,
                        tid: tid,
                        checkss: '{$smarty.const.NV_CHECK_SESSION}'
                    },
                    dataType: "json",
                    success: function (res) {
                        icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                        if (res.success) {
                            $('#mdTagSingle input[name="tid"]').val(tid);
                            $('#mdTagSingle input[name="keywords"]').val(res.data.keywords);
                            $('#mdTagSingle textarea[name="description"]').val(res.data.description);
                            $('#mdTagSingle input[name="image"]').val(res.data.image);
                            $('#mdTagSingleLabel').text(mtitle);
                            $('#mdTagSingle').modal('show');
                        } else {
                            nvToast(res.text, 'error');
                        }
                    },
                    error: function (xhr, text, err) {
                        icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                        nvToast(text, 'error');
                        console.log(xhr, text, err);
                    }
                });
            } else {
                // Thêm tag mới
                $('#mdTagSingle form')[0].reset();
                $('#mdTagSingle input[name="tid"]').val(0);
                $('#mdTagSingleLabel').text(mtitle);
                $('#mdTagSingle').modal('show');
            }
        });

        // Xử lý form thêm/sửa tag
        $('.ajax-submit-single').on('submit', function (e) {
            e.preventDefault();
            var form = $(this);
            let btn = $('button[type="submit"]', form);
            let icon = $('i', btn);
            if (icon.is('.fa-spinner')) {
                return;
            }
            icon.removeClass(icon.data('icon')).addClass('fa-spinner fa-spin-pulse');
            var formData = form.serializeArray();
            formData.push({
                name: 'checkss',
                value: checkss
            });
            $.ajax({
                type: 'POST',
                cache: !1,
                url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=tags',
                data: formData,
                dataType: 'json',
                success: function (res) {
                    icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                    if (res.status == 'ok') {
                        $('#mdTagSingle').modal('hide');
                        nvToast(res.mess, 'success');
                        setTimeout(function () {
                            location.reload();
                        }, 1500);
                    } else {
                        nvToast(res.mess, 'error');
                        if (res.input) {
                            $('#mdTagSingle [name=' + res.input + ']').focus();
                        }
                    }
                },
                error: function (xhr, text, err) {
                    icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                    nvToast(text, 'error');
                    console.log(xhr, text, err);
                }
            });
        });

        // Xử lý xóa tag
        $('[data-toggle="nv_del_tag"]').on('click', function (e) {
            e.preventDefault();
            let btn = $(this);
            let icon = $('i', btn);
            if (icon.is('.fa-spinner')) {
                return;
            }
            nvConfirm('{$LANG->getModule('delete_confirm')}', () => {
                icon.removeClass(icon.data('icon')).addClass('fa-spinner fa-spin-pulse');
                $.ajax({
                    type: 'POST',
                    cache: !1,
                    url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=tags',
                    data: {
                        del_tid: btn.data('tid'),
                        checkss: '{$smarty.const.NV_CHECK_SESSION}'
                    },
                    dataType: 'json',
                    success: function (res) {
                        icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                        if (res.success) {
                            nvToast(res.text, 'success');
                            location.reload();
                        } else {
                            nvToast(res.text, 'error');
                        }
                    },
                    error: function (xhr, text, err) {
                        icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                        nvToast(text, 'error');
                        console.log(xhr, text, err);
                    }
                });
            });
        });

        // Xử lý xóa nhiều tag
        $('[data-toggle="nv_del_check_tags"]').on('click', function (e) {
            e.preventDefault();
            let btn = $(this);
            let icon = $('i', btn);
            if (icon.is('.fa-spinner')) {
                return;
            }
            var listid = [];
            $('input[data-toggle="checkSingle"][type="checkbox"]:checked').each(function () {
                listid.push($(this).val());
            });
            if (listid.length < 1) {
                nvAlert('{$LANG->getModule('please_select_one')}', 'error');
                return false;
            }
            nvConfirm('{$LANG->getModule('delete_confirm')}', () => {
                icon.removeClass(icon.data('icon')).addClass('fa-spinner fa-spin-pulse');
                $.ajax({
                    type: 'POST',
                    cache: !1,
                    url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=tags',
                    data: {
                        del_listid: listid.join(','),
                        checkss: '{$smarty.const.NV_CHECK_SESSION}'
                    },
                    dataType: 'json',
                    success: function (res) {
                        icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                        if (res.success) {
                            nvToast(res.text, 'success');
                            location.reload();
                        } else {
                            nvToast(res.text, 'error');
                        }
                    },
                    error: function (xhr, text, err) {
                        icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                        nvToast(text, 'error');
                        console.log(xhr, text, err);
                    }
                });
            });
        });

        // Xử lý checkbox
        $('[data-toggle="checkAll"]').on('change', function () {
            var type = $(this).data('type');
            $('[data-toggle="checkSingle"][data-type="' + type + '"]').prop('checked', $(this).prop('checked'));
        });

        // Xử lý form thêm nhiều tag
        $('.ajax-submit-multi').on('submit', function (e) {
            e.preventDefault();
            var form = $(this);
            let btn = $('button[type="submit"]', form);
            let icon = $('i', btn);
            if (icon.is('.fa-spinner')) {
                return;
            }
            icon.removeClass(icon.data('icon')).addClass('fa-spinner fa-spin-pulse');
            var formData = form.serializeArray();
            formData.push({
                name: 'checkss',
                value: checkss
            });
            $.ajax({
                type: 'POST',
                cache: !1,
                url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=tags',
                data: formData,
                dataType: 'json',
                success: function (res) {
                    icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                    if (res.status == 'ok') {
                        $('#mdTagMulti').modal('hide');
                        nvToast(res.mess, 'success');
                        setTimeout(function () {
                            location.reload();
                        }, 1500);
                    } else {
                        nvToast(res.mess, 'error');
                        if (res.input) {
                            $('#mdTagMulti [name=' + res.input + ']').focus();
                        }
                    }
                },
                error: function (xhr, text, err) {
                    icon.removeClass('fa-spinner fa-spin-pulse').addClass(icon.data('icon'));
                    nvToast(text, 'error');
                    console.log(xhr, text, err);
                }
            });
        });
    });
</script>