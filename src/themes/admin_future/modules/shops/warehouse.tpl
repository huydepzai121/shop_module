<link type="text/css" href="{$smarty.const.NV_STATIC_URL}{$smarty.const.NV_ASSETS_DIR}/js/jquery-ui/jquery-ui.min.css" rel="stylesheet" />
<script type="text/javascript" src="{$smarty.const.NV_STATIC_URL}{$smarty.const.NV_ASSETS_DIR}/js/jquery-ui/jquery-ui.min.js"></script>
<script type="text/javascript" src="{$smarty.const.NV_STATIC_URL}{$smarty.const.NV_ASSETS_DIR}/js/language/jquery.ui.datepicker-{$smarty.const.NV_LANG_INTERFACE}.js"></script>

<!-- Card chính -->
<div class="container-fluid py-4">
    <div class="row">
        <!-- Form nhập kho và giá -->
        <div class="col-md-8">
            <div class="card warehouse-card">
                <div class="card-header warehouse-card-header bg-primary text-white">
                    <h5 class="card-title mb-0">
                        <i class="fa fa-box-open me-2"></i> Quản lý nhập kho
                    </h5>
                </div>
                <div class="card-body">
                    <form action="" method="post" id="warehouseForm">
                        <!-- Thông tin chung -->
                        <div class="row mb-4">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-label fw-bold warehouse-required-label">Tiêu đề</label>
                                    <input type="text" name="title" value="{$ROW.title}" class="form-control" />
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-label fw-bold warehouse-required-label">Ghi chú</label>
                                    <textarea name="note" class="form-control" rows="1">{$ROW.note}</textarea>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label class="form-label fw-bold warehouse-required-label">Ngày nhập kho</label>
                                    <div class="input-group warehouse-input-group">
                                        <input type="text" class="form-control" name="from" id="from" value="{$ROW.from}" readonly />
                                        <span class="input-group-text" id="from-btn">
                                            <i class="fa fa-calendar"></i>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        {foreach from=$DATA item=DATA_ITEM}
                        <div class="card mb-4">
                            <div class="card-header bg-light d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="mb-0">
                                        <a href="{$DATA_ITEM.link}" class="text-dark">
                                            <i class="fa fa-cube me-2"></i>{$DATA_ITEM.title}
                                        </a>
                                    </h6>
                                </div>
                                <button type="button" class="btn btn-primary btn-sm btn-add">
                                    <i class="fa fa-plus-circle me-1"></i> Thêm dòng mới
                                </button>
                            </div>

                            <div class="card-body">
                                <div class="listing-body" data-product-id="{$DATA_ITEM.id}">
                                    {if !empty($DATA_ITEM.listgroup)}
                                        {foreach from=$DATA_ITEM.listgroup key=J item=GROUP_DATA}
                                        <div class="listing-item mb-4 warehouse-listing-item">
                                            <div class="card border">
                                                <div class="card-body position-relative">
                                                    {if $J > 0}
                                                    <button type="button" class="btn btn-outline-danger btn-sm btn-delete warehouse-delete-btn" title="Xóa">
                                                        <i class="fas fa-times"></i>
                                                    </button>
                                                    {/if}

                                                    <!-- Nhà cung cấp -->
                                                    <div class="row mb-3">
                                                        <div class="col-md-6">
                                                            <div class="form-group">
                                                                <label class="form-label warehouse-required-label">Nhà cung cấp</label>
                                                                <div class="input-group">
                                                                    <select name="data[{$DATA_ITEM.id}][{$J}][supplier_id]" class="form-select supplier-select">
                                                                        <option value="0">-- Chọn nhà cung cấp --</option>
                                                                        {foreach from=$SUPPLIERS item=SUPPLIER}
                                                                        <option value="{$SUPPLIER.id}">{$SUPPLIER.title}</option>
                                                                        {/foreach}
                                                                    </select>
                                                                    <button type="button" class="btn btn-success btn-add-supplier warehouse-supplier-btn">
                                                                        <i class="fa fa-plus"></i>
                                                                    </button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Thuộc tính sản phẩm -->
                                                    <div class="attribute-group warehouse-attribute-group bg-light p-3 rounded mb-3">
                                                        <h6 class="mb-3">Thuộc tính sản phẩm</h6>
                                                        <div class="row">
                                                            {foreach from=$DATA_ITEM.parent_groups item=PARENT}
                                                            {if $PARENT.in_order}
                                                            <div class="col-md-4">
                                                                <div class="form-group">
                                                                    <label class="form-label warehouse-required-label {if $PARENT.is_require}text-danger{/if}">
                                                                        {$PARENT.title}
                                                                    </label>
                                                                    <select name="data[{$DATA_ITEM.id}][{$J}][group][{$PARENT.groupid}]" 
                                                                        class="form-select group-select" 
                                                                        data-group-id="{$PARENT.groupid}"
                                                                        {if $PARENT.is_require}required{/if}>
                                                                        <option value="">Chọn thuộc tính</option>
                                                                        {if isset($DATA_ITEM.groups[$PARENT.groupid])}
                                                                        {foreach from=$DATA_ITEM.groups[$PARENT.groupid] item=GROUP}
                                                                        <option value="{$GROUP.groupid}" 
                                                                            {if isset($GROUP_DATA[$PARENT.groupid]) && $GROUP_DATA[$PARENT.groupid] eq $GROUP.groupid}selected{/if}>
                                                                            {$GROUP.title}
                                                                        </option>
                                                                        {/foreach}
                                                                        {/if}
                                                                    </select>
                                                                </div>
                                                            </div>
                                                            {/if}
                                                            {/foreach}
                                                        </div>
                                                    </div>

                                    <!-- Số lượng và giá -->
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-label warehouse-required-label">Số lượng</label>
                                                <input type="number" name="data[{$DATA_ITEM.id}][{$J}][quantity]" 
                                                    class="form-control" required
                                                    placeholder="Nhập số lượng" />
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-label warehouse-required-label">Giá nhập</label>
                                                <div class="input-group">
                                                    <input type="text" name="data[{$DATA_ITEM.id}][{$J}][price]" 
                                                        class="form-control price-input text-end" 
                                                        placeholder="Nhập giá" />
                                                    <select name="data[{$DATA_ITEM.id}][{$J}][money_unit]" class="input-group-text form-select-sm" style="width: auto;">
                                                        {foreach from=$MONEY_CONFIG key=code item=currency}
                                                        <option value="{$code}" {if $code eq $pro_config.money_unit}selected="selected"{/if}>{$code}</option>
                                                        {/foreach}
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Thành tiền -->
                                    <div class="mt-3">
                                        <div class="alert alert-light mb-0">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <span class="fw-medium">Thành tiền:</span>
                                                    <span class="total-price ms-2">0 <span class="money-unit">{$pro_config.money_unit}</span></span>
                                                </div>
                                                <div class="price-in-words text-muted small">Bằng chữ: không đồng</div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Lịch sử giá -->
                                    <div class="price-history warehouse-price-history mt-3" style="display:none;">
                                        <div class="alert alert-light mb-0">
                                            <h6 class="alert-heading d-flex align-items-center">
                                                <i class="fas fa-history me-2"></i>
                                                <span>Lịch sử giá</span>
                                            </h6>
                                            <div class="price-history-content"></div>
                                        </div>
                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        {/foreach}
                                    {else}
                                        <!-- Sản phẩm không có nhóm thuộc tính -->
                                        <div class="listing-item mb-4">
                                            <div class="card border">
                                                <div class="card-body position-relative">
                                                    <!-- Nhà cung cấp -->
                                                    <div class="row mb-3">
                                                        <div class="col-md-6">
                                                            <div class="form-group">
                                                                <label class="form-label warehouse-required-label">Nhà cung cấp</label>
                                                                <div class="input-group">
                                                                    <select name="data[{$DATA_ITEM.id}][0][supplier_id]" class="form-select supplier-select">
                                                                        <option value="0">-- Chọn nhà cung cấp --</option>
                                                                        {foreach from=$SUPPLIERS item=SUPPLIER}
                                                                        <option value="{$SUPPLIER.id}">{$SUPPLIER.title}</option>
                                                                        {/foreach}
                                                                    </select>
                                                                    <button type="button" class="btn btn-success btn-add-supplier warehouse-supplier-btn">
                                                                        <i class="fa fa-plus"></i>
                                                                    </button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Số lượng và giá -->
                                                    <div class="row">
                                                        <div class="col-md-6">
                                                            <div class="form-group">
                                                                <label class="form-label warehouse-required-label">Số lượng</label>
                                                                <input type="number" name="data[{$DATA_ITEM.id}][0][quantity]" 
                                                                    class="form-control" required
                                                                    placeholder="Nhập số lượng" />
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="form-group">
                                                                <label class="form-label warehouse-required-label">Giá nhập</label>
                                                                <div class="input-group">
                                                                    <input type="text" name="data[{$DATA_ITEM.id}][0][price]" 
                                                                        class="form-control price-input text-end" 
                                                                        placeholder="Nhập giá" />
                                                                    <select name="data[{$DATA_ITEM.id}][0][money_unit]" class="input-group-text form-select-sm" style="width: auto;">
                                                                        {foreach from=$MONEY_CONFIG key=code item=currency}
                                                                        <option value="{$code}" {if $code eq $pro_config.money_unit}selected="selected"{/if}>{$code}</option>
                                                                        {/foreach}
                                                                    </select>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Thành tiền -->
                                                    <div class="mt-3">
                                                        <div class="alert alert-light mb-0">
                                                            <div class="d-flex justify-content-between align-items-center">
                                                                <div>
                                                                    <span class="fw-medium">Thành tiền:</span>
                                                                    <span class="total-price ms-2">0 <span class="money-unit">{$pro_config.money_unit}</span></span>
                                                                </div>
                                                                <div class="price-in-words text-muted small">Bằng chữ: không đồng</div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Lịch sử giá -->
                                                    <div class="price-history warehouse-price-history mt-3" style="display:none;">
                                                        <div class="alert alert-light mb-0">
                                                            <h6 class="alert-heading d-flex align-items-center">
                                                                <i class="fas fa-history me-2"></i>
                                                                <span>Lịch sử giá</span>
                                                            </h6>
                                                            <div class="price-history-content"></div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    {/if}
                                </div>
                            </div>
                        </div>
                        {/foreach}

                        <!-- Nút submit -->
                        <div class="text-center">
                            <button type="submit" class="btn btn-primary" name="submit">
                                <i class="fa fa-save me-2"></i> Lưu lại
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Thông tin bên phải -->
        <div class="col-md-4">
            <!-- Thông tin sản phẩm -->
            <div class="card mb-3">
                <div class="card-header bg-info text-white">
                    <h5 class="card-title mb-0">
                        <i class="fa fa-info-circle me-2"></i> Thông tin sản phẩm
                    </h5>
                </div>
                <div class="card-body">
                    {foreach from=$DATA item=DATA_ITEM}
                    <div class="d-flex align-items-center mb-3">
                        <img src="{$DATA_ITEM.image_thumb}" class="me-3" style="width:60px;height:60px;object-fit:contain" />
                        <div>
                            <h6 class="mb-1">{$DATA_ITEM.title}</h6>
                            <div class="small text-muted">
                                Mã sản phẩm: #{$DATA_ITEM.id}
                            </div>
                        </div>
                    </div>
                    <div class="row g-2">
                        <div class="col-6">
                            <div class="border rounded p-2 text-center">
                                <div class="small text-muted">Tồn kho</div>
                                <div class="fw-bold">{$DATA_ITEM.product_number} {$DATA_ITEM.product_unit}</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="border rounded p-2 text-center">
                                <div class="small text-muted">Đã bán</div>
                                <div class="fw-bold">0 {$DATA_ITEM.product_unit}</div>
                            </div>
                        </div>
                    </div>
                    {/foreach}
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .warehouse-required-label::after {
        content: " *";
        color: red;
    }

    .warehouse-attribute-group {
        background: #f8f9fa;
        padding: 15px;
        border-radius: 8px;
        margin-bottom: 15px;
    }

    .warehouse-price-history {
        max-height: 300px;
        overflow-y: auto;
    }

    .warehouse-input-group .form-control {
        border-right: 0;
    }

    .warehouse-input-group .input-group-text {
        background-color: #fff;
        border-left: 0;
    }

    .warehouse-card {
        box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,0.075);
    }

    .warehouse-card-header {
        border-bottom: 0;
    }

    .warehouse-supplier-btn {
        border-radius: 0 4px 4px 0;
    }

    .warehouse-delete-btn {
        opacity: 0.7;
        transition: all 0.2s;
        width: 32px;
        height: 32px;
        padding: 0;
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 1;
    }

    .warehouse-delete-btn:hover {
        opacity: 1;
    }

    .warehouse-listing-item:first-child .warehouse-delete-btn {
        display: none;
    }
