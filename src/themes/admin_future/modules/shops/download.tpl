{if $main}
<div class="row">
    <!-- Phần danh sách tài liệu -->
    <div class="col-md-16">
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="card-title mb-0">{$LANG->getModule('download_list')}</h5>
                <div class="card-tools">
                    <form action="{$NV_BASE_ADMINURL}index.php" method="get" class="form-inline">
                        <input type="hidden" name="{$NV_LANG_VARIABLE}" value="{$NV_LANG_DATA}" />
                        <input type="hidden" name="{$NV_NAME_VARIABLE}" value="{$MODULE_NAME}" />
                        <input type="hidden" name="{$NV_OP_VARIABLE}" value="{$OP}" />
                        <div class="input-group">
                            <input type="text" class="form-control" value="{$SEARCH.keywords}" name="keywords"
                                placeholder="{$LANG->getModule('search_key')}" />
                            <select class="form-select w-auto" name="status">
                                <option value="-1">---{$LANG->getModule('status')}---</option>
                                {foreach from=$STATUS_FILTER item=STATUS}
                                <option value="{$STATUS.key}" {$STATUS.selected}>{$STATUS.value}</option>
                                {/foreach}
                            </select>
                            <button type="submit" class="btn btn-primary">
                                <i class="fa fa-search"></i>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover mb-0">
                        <thead>
                            <tr>
                                <th>{$LANG->getModule('download_file_title')}</th>
                                <th class="w150 text-center">{$LANG->getModule('download_file_time')}</th>
                                <th class="w150 text-center">{$LANG->getModule('download_file_count')}</th>
                                <th class="w100 text-center">{$LANG->getModule('download_file_down_hits')}</th>
                                <th class="w100 text-center">{$LANG->getModule('status')}</th>
                                <th class="w150 text-center">{$LANG->getModule('action')}</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach from=$DATA item=VIEW}
                            <tr id="row_{$VIEW.id}">
                                <td>{$VIEW.title}</td>
                                <td class="text-center">{$VIEW.addtime}</td>
                                <td class="text-center">{$VIEW.count_product}</td>
                                <td class="text-center">{$VIEW.download_hits}</td>
                                <td class="text-center">
                                    <div class="form-check form-switch d-flex justify-content-center">
                                        <input class="form-check-input" type="checkbox" id="change_active_{$VIEW.id}"
                                            onclick="nv_change_active_files({$VIEW.id})" {$VIEW.active}>
                                    </div>
                                </td>
                                <td class="text-center">
                                    <div class="btn-group">
                                        <a class="btn btn-sm btn-primary" href="{$VIEW.url_edit}" title="{$GLANG.edit}">
                                            <i class="fa fa-edit"></i>
                                        </a>
                                        <button class="btn btn-sm btn-danger" onclick="nv_del_files({$VIEW.id})"
                                            title="{$GLANG.delete}">
                                            <i class="fa fa-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            {/foreach}
                        </tbody>
                        {if $GENERATE_PAGE}
                        <tfoot>
                            <tr>
                                <td colspan="6" class="text-center">
                                    {$GENERATE_PAGE}
                                </td>
                            </tr>
                        </tfoot>
                        {/if}
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="col-md-24">
        <div class="card">
            <div class="card-header">
                <h5 class="card-title mb-0">{$LANG->getModule('download_file_add')}</h5>
            </div>
            <div class="card-body">
                {if $ERROR}
                <div class="alert alert-danger">{$ERROR}</div>
                {/if}

                {if $popup}
                <div id="divsuccess" class="alert alert-success" style="display: none">
                    {$LANG->getModule('download_file_add_success')}
                </div>
                {/if}

                <form action="{$ACTION}" method="post" id="frm_add_file" data-popup="{$POPUP}" data-busy="false">
                    <input type="hidden" name="id" value="{$DATA.id|default:0}" />

                    <div class="mb-3">
                        <label class="form-label required">
                            <strong>{$LANG->getModule('download_file_title')}</strong>
                        </label>
                        <input type="text" name="title" value="{$DATA.title|default:''}" class="form-control"
                            required="required" oninvalid="setCustomValidity(nv_required)"
                            oninput="setCustomValidity('')">
                    </div>

                    <div class="mb-3">
                        <label class="form-label required">
                            <strong>{$LANG->getModule('download_file_path')}</strong>
                        </label>
                        <div class="input-group">
                            <input type="text" name="path" id="file-path" value="{$FILE_PATH}" class="form-control"
                                required="required" oninvalid="setCustomValidity(nv_required)"
                                oninput="setCustomValidity('')">
                            <button class="btn btn-outline-secondary" type="button" id="open_files"
                                data-path="{$UPLOADS_FILES_DIR}">
                                <i class="fa fa-folder-open"></i>
                            </button>
                        </div>
                        <div class="form-text">{$LANG->getModule('download_file_path_note')}</div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">
                            <strong>{$LANG->getModule('download_file_description')}</strong>
                        </label>
                        <textarea class="form-control" name="description"
                            rows="3">{$DATA.description|default:''}</textarea>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">
                            <strong>{$LANG->getModule('download_setting_groups')}</strong>
                        </label>
                        <div>
                            {foreach from=$DOWNLOAD_GROUPS item=GROUP}
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="checkbox" name="download_groups[]"
                                    value="{$GROUP.value}" {$GROUP.checked} id="group_{$GROUP.value}">
                                <label class="form-check-label" for="group_{$GROUP.value}">{$GROUP.title}</label>
                            </div>
                            {/foreach}
                        </div>
                    </div>

                    <div class="text-center">
                        <button type="submit" class="btn btn-primary" id="btn-submit-add-file">
                            <i class="fa fa-save"></i> {$LANG->getModule('save')}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        // Xử lý khi submit form thêm tài liệu
        $(document).delegate('#btn-submit-add-file', 'click', function (e) {
            // Tác dụng cho thuộc tính required khi không điền đường dẫn bằng tay
            $('#file-path').trigger('input');
        });

        $(document).delegate('#frm_add_file', 'submit', function (e) {
            e.preventDefault();

            var $this = $(this);
            var popup = $this.data('popup');

            if ($this.data('busy')) {
                return false;
            }
            $this.data('busy', true);
            $('#btn-submit-add-file').prop('disabled', true);

            $.ajax({
                type: 'POST',
                url: $this.attr('action'),
                data: $this.serialize() + '&submit=1',
                success: function (res) {
                    $this.data('busy', false);
                    $('#btn-submit-add-file').prop('disabled', false);
                    var r_split = res.split('_');
                    if (r_split[0] == 'OK') {
                        if (popup) {
                            $('#divsuccess').slideDown();
                            $this.clearForm();
                            $.post(
                                script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=download&nocache=' + new Date().getTime(), {
                                'get_files': 1,
                                'ids': $('#files').val(),
                                'id_new': parseInt(r_split[1])
                            },
                                function (res) {
                                    $('#files').html(res);
                                }
                            );
                        } else {
                            window.location = script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=download';
                        }
                    } else {
                        alert(r_split[1]);
                    }
                }
            });
        });

        // Duyệt file tài liệu
        $(document).delegate('#open_files', 'click', function (e) {
            e.preventDefault();
            nv_open_browse(script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=upload&popup=1&area=file-path&path=' + $(this).data('path') + '&type=file', 'NVImg', 850, 420, 'resizable=no,scrollbars=no,toolbar=no,location=no,status=no');
        });
    });
</script>
{/if}