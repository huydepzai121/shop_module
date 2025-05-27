{if !empty($error)}
<div class="alert alert-danger">
    {$error}
</div>
{/if}

<div class="card">
    <div class="card-header">
        <h3 class="card-title">{$LANG->getModule('supplier_list')}</h3>
        <div class="card-tools">
            <button type="button" class="btn btn-success btn-sm btn-add-supplier">
                <i class="fa fa-plus"></i> {$LANG->getModule('add_supplier')}
            </button>
        </div>
    </div>
    <div class="card-body">
        <form action="{$smarty.const.NV_BASE_ADMINURL}index.php" method="get" class="mb-4">
            <input type="hidden" name="{$smarty.const.NV_LANG_VARIABLE}" value="{$smarty.const.NV_LANG_DATA}" />
            <input type="hidden" name="{$smarty.const.NV_NAME_VARIABLE}" value="{$MODULE_NAME}" />
            <input type="hidden" name="{$smarty.const.NV_OP_VARIABLE}" value="{$OP}" />
            <div class="input-group">
                <input class="form-control" type="text" value="{$Q}" name="q" maxlength="255" placeholder="{$LANG->getModule('supplier_search')}" />
                <span class="input-group-append">
                    <button class="btn btn-primary" type="submit">
                        <i class="fa fa-search"></i> {$LANG->getModule('search')}
                    </button>
                </span>
            </div>
        </form>

        <div class="table-responsive">
            <table class="table table-striped table-bordered table-hover">
                <thead>
                    <tr>
                        <th class="w100">{$LANG->getModule('number')}</th>
                        <th>{$LANG->getModule('supplier_title')}</th>
                        <th>{$LANG->getModule('supplier_phone')}</th>
                        <th>{$LANG->getModule('supplier_email')}</th>
                        <th class="w150">{$LANG->getModule('supplier_add_time')}</th>
                        <th class="w100 text-center">{$LANG->getModule('status')}</th>
                        <th class="w150">&nbsp;</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach $SUPPLIERS as $supplier}
                    <tr id="supplier-row-{$supplier.id}">
                        <td>{$supplier.weight}</td>
                        <td>{$supplier.title}</td>
                        <td>{$supplier.phone}</td>
                        <td>{$supplier.email}</td>
                        <td>{$supplier.add_time}</td>
                        <td class="text-center">
                            <button class="btn btn-sm btn-status" data-id="{$supplier.id}" data-status="{$supplier.status}">
                                {if $supplier.status}
                                <span class="badge bg-success">{$LANG->getModule('supplier_status_active')}</span>
                                {else}
                                <span class="badge bg-danger">{$LANG->getModule('supplier_status_inactive')}</span>
                                {/if}
                            </button>
                        </td>
                        <td class="text-center">
                            <button class="btn btn-info btn-sm btn-edit-supplier" data-id="{$supplier.id}">
                                <i class="fa fa-edit"></i>
                            </button>
                            <button class="btn btn-danger btn-sm btn-delete-supplier" data-id="{$supplier.id}" data-checkss="{$supplier.checkss}">
                                <i class="fa fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>

        {if !empty($GENERATE_PAGE)}
        <div class="text-center mt-4">
            {$GENERATE_PAGE}
        </div>
        {/if}
    </div>
</div>

