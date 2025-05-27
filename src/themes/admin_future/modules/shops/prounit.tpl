<div class="card border-primary border-top-0 border-start-0 border-end-0 shadow-sm">
    <div class="card-header bg-light d-flex align-items-center">
        <h5 class="card-title mb-0 fw-semibold">{$CAPTION}</h5>
    </div>
    <div class="card-body p-4">
        {if !empty($ERROR)}
        <div class="alert alert-warning alert-dismissible fade show" role="alert">
            {$ERROR}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        {/if}

        <form action="{$CURRENT_URL}" method="post" class="ajax-submit" data-callback="refreshProductUnits">
            <input type="hidden" name="id" value="{$DATA.id}" />
            <input type="hidden" name="savecat" value="1" />
            <div class="row mb-4">
                <label class="col-sm-3 col-lg-2 col-form-label fw-medium text-sm-end">{$LANG->getModule('title_product_unit')}</label>
                <div class="col-sm-9 col-lg-7 col-xl-6">
                    <input class="form-control form-control-lg required" type="text" name="title" value="{$DATA.title}" placeholder="{$LANG->getModule('title')}" />
                    <div class="invalid-feedback"></div>
                </div>
            </div>
            <div class="row mb-4">
                <label class="col-sm-3 col-lg-2 col-form-label fw-medium text-sm-end">{$LANG->getModule('note')}</label>
                <div class="col-sm-9 col-lg-7 col-xl-6">
                    <input class="form-control" type="text" name="note" value="{$DATA.note}" placeholder="{$LANG->getModule('note')}" />
                </div>
            </div>
            <div class="row">
                <div class="col-sm-9 offset-sm-3 offset-lg-2">
                    <button class="btn btn-primary px-4" type="submit">
                        <i class="fa-solid fa-save me-2"></i>{$LANG->getModule('save')}
                    </button>
                </div>
            </div>
        </form>

        {if !empty($ROWS)}
        <div class="mt-5 mb-3">
            <h5 class="border-bottom pb-2">{$LANG->getModule('list_product_unit')}</h5>
        </div>
        <div class="table-responsive" id="prounit-list">
            <table class="table table-striped table-hover align-middle">
                <thead class="table-light">
                    <tr>
                        <th>{$LANG->getModule('title_product_unit')}</th>
                        <th>{$LANG->getModule('note')}</th>
                        <th class="text-center" style="width: 150px">{$LANG->getModule('function')}</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$ROWS item=row}
                    <tr id="row_{$row.id}">
                        <td class="fw-medium">{$row.title}</td>
                        <td>{$row.note}</td>
                        <td class="text-center">
                            <div class="btn-group" role="group">
                                <a href="{$row.link_edit}" class="btn btn-outline-primary btn-sm" data-bs-toggle="tooltip" title="{$LANG->getModule('edit')}">
                                    <i class="fa-solid fa-edit"></i>
                                </a>
                                <a 
                                   href="javascript:void(0);" 
                                   onclick="deleteProductUnit({$row.id})" 
                                   class="btn btn-outline-danger btn-sm" 
                                   data-bs-toggle="tooltip" 
                                   title="{$LANG->getModule('delete')}">
                                    <i class="fa-solid fa-trash"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>
        {/if}
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Initialize tooltips
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
});

// Xóa đơn vị sản phẩm theo ID
function deleteProductUnit(id) {
    // Xác nhận xóa
    nvConfirm('{$LANG->getModule("delete_confirm")}', function() {
        $.ajax({
            type: 'POST',
            url: '{$CURRENT_URL}',
            data: {
                ajaxdel: 1,
                id: id
            },
            dataType: 'json',
            success: function(response) {
                if (response.status === 'OK') {
                    // Hiển thị thông báo thành công
                    nvToast(response.mess, 'success');
                    
                    // Xóa hàng khỏi bảng
                    $('#row_' + id).fadeOut(400, function() {
                        $(this).remove();
                        
                        // Kiểm tra nếu không còn hàng nào thì tải lại trang
                        if ($('#prounit-list tbody tr').length === 0) {
                            setTimeout(function() {
                                window.location.reload();
                            }, 1000);
                        }
                    });
                } else {
                    // Hiển thị thông báo lỗi
                    nvToast(response.mess, 'error');
                }
            },
            error: function(xhr, textStatus, errorThrown) {
                nvToast('Lỗi kết nối: ' + textStatus, 'error');
            }
        });
    });
}

// Xử lý sau khi thêm/cập nhật đơn vị sản phẩm
function refreshProductUnits(response) {
    if (response.status === 'OK') {
        // Làm mới form
        $('form.ajax-submit')[0].reset();
        $('form.ajax-submit input[name="id"]').val('0');
        
        // Tải lại trang sau 1.5 giây
        setTimeout(function() {
            window.location.reload();
        }, 1500);
        
        return true;
    }
    return false;
}
</script>