</style>

<script type="text/javascript">
$(document).ready(function() {
    $('#from').datepicker({
        dateFormat: 'dd/mm/yy',
        changeMonth: true,
        changeYear: true,
        showOtherMonths: true,
    });

    $('#from-btn').click(function() {
        $("#from").datepicker('show');
    });

    // Xử lý thêm dòng mới
    $('.btn-add').click(function() {
        var $listing = $(this).closest('.card').find('.listing-body');
        var productId = $listing.data('product-id');
        var $lastItem = $listing.find('.listing-item:last');
        var newItem = $lastItem.clone();
        
        // Tìm index cao nhất hiện tại
        var highestIndex = 0;
        $listing.find('.listing-item').each(function() {
            var name = $(this).find('select[name*="supplier_id"]').attr('name');
            var match = name.match(/data\[(\d+)?\]\[(\d+)\]/);
            if (match && parseInt(match[2]) > highestIndex) {
                highestIndex = parseInt(match[2]);
            }
        });
        var newIndex = highestIndex + 1;
        
        // Cập nhật index cho tất cả các trường trong form mới
        newItem.find('select, input').each(function() {
            var name = $(this).attr('name');
            if(name) {
                name = name.replace(/data\[(\d+)?\]\[\d+\]/, 'data[' + productId + '][' + newIndex + ']');
                $(this).attr('name', name);
            }
        });
        
        // Thêm nút xóa nếu không phải dòng đầu tiên
        if ($listing.find('.listing-item').length > 0) {
            if (!newItem.find('.btn-delete').length) {
                newItem.find('.card-body').prepend(`
                    <button type="button" class="btn btn-outline-danger btn-sm btn-delete position-absolute top-0 end-0 mt-2 me-2" title="Xóa">
                        <i class="fas fa-times"></i>
                    </button>
                `);
            }
        }
        
        // Reset các giá trị
        newItem.find('input[type="text"], input[type="number"]').val('');
        newItem.find('.price-history').hide().find('.price-history-content').empty();
        
        // Reset tất cả các select về giá trị mặc định
        newItem.find('select').each(function() {
            $(this).find('option').prop('selected', false);
            $(this).find('option:first').prop('selected', true);
        });
        
        // Thêm vào listing
        $listing.append(newItem);
    });

    // Xử lý xóa dòng
    $(document).on('click', '.btn-delete', function() {
        $(this).closest('.listing-item').remove();
    });

    // Xử lý thêm nhà cung cấp
    $('.btn-add-supplier').click(function() {
        // Xử lý thêm nhà cung cấp
    });

    // Format giá tiền
    $('.price-input').on('input', function() {
        var value = $(this).val().replace(/[^0-9.]/g, '');
        $(this).val(FormatNumber(value));
        
        // Kích hoạt tính lại tổng tiền sau khi định dạng số
        setTimeout(function() {
            updateTotalPrice($(this).closest('.row'));
        }.bind(this), 100);
    });

    // Load lịch sử giá khi chọn thuộc tính
    $('.group-select').on('change', function() {
        var $row = $(this).closest('.listing-item');
        var pro_id = $row.closest('.listing-body').data('product-id');
        var listgroup = [];
        
        $row.find('.group-select').each(function() {
            var val = $(this).val();
            if(val) listgroup.push(val);
        });
        
        if(listgroup.length > 0) {
            loadPriceHistory(pro_id, listgroup.join(','), $row);
        }
    });
});

function FormatNumber(str) {
    var strTemp = GetNumber(str);
    if (strTemp.length <= 3)
        return strTemp;
    strResult = "";
    for (var i = 0; i < strTemp.length; i++)
        strTemp = strTemp.replace(",", "");
    var m = strTemp.lastIndexOf(".");
    if (m == -1) {
        for (var i = strTemp.length; i >= 0; i--) {
            if (strResult.length > 0 && (strTemp.length - i - 1) % 3 == 0)
                strResult = "," + strResult;
            strResult = strTemp.substring(i, i + 1) + strResult;
        }
    } else {
        var strphannguyen = strTemp.substring(0, strTemp.lastIndexOf("."));
        var strphanthapphan = strTemp.substring(strTemp.lastIndexOf("."),
            strTemp.length);
        var tam = 0;
        for (var i = strphannguyen.length; i >= 0; i--) {

            if (strResult.length > 0 && tam == 4) {
                strResult = "," + strResult;
                tam = 1;
            }

            strResult = strphannguyen.substring(i, i + 1) + strResult;
            tam = tam + 1;
        }
        strResult = strResult + strphanthapphan;
    }
    return strResult;
}

function GetNumber(str) {
    if (!str) return '';
    
    // Xử lý dấu chấm thập phân
    var hasDecimal = str.indexOf('.') !== -1;
    var count = 0;
    
    for (var i = 0; i < str.length; i++) {
        var temp = str.substring(i, i + 1);
        
        // Chỉ chấp nhận số, dấu phẩy và dấu chấm
        if (!(temp == "," || temp == "." || (temp >= 0 && temp <= 9))) {
            return str.substring(0, i);
        }
        
        // Nếu gặp khoảng trắng, dừng xử lý
        if (temp == " ") {
            return str.substring(0, i);
        }
        
        // Chỉ cho phép 1 dấu chấm thập phân
        if (temp == ".") {
            if (count > 0) {
                return str.substring(0, i);
            }
            count++;
        }
    }
    
    return str;
}

// Hàm load lịch sử giá
function loadPriceHistory(pro_id, listgroup, $row) {
    $.ajax({
        url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=' + op,
        type: 'POST',
        data: {
            ajax: 1,
            func: 'get_product_price',
            pro_id: pro_id,
            listgroup: listgroup,
            checkss: '{$CHECKSS}'
        },
        dataType: 'json',
        success: function(res) {
            if(res.status == 'OK' && res.data.length > 0) {
                var html = '<div class="table-responsive"><table class="table table-sm table-bordered mt-2">';
                html += '<thead><tr><th>Loại giá</th><th>Giá</th><th>Thời gian cập nhật</th></tr></thead>';
                html += '<tbody>';
                
                res.data.forEach(function(item) {
                    html += '<tr>';
                    html += '<td>' + item.price_type_title + '</td>';
                    html += '<td class="text-end">' + formatNumber(item.price) + ' VNĐ</td>';
                    html += '<td>' + item.update_time + '</td>';
                    html += '</tr>';
                });
                
                html += '</tbody></table></div>';
                
                $row.find('.price-history').show().find('.price-history-content').html(html);
            }
        }
    });
}

// Hàm format số
function formatNumber(num) {
    if (!num) return '0';
    return num.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,');
}

// Hàm tính và cập nhật thành tiền
function updateTotalPrice($row) {
    if (!$row || !$row.length) return;
    
    var quantity = parseFloat($row.find('input[name*="[quantity]"]').val()) || 0;
    var priceInput = $row.find('input[name*="[price]"]').val();
    var price = 0;
    
    if (priceInput) {
        // Chuyển đổi định dạng số có dấu phẩy về dạng số thực
        price = parseFloat(priceInput.replace(/,/g, ''));
    }
    
    var total = quantity * price;
    var money_unit = $row.find('select[name*="[money_unit]"]').val() || '';
    
    // Cập nhật tổng tiền hiển thị
    var $totalDisplay = $row.closest('.card-body').find('.total-price');
    $totalDisplay.html(FormatNumber(total.toString()) + ' <span class="money-unit">' + money_unit + '</span>');
    
    // Cập nhật bằng chữ
    var wordsText = "Bằng chữ: " + numberToWords(Math.round(total)) + " đồng";
    $row.closest('.card-body').find('.price-in-words').text(wordsText);
    
    console.log('Tính tổng tiền:', quantity, 'x', price, '=', total, 'đơn vị:', money_unit);
}

// Bắt sự kiện khi thay đổi số lượng, đơn giá hoặc đơn vị tiền
$(document).on('input change', 'input[name*="[quantity]"], input[name*="[price]"], select[name*="[money_unit]"]', function() {
    var $row = $(this).closest('.row');
    updateTotalPrice($row);
});

// Tính toán ban đầu cho tất cả các dòng ngay khi trang đã tải xong
$(window).on('load', function() {
    setTimeout(function() {
        $('.listing-item').each(function() {
            var $rows = $(this).find('.row:has(input[name*="[quantity]"])');
            $rows.each(function() {
                updateTotalPrice($(this));
            });
        });
    }, 300);
});
</script>

<!-- Modal thêm nhà cung cấp -->
<div class="modal fade" id="addSupplierModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Thêm nhà cung cấp</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="supplier-form" method="post">
                <div class="modal-body">
                    <input type="hidden" name="id" value="0" />
                    
                    <div class="row">
                        <div class="col-md-8">
                            <div class="card">
                                <div class="card-header">
                                    <h6 class="mb-0">Thông tin nhà cung cấp</h6>
                                </div>
                                <div class="card-body">
                                    <div class="form-group mb-3">
                                        <label class="form-label required">Tên nhà cung cấp</label>
                                        <input type="text" name="title" id="supplier-title" class="form-control" required>
                                    </div>
                                    <div class="form-group mb-3">
                                        <label class="form-label">Tên định danh</label>
                                        <div class="input-group">
                                            <input type="text" name="alias" id="supplier-alias" class="form-control">
                                            <button class="btn btn-default btn-refresh-alias" type="button" title="Làm mới">
                                                <i class="fa fa-refresh"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="form-group mb-3">
                                        <label class="form-label">Mô tả</label>
                                        <textarea name="description" id="supplier-description" class="form-control" rows="3"></textarea>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group mb-3">
                                                <label class="form-label">Số điện thoại</label>
                                                <input type="text" name="phone" id="supplier-phone" class="form-control">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group mb-3">
                                                <label class="form-label">Email</label>
                                                <input type="email" name="email" id="supplier-email" class="form-control">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group mb-3">
                                        <label class="form-label">Địa chỉ</label>
                                        <input type="text" name="address" id="supplier-address" class="form-control">
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group mb-3">
                                                <label class="form-label">Fax</label>
                                                <input type="text" name="fax" id="supplier-fax" class="form-control">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group mb-3">
                                                <label class="form-label">Website</label>
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
                                    <h6 class="mb-0">Cấu hình nhà cung cấp</h6>
                                </div>
                                <div class="card-body">
                                    <div class="form-group mb-3">
                                        <label class="form-label">Hình ảnh</label>
                                        <div class="input-group">
                                            <input type="text" name="image" id="supplier-image" class="form-control">
                                            <button class="btn btn-default" type="button" id="selectimg">
                                                <i class="fa fa-folder-open-o"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="form-group mb-3">
                                        <label class="form-label">Ghi chú</label>
                                        <textarea name="note" id="supplier-note" class="form-control" rows="3"></textarea>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label d-block">Trạng thái</label>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="status" id="status1" value="1" checked>
                                            <label class="form-check-label" for="status1">Hoạt động</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="status" id="status0" value="0">
                                            <label class="form-check-label" for="status0">Không hoạt động</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fa fa-times-circle me-2"></i>Đóng
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fa fa-check-circle me-2"></i>Lưu lại
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script type="text/javascript">
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

    // Xử lý khi submit form thêm nhà cung cấp
    $("#supplier-form").on("submit", function(e) {
        e.preventDefault();
        
        // Lưu lại button đã click để mở modal
        var $sourceButton = $('.btn-add-supplier:focus').closest('.input-group').find('.supplier-select');
        
        var formData = $(this).serialize();
        formData += '&ajax=1&action=save_supplier';
        
        $.ajax({
            type: "POST",
            url: script_name + "?" + nv_lang_variable + "=" + nv_lang_data + "&" + nv_name_variable + "=" + nv_module_name + "&" + nv_fc_variable + "=suppliers",
            data: formData,
            dataType: "json",
            success: function(res) {
                if (res.status == "OK") {
                    // Thêm nhà cung cấp mới vào tất cả các select
                    $('.supplier-select').each(function() {
                        $(this).append(new Option(res.data.title, res.data.id));
                    });
                    
                    // Tự động chọn giá trị vừa thêm cho select gần nút đã click
                    if ($sourceButton.length) {
                        $sourceButton.val(res.data.id);
                    }
                    
                    // Đóng modal và reset form
                    $("#addSupplierModal").modal("hide");
                    $("#supplier-form").trigger("reset");
                    
                    // Hiển thị thông báo thành công
                    nvToast(res.mess, 'success');
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

// Hàm lấy alias
function get_alias(title) {
    if (title) {
        $.post(script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=suppliers', {
            get_alias: 1,
            title: title
        }, function(res) {
            if (res.status == 'OK') {
                $("#supplier-alias").val(res.alias);
            }
        });
    }
}

// Hàm chuyển số thành chữ tiếng Việt
function numberToWords(number) {
    var units = ["", "một", "hai", "ba", "bốn", "năm", "sáu", "bảy", "tám", "chín"];
    var teens = ["", "mười một", "mười hai", "mười ba", "mười bốn", "mười lăm", "mười sáu", "mười bảy", "mười tám", "mười chín"];
    var tens = ["", "mười", "hai mươi", "ba mươi", "bốn mươi", "năm mươi", "sáu mươi", "bảy mươi", "tám mươi", "chín mươi"];
    
    if (number === 0) return "không";
    
    function readHundreds(num) {
        var hundred = Math.floor(num / 100);
        var remainder = num % 100;
        var result = "";
        
        if (hundred > 0) {
            result += units[hundred] + " trăm ";
            if (remainder === 0) return result.trim();
        }
        
        if (remainder > 0) {
            var ten = Math.floor(remainder / 10);
            var one = remainder % 10;
            
            if (ten > 0) {
                if (ten === 1) {
                    return result + "mười " + (one > 0 ? units[one] : "");
                }
                result += tens[ten] + " ";
                if (one > 0) result += units[one];
            } else {
                if (hundred > 0) result += "lẻ ";
                result += units[one];
            }
        }
        
        return result.trim();
    }

    var billions = Math.floor(number / 1000000000);
    var millions = Math.floor((number % 1000000000) / 1000000);
    var thousands = Math.floor((number % 1000000) / 1000);
    var remainder = Math.floor(number % 1000);
    
    var result = "";
    
    if (billions > 0) {
        result += readHundreds(billions) + " tỷ ";
    }
    if (millions > 0) {
        result += readHundreds(millions) + " triệu ";
    }
    if (thousands > 0) {
        result += readHundreds(thousands) + " nghìn ";
    }
    if (remainder > 0) {
        result += readHundreds(remainder);
    }
    
    return result.trim();
}
</script>