<!-- Modal Form -->
<div class="modal fade" id="supplier-modal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modal-supplier-title"></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form id="supplier-form" action="" method="post">
                <div class="modal-body">
                    <input type="hidden" name="id" id="supplier-id" value="0" />
                    
                    <div class="row">
                        <div class="col-md-8">
                            <div class="card">
                                <div class="card-header">
                                    <h6 class="mb-0">{$LANG->getModule('supplier_info')}</h6>
                                </div>
                                <div class="card-body">
                                    <div class="form-group mb-3">
                                        <label class="form-label required">{$LANG->getModule('supplier_title')}</label>
                                        <input type="text" name="title" id="supplier-title" class="form-control" required>
                                    </div>
                                    <div class="form-group mb-3">
                                        <label class="form-label">{$LANG->getModule('supplier_alias')}</label>
                                        <div class="input-group">
                                            <input type="text" name="alias" id="supplier-alias" class="form-control">
                                            <button class="btn btn-default btn-refresh-alias" type="button" title="Làm mới">
                                                <i class="fa fa-refresh"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="form-group mb-3">
                                        <label class="form-label">{$LANG->getModule('supplier_description')}</label>
                                        <textarea name="description" id="supplier-description" class="form-control" rows="3"></textarea>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group mb-3">
                                                <label class="form-label">{$LANG->getModule('supplier_phone')}</label>
                                                <input type="text" name="phone" id="supplier-phone" class="form-control">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group mb-3">
                                                <label class="form-label">{$LANG->getModule('supplier_email')}</label>
                                                <input type="email" name="email" id="supplier-email" class="form-control">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group mb-3">
                                        <label class="form-label">{$LANG->getModule('supplier_address')}</label>
                                        <input type="text" name="address" id="supplier-address" class="form-control">
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group mb-3">
                                                <label class="form-label">{$LANG->getModule('supplier_fax')}</label>
                                                <input type="text" name="fax" id="supplier-fax" class="form-control">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group mb-3">
                                                <label class="form-label">{$LANG->getModule('supplier_website')}</label>
                                                <input type="text" name="website" id="supplier-website" class="form-control">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-header">
                                    <h6 class="mb-0">{$LANG->getModule('supplier_config')}</h6>
                                </div>
                                <div class="card-body">
                                    <div class="form-group mb-3">
                                        <label class="form-label">{$LANG->getModule('supplier_image')}</label>
                                        <div class="input-group">
                                            <input type="text" name="image" id="supplier-image" class="form-control">
                                            <button class="btn btn-default" type="button" id="selectimg">
                                                <i class="fa fa-folder-open-o"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="form-group mb-3">
                                        <label class="form-label">{$LANG->getModule('supplier_note')}</label>
                                        <textarea name="note" id="supplier-note" class="form-control" rows="3"></textarea>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label d-block">{$LANG->getModule('status')}</label>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="status" id="status1" value="1" checked>
                                            <label class="form-check-label" for="status1">{$LANG->getModule('supplier_status_active')}</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="status" id="status0" value="0">
                                            <label class="form-check-label" for="status0">{$LANG->getModule('supplier_status_inactive')}</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fa fa-times-circle me-2"></i>{$LANG->getModule('close')}
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fa fa-check-circle me-2"></i>{$LANG->getModule('save')}
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script type="text/javascript">
function get_alias(title) {
    if (title) {
        $.post(script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=' + nv_func_name, {
            get_alias: 1,
            title: title
        }, function(res) {
            if (res.status == 'OK') {
                $("#supplier-alias").val(res.alias);
            }
        });
    }
}

