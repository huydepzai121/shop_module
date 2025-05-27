<link rel="stylesheet" href="{$smarty.const.NV_BASE_SITEURL}{$smarty.const.NV_ASSETS_DIR}/js/select2/select2.min.css">
<link type="text/css" href="{$smarty.const.NV_STATIC_URL}{$smarty.const.NV_ASSETS_DIR}/js/jquery-ui/jquery-ui.min.css" rel="stylesheet" />
<script type="text/javascript" src="{$smarty.const.NV_STATIC_URL}{$smarty.const.NV_ASSETS_DIR}/js/jquery-ui/jquery-ui.min.js"></script>
<script type="text/javascript" src="{$smarty.const.NV_STATIC_URL}{$smarty.const.NV_ASSETS_DIR}/js/language/jquery.ui.datepicker-{$smarty.const.NV_LANG_INTERFACE}.js"></script>
<script type="text/javascript" src="{$smarty.const.NV_BASE_SITEURL}{$smarty.const.NV_ASSETS_DIR}/js/select2/select2.min.js"></script>
<div class="card">
    <div class="card-header">
        <h3 class="card-title">{$LANG->getModule('guarantee_list')}</h3>
        <div class="card-tools">
            <a href="javascript:void(0);" onclick="$('#guaranteeModal').modal('show');" class="btn btn-success btn-sm">
                <i class="fa fa-plus"></i> {$LANG->getModule('guarantee_add')}
            </a>
        </div>
    </div>
    <div class="card-body">
        <form action="{$smarty.const.NV_BASE_ADMINURL}index.php" method="get" class="mb-4">
            <input type="hidden" name="{$smarty.const.NV_LANG_VARIABLE}" value="{$smarty.const.NV_LANG_DATA}" />
            <input type="hidden" name="{$smarty.const.NV_NAME_VARIABLE}" value="{$MODULE_NAME}" />
            <input type="hidden" name="{$smarty.const.NV_OP_VARIABLE}" value="guarantee" />
            
            <div class="card">
                <div class="card-header bg-light">
                    <h5 class="mb-0">
                        <i class="fa fa-search me-2"></i>{$LANG->getModule('search')}
                    </h5>
                </div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-label">{$LANG->getModule('search_key')}</label>
                                <input type="text" class="form-control" name="keyword" value="{$SEARCH.keyword}" placeholder="{$LANG->getModule('search_key')}" />
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group">
                                <label class="form-label">{$LANG->getModule('product')}</label>
                                <select class="form-select" name="product_id">
                                    <option value="0">{$LANG->getModule('all_products')}</option>
                                    {foreach from=$PRODUCTS item=product}
                                        <option value="{$product.id}"{if $SEARCH.product_id == $product.id} selected{/if}>{$product.title}</option>
                                    {/foreach}
                                </select>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-label">{$LANG->getModule('from_date')}</label>
                                <div class="input-group">
                                    <input type="text" class="form-control datepicker" name="date_from" value="{$SEARCH.date_from}" placeholder="{$LANG->getModule('from_date')}" autocomplete="off" />
                                    <span class="input-group-text"><i class="fa fa-calendar"></i></span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-label">{$LANG->getModule('to_date')}</label>
                                <div class="input-group">
                                    <input type="text" class="form-control datepicker" name="date_to" value="{$SEARCH.date_to}" placeholder="{$LANG->getModule('to_date')}" autocomplete="off" />
                                    <span class="input-group-text"><i class="fa fa-calendar"></i></span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label class="form-label">{$LANG->getModule('status')}</label>
                                <select class="form-select" name="status">
                                    <option value="-1">{$LANG->getModule('all_status')}</option>
                                    {foreach from=$ARRAY_STATUS key=status_id item=status_name}
                                        <option value="{$status_id}"{if $SEARCH.status == $status_id} selected{/if}>{$status_name}</option>
                                    {/foreach}
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card-footer text-end">
                    <button type="submit" class="btn btn-primary">
                        <i class="fa fa-search me-1"></i> {$LANG->getModule('search')}
                    </button>
                </div>
            </div>
        </form>

        <div class="table-responsive">
            <table class="table table-striped table-bordered table-hover">
                <thead>
                    <tr>
                        <th>{$LANG->getModule('warranty_code')}</th>
                        <th>{$LANG->getModule('product')}</th>
                        <th>{$LANG->getModule('customer')}</th>
                        <th>{$LANG->getModule('serial_number')}</th>
                        <th>{$LANG->getModule('warranty_date')}</th>
                        <th>{$LANG->getModule('status')}</th>
                        <th>{$LANG->getModule('action')}</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$DATA item=row}
                    <tr>
                        <td>{$row.warranty_code}</td>
                        <td>{$row.product_name}</td>
                        <td>
                            {$row.customer_name}<br/>
                            {$row.customer_phone}<br/>
                            {$row.customer_address}
                        </td>
                        <td>{$row.serial_number}</td>
                        <td>
                            {$LANG->getModule('from')}: {$row.warranty_start}<br/>
                            {$LANG->getModule('to')}: {$row.warranty_end}
                        </td>
                        <td>{$row.status_text}</td>
                        <td class="text-center">
                            <a href="javascript:void(0);" onclick="editGuarantee({$row.id})" class="btn btn-sm btn-info" title="{$LANG->getModule('edit')}">
                                <i class="fa fa-edit"></i>
                            </a>
                            <a href="javascript:void(0);" onclick="nv_del_guarantee({$row.id})" class="btn btn-sm btn-danger" title="{$LANG->getModule('delete')}">
                                <i class="fa fa-trash"></i>
                            </a>
                        </td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>

        {if $PAGES}
        <div class="text-center">
            {$PAGES}
        </div>
        {/if}
    </div>
</div>


<div class="modal fade" id="guaranteeModal" tabindex="-1" aria-labelledby="guaranteeModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="modal-title">
                    <i class="fa fa-plus-circle me-2"></i>
                    {$LANG->getModule('guarantee_add')}
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="" method="post" id="guarantee-form">
                <div class="modal-body">
                    <div class="row g-4">
                        <!-- Cột trái -->
                        <div class="col-md-6">
                            <div class="card border h-100">
                                <div class="card-header bg-light">
                                    <h6 class="mb-0 fw-bold">
                                        <i class="fa fa-box me-2"></i>
                                        {$LANG->getModule('product_info')}
                                    </h6>
                                </div>
                                <div class="card-body">
                                    <div class="mb-4">
                                        <label class="form-label fw-bold">{$LANG->getModule('product')} <span class="text-danger">(*)</span></label>
                                        <select name="product_id" class="form-select form-select-lg" required>
                                            <option value="">{$LANG->getModule('product_chose')}</option>
                                            {foreach from=$PRODUCTS item=product}
                                                <option value="{$product.id}">{$product.title}</option>
                                            {/foreach}
                                        </select>
                                    </div>
                                    
                                    <div class="row mb-4">
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold">{$LANG->getModule('warranty_code')} <span class="text-danger">(*)</span></label>
                                            <input type="text" class="form-control form-control-lg" name="warranty_code" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold">{$LANG->getModule('serial_number')} <span class="text-danger">(*)</span></label>
                                            <input type="text" class="form-control form-control-lg" name="serial_number" required>
                                        </div>
                                    </div>
                                    
                                    <div class="row mb-4">
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold">{$LANG->getModule('warranty_start')} <span class="text-danger">(*)</span></label>
                                            <div class="input-group">
                                                <input type="text" class="form-control form-control-lg" name="warranty_start" id="warranty_start" autocomplete="off">
                                                <span class="input-group-text"><i class="fa fa-calendar"></i></span>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold">{$LANG->getModule('warranty_end')} <span class="text-danger">(*)</span></label>
                                            <div class="input-group">
                                                <input type="text" class="form-control form-control-lg" name="warranty_end" id="warranty_end" autocomplete="off">
                                                <span class="input-group-text"><i class="fa fa-calendar"></i></span>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="mb-4">
                                        <label class="form-label fw-bold">{$LANG->getModule('warranty_status')}</label>
                                        <select name="warranty_status" class="form-select form-select-lg">
                                            {foreach from=$ARRAY_STATUS key=status_id item=status_name}
                                                <option value="{$status_id}">{$status_name}</option>
                                            {/foreach}
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Cột phải -->
                        <div class="col-md-6">
                            <div class="card border h-100">
                                <div class="card-header bg-light">
                                    <h6 class="mb-0 fw-bold">
                                        <i class="fa fa-user me-2"></i>
                                        {$LANG->getModule('customer_info')}
                                    </h6>
                                </div>
                                <div class="card-body">
                                    <div class="mb-4">
                                        <label class="form-label fw-bold">{$LANG->getModule('customer_name')} <span class="text-danger">(*)</span></label>
                                        <input type="text" class="form-control form-control-lg" name="customer_name" required>
                                    </div>
                                    
                                    <div class="mb-4">
                                        <label class="form-label fw-bold">{$LANG->getModule('customer_phone')} <span class="text-danger">(*)</span></label>
                                        <input type="text" class="form-control form-control-lg" name="customer_phone" required>
                                    </div>
                                    
                                    <div class="mb-4">
                                        <label class="form-label fw-bold">{$LANG->getModule('customer_address')}</label>
                                        <textarea class="form-control form-control-lg" name="customer_address" rows="3"></textarea>
                                    </div>
                                    
                                    <div class="mb-4">
                                        <label class="form-label fw-bold">{$LANG->getModule('note')}</label>
                                        <textarea class="form-control form-control-lg" name="note" rows="3"></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <input type="hidden" name="action" value="add">
                    <button type="button" class="btn btn-secondary btn-lg" data-bs-dismiss="modal">
                        <i class="fa fa-times-circle me-2"></i>{$LANG->getModule('close')}
                    </button>
                    <button type="submit" class="btn btn-primary btn-lg">
                        <i class="fa fa-check-circle me-2"></i>{$LANG->getModule('save')}
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
<style>
    #ui-datepicker-div {
        z-index: 99999 !important;
    }
</style>

<script type="text/javascript">
$(document).ready(function() {
    $("#warranty_start, #warranty_end").datepicker({
        dateFormat: "dd/mm/yy",
        changeMonth: true,
        changeYear: true,
        showOtherMonths: true,
        selectOtherMonths: true,
        yearRange: "2000:2030"
    });

    $('#guarantee-form').on('submit', function(e) {
        e.preventDefault();
        var data = $(this).serialize();
        data = data.replace('action=add', 'action=save');
        var form = $(this);
        
        $.ajax({
            url: script_name + '?' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=guarantee&nocache=' + new Date().getTime(),
            method: 'POST',
            data: data,
            success: function(res) {
                if (res.status == 'OK') {
                    $('#guaranteeModal').modal('hide');
                    form[0].reset();
                    setTimeout(function() {
                        nvToast(res.mess, 'success');
                        setTimeout(function() {
                            window.location.href = window.location.href;
                        }, 1500);
                    }, 500);
                } else {
                    nvToast(res.mess, 'error'); 
                }
            }
        });
    });

    $('#guaranteeModal').on('hidden.bs.modal', function () {
        var form = $('#guarantee-form');
        form[0].reset();
        form.find('input[name="id"]').remove();
        form.find('input[name="action"]').val('add');
        $('#modal-title').text('{$LANG->getModule('guarantee_add')}');
    });

    $('select[name="product_id"]').on('change', function() {
        if($('input[name="action"]').val() == 'add') {
            var product_id = $(this).val();
            if(product_id > 0) {
                var timestamp = new Date().getTime();
                var warranty_code = 'BH' + product_id + timestamp;
                $('input[name="warranty_code"]').val(warranty_code);
            } else {
                $('input[name="warranty_code"]').val('');
            }
        }
    });
});

function editGuarantee(id) {
    $.ajax({
        url: script_name + '?' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=guarantee&nocache=' + new Date().getTime(),
        method: 'POST',
        data: {
            action: 1,
            id: id
        },
        success: function(res) {
            try {
                if (res.status == 'OK') {
                    var form = $('#guarantee-form');
                    $('#modal-title').text('{$LANG->getModule('guarantee_edit')}');
                    form[0].reset();
                    form.find('select[name="product_id"]').val(res.data.product_id);
                    form.find('input[name="warranty_code"]').val(res.data.warranty_code);
                    form.find('input[name="serial_number"]').val(res.data.serial_number);
                    form.find('input[name="warranty_start"]').val(res.data.warranty_start);
                    form.find('input[name="warranty_end"]').val(res.data.warranty_end);
                    form.find('input[name="customer_name"]').val(res.data.customer_name);
                    form.find('input[name="customer_phone"]').val(res.data.customer_phone);
                    form.find('textarea[name="customer_address"]').val(res.data.customer_address);
                    form.find('select[name="warranty_status"]').val(res.data.warranty_status);
                    form.find('textarea[name="note"]').val(res.data.note);
                    
                    // Cập nhật action và id
                    form.find('input[name="id"]').remove();
                    form.append('<input type="hidden" name="id" value="' + res.data.id + '">');
                    form.find('input[name="action"]').val('edit');
                    
                    $('#guaranteeModal').modal('show');
                } else {
                    nvToast(res.mess, 'error');
                }
            } catch(e) {
                console.log(e);
                nvToast('Error loading data', 'error');
            }
        }
    });
}

function nv_del_guarantee(id) {
    if (confirm(nv_is_del_confirm[0])) {
        $.ajax({
            url: script_name + '?' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=guarantee&nocache=' + new Date().getTime(),
            method: 'POST',
            data: {
                delete: 1,
                id: id
            },
            success: function(res) {
                if (res.status == 'OK') {
                    nvToast(res.mess, 'success');
                    setTimeout(function() {
                        window.location.href = window.location.href;
                    }, 1500);
                } else {
                    nvToast(res.mess, 'error');
                }
            }
        });
    }
}
</script>