$(document).ready(function() {
    // Tự động tạo alias khi nhập tiêu đề
    $("#supplier-title").on("input", function() {
        var title = $(this).val();
        var alias = $("#supplier-alias");
        
        // Nếu đang focus vào ô alias thì không tự động cập nhật
        if (!alias.is(":focus")) {
            get_alias(title);
        }
    });
    
    // Nút làm mới alias
    $(".btn-refresh-alias").on("click", function(e) {
        e.preventDefault();
        var title = $("#supplier-title").val();
        get_alias(title);
    });
    
    // Mở modal khi nhấn nút thêm mới
    $(".btn-add-supplier").on("click", function(e) {
        e.preventDefault();
        $("#modal-supplier-title").text("{$LANG->getModule('add_supplier')}");
        $("#supplier-form").trigger("reset");
        $("#supplier-id").val(0);
        $("#status1").prop("checked", true);
        $("#supplier-modal").modal("show");
    });
    
    // Mở modal khi nhấn nút sửa
    $(".btn-edit-supplier").on("click", function(e) {
        e.preventDefault();
        var id = $(this).data("id");
        $("#modal-supplier-title").text("{$LANG->getModule('edit_supplier')}");
        
        $.ajax({
            type: "POST", 
            url: script_name + "?" + nv_lang_variable + "=" + nv_lang_data + "&" + nv_name_variable + "=" + nv_module_name + "&" + nv_fc_variable + "=suppliers",
            data: {
                ajax: 1,
                action: 'get_supplier',
                id: id
            },
            dataType: "json",
            success: function(res) {
                if (res.status == "OK") {
                    var data = res.data;
                    $("#supplier-id").val(data.id);
                    $("#supplier-title").val(data.title);
                    $("#supplier-alias").val(data.alias);
                    $("#supplier-description").val(data.description);
                    $("#supplier-address").val(data.address);
                    $("#supplier-phone").val(data.phone);
                    $("#supplier-email").val(data.email);
                    $("#supplier-fax").val(data.fax);
                    $("#supplier-website").val(data.website);
                    $("#supplier-image").val(data.image);
                    $("#supplier-note").val(data.note);
                    $("#status" + data.status).prop("checked", true);
                    
                    $("#supplier-modal").modal("show");
                } else {
                    alert(res.mess);
                }
            },
            error: function(xhr, status, error) {
                console.log('Error:', error);
                console.log('Status:', status);
                console.log('Response Text:', xhr.responseText);
                alert("Có lỗi xảy ra khi tải dữ liệu!");
            }
        });
    });
    
    // Xử lý khi submit form
    $("#supplier-form").on("submit", function(e) {
        e.preventDefault();
        
        var formData = $(this).serialize();
        formData += '&ajax=1&action=save_supplier';
        
        $.ajax({
            type: "POST",
            url: script_name + "?" + nv_lang_variable + "=" + nv_lang_data + "&" + nv_name_variable + "=" + nv_module_name + "&" + nv_fc_variable + "=" + nv_func_name,
            data: formData,
            dataType: "json",
            success: function(res) {
                if (res.status == "OK") {
                    nvToast(res.mess, 'success');
                    $("#supplier-modal").modal("hide");
                    
                    if ($("#supplier-row-" + res.data.id).length) {
                        var row = $("#supplier-row-" + res.data.id);
                        row.find("td:eq(1)").text(res.data.title);
                        row.find("td:eq(2)").text(res.data.phone);
                        row.find("td:eq(3)").text(res.data.email);
                        
                        var statusHtml = '';
                        if (res.data.status == 1) {
                            statusHtml = '<span class="badge bg-success">' + nv_lang_data.supplier_status_active + '</span>';
                        } else {
                            statusHtml = '<span class="badge bg-danger">' + nv_lang_data.supplier_status_inactive + '</span>';
                        }
                        row.find("td:eq(5) button").html(statusHtml);
                    } else {
                        setTimeout(function() {
                            window.location.href = window.location.href;
                        }, 1500);
                    }
                } else {
                    nvToast(res.mess, 'error');
                }
            }
        });
    });
    
    // Xử lý nút xóa
    $(".btn-delete-supplier").on("click", function(e) {
        e.preventDefault();
        var btn = $(this);
        if (confirm(nv_is_del_confirm[0])) {
            var id = btn.data("id");
            var checkss = btn.data("checkss");
            
            $.ajax({
                type: "POST",
                url: script_name + "?" + nv_lang_variable + "=" + nv_lang_data + "&" + nv_name_variable + "=" + nv_module_name + "&" + nv_fc_variable + "=" + nv_func_name,
                data: {
                    delete: 1,
                    id: id,
                    checkss: checkss
                },
                dataType: "json",
                success: function(res) {
                    if (res.status == "OK") {
                        nvToast(res.mess, 'success');
                        $("#supplier-row-" + id).fadeOut(400, function() {
                            $(this).remove();
                        });
                    } else {
                        nvToast(res.mess, 'error');
                    }
                }
            });
        }
    });
    
    // Xử lý nút thay đổi trạng thái
    $(".btn-status").on("click", function(e) {
        e.preventDefault();
        var btn = $(this);
        var id = btn.data("id");
        
        $.ajax({
            type: "POST",
            url: script_name + "?" + nv_lang_variable + "=" + nv_lang_data + "&" + nv_name_variable + "=" + nv_module_name + "&" + nv_fc_variable + "=" + nv_func_name + "&change_status&id=" + id + "&nocache=" + new Date().getTime(),
            dataType: "json",
            success: function(res) {
                if (res.status == "OK") {
                    nvToast(res.mess, 'success');
                    var newStatus = btn.find(".badge").hasClass("bg-success") ? 0 : 1;
                    var statusHtml = '';
                    if (newStatus == 1) {
                        statusHtml = '<span class="badge bg-success">' + nv_lang_data.supplier_status_active + '</span>';
                    } else {
                        statusHtml = '<span class="badge bg-danger">' + nv_lang_data.supplier_status_inactive + '</span>';
                    }
                    btn.html(statusHtml);
                } else {
                    nvToast(res.mess, 'error');
                }
            }
        });
    });
    
    // Xử lý nút chọn hình ảnh
    $("#selectimg").on("click", function(e) {
        e.preventDefault();
        var area = "supplier-image";
        var path = "{$UPLOAD_CURRENT}";
        var currentpath = "{$UPLOAD_CURRENT}";
        var type = "image";
        nv_open_browse(script_name + "?" + nv_name_variable + "=upload&popup=1&area=" + area + "&path=" + path + "&type=" + type + "&currentpath=" + currentpath, "NVImg", 850, 420, "resizable=no,scrollbars=no,toolbar=no,location=no,status=no");
    });
});
</script>