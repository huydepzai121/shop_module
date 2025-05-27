<!-- Thêm CSS và JS cho jQuery UI Datepicker -->
<link type="text/css" href="{$smarty.const.NV_STATIC_URL}{$smarty.const.NV_ASSETS_DIR}/js/jquery-ui/jquery-ui.min.css" rel="stylesheet" />
<script type="text/javascript" src="{$smarty.const.NV_STATIC_URL}{$smarty.const.NV_ASSETS_DIR}/js/jquery-ui/jquery-ui.min.js"></script>
<script type="text/javascript" src="{$smarty.const.NV_STATIC_URL}{$smarty.const.NV_ASSETS_DIR}/js/language/jquery.ui.datepicker-{$smarty.const.NV_LANG_INTERFACE}.js"></script>
<link rel="stylesheet" href="{$smarty.const.NV_BASE_SITEURL}themes/admin_future/css/dataTables.bootstrap5.min.css">
<script src="{$smarty.const.NV_BASE_SITEURL}themes/admin_future/js/jquery.dataTables.min.js"></script>
<script src="{$smarty.const.NV_BASE_SITEURL}themes/admin_future/js/dataTables.bootstrap5.min.js"></script>

<div class="warehouse-logs position-relative">
    <div class="card border-primary border-top-0 border-3 border-start-0 border-end-0 mb-4 rounded shadow-sm">
        <div class="card-header bg-light d-flex align-items-center">
            <i class="fas fa-history me-2 text-primary"></i>
            <h5 class="card-title mb-0 fw-bold">{$LANG->getModule('warehouse_logs')}</h5>
        </div>
        <div class="card-body pt-4">
            {if empty($WAREHOUSE)}
            
            <!-- Form tìm kiếm -->
            <div class="card mb-4 border-0 bg-light rounded-lg">
                <div class="card-body">
                    <form id="search_form" action="{$BACK_URL}" method="get" class="row g-3 align-items-end">
                        <div class="col-md-4">
                            <label class="form-label fw-medium">{$LANG->getModule('search_key')}</label>
                            <div class="input-group">
                                <span class="input-group-text bg-white"><i class="fas fa-search text-muted"></i></span>
                                <input type="text" class="form-control" name="keywords" value="{$SEARCH.keywords}" placeholder="{$LANG->getModule('search_note')}">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-medium">{$LANG->getModule('from_date')}</label>
                            <div class="input-group">
                                <input type="text" class="form-control" placeholder="{$LANG->getModule('from_date')}" value="{$SEARCH.from}" name="from" id="from" autocomplete="off">
                                <span class="input-group-text bg-white" id="from-btn"><i class="far fa-calendar-alt text-muted"></i></span>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-medium">{$LANG->getModule('to_date')}</label>
                            <div class="input-group">
                                <input type="text" class="form-control" placeholder="{$LANG->getModule('to_date')}" value="{$SEARCH.to}" name="to" id="to" autocomplete="off">
                                <span class="input-group-text bg-white" id="to-btn"><i class="far fa-calendar-alt text-muted"></i></span>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-primary w-100 d-flex align-items-center justify-content-center">
                                <i class="fas fa-filter me-2"></i> {$LANG->getModule('search')}
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table table-striped table-hover border mb-0" id="warehouseLogs">
                    <thead class="table-light">
                        <tr>
                            <th class="text-center" width="60">{$LANG->getModule('setting_stt')}</th>
                            <th>{$LANG->getModule('title')}</th>
                            <th>{$LANG->getModule('supplier')}</th>
                            <th>{$LANG->getModule('user_payment')}</th>
                            <th class="text-center" width="150">{$LANG->getModule('warehouse_time')}</th>
                            <th class="text-center" width="100">{$LANG->getModule('function')}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach from=$WAREHOUSES item=WAREHOUSE}
                        <tr class="warehouse-row align-middle">
                            <td class="text-center">{$WAREHOUSE.no}</td>
                            <td>
                                <a href="javascript:void(0);" class="fw-medium text-decoration-none warehouse-title view-detail" data-wid="{$WAREHOUSE.wid}">{$WAREHOUSE.title}</a>
                                {if !empty($WAREHOUSE.note)}
                                <div class="small text-muted mt-1 fst-italic">{$WAREHOUSE.note}</div>
                                {/if}
                            </td>
                            <td>
                                {if !empty($WAREHOUSE.supplier_name)}
                                <span class="badge bg-secondary rounded-pill px-3 py-2">{$WAREHOUSE.supplier_name}</span>
                                {else}
                                <span class="text-muted">--</span>
                                {/if}
                            </td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="bg-primary bg-opacity-10 rounded-circle p-2 me-2 d-flex align-items-center justify-content-center" style="width: 32px; height: 32px;">
                                        <i class="fas fa-user text-primary"></i>
                                    </div>
                                    <span>{$WAREHOUSE.full_name}</span>
                                </div>
                            </td>
                            <td class="text-center">
                                <div class="d-flex align-items-center justify-content-center">
                                    <i class="far fa-clock me-2 text-muted"></i>
                                    <span>{$WAREHOUSE.addtime}</span>
                                </div>
                            </td>
                            <td class="text-center">
                                <button type="button" class="btn btn-sm btn-outline-info view-detail" data-wid="{$WAREHOUSE.wid}" data-bs-toggle="tooltip" title="{$LANG->getModule('view_detail')}">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </td>
                        </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
            {else}
            <div class="warehouse-detail">
                <!-- Thông tin chung -->
                <div class="card mb-4 rounded shadow-sm">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <div>
                            <h5 class="mb-0 fw-bold">{$WAREHOUSE.title}</h5>
                            <div class="small text-white-50">ID: {$WAREHOUSE.wid}</div>
                        </div>
                        <a href="{$BACK_URL}" class="btn btn-sm btn-light d-flex align-items-center">
                            <i class="fas fa-arrow-left me-2"></i> {$LANG->getModule('back')}
                        </a>
                    </div>
                    <div class="card-body">
                        <div class="row g-4">
                            <div class="col-md-4">
                                <div class="warehouse-info-item">
                                    <div class="d-flex align-items-center mb-2">
                                        <div class="bg-primary bg-opacity-10 rounded-circle p-2 me-3 d-flex align-items-center justify-content-center" style="width: 36px; height: 36px;">
                                            <i class="fas fa-user text-primary"></i>
                                        </div>
                                        <label class="fw-medium">{$LANG->getModule('user_payment')}</label>
                                    </div>
                                    <div class="ps-5 fw-medium">{$WAREHOUSE.full_name}</div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="warehouse-info-item">
                                    <div class="d-flex align-items-center mb-2">
                                        <div class="bg-success bg-opacity-10 rounded-circle p-2 me-3 d-flex align-items-center justify-content-center" style="width: 36px; height: 36px;">
                                            <i class="fas fa-calendar-alt text-success"></i>
                                        </div>
                                        <label class="fw-medium">{$LANG->getModule('warehouse_time')}</label>
                                    </div>
                                    <div class="ps-5 fw-medium">{$WAREHOUSE.addtime}</div>
                                </div>
                            </div>
                            {if !empty($WAREHOUSE.note)}
                            <div class="col-12">
                                <div class="alert alert-light border">
                                    <div class="d-flex">
                                        <div class="bg-warning bg-opacity-10 rounded-circle p-2 me-3 d-flex align-items-center justify-content-center" style="width: 36px; height: 36px;">
                                            <i class="fas fa-sticky-note text-warning"></i>
                                        </div>
                                        <div>
                                            <h6 class="fw-bold mb-2">{$LANG->getModule('content_note')}</h6>
                                            <div>{$WAREHOUSE.note}</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            {/if}
                        </div>
                    </div>
                </div>

                <!-- Chi tiết nhập kho -->
                <div class="card rounded shadow-sm">
                    <div class="card-header bg-light d-flex align-items-center">
                        <i class="fas fa-list-ul me-2 text-primary"></i>
                        <h5 class="mb-0 fw-bold">{$LANG->getModule('warehouse_detail_info')}</h5>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th width="50" class="text-center">{$LANG->getModule('setting_stt')}</th>
                                        <th>{$LANG->getModule('name')}</th>
                                        <th>{$LANG->getModule('supplier')}</th>
                                        {if $WAREHOUSE.has_groups}
                                        <th>{$LANG->getModule('warehouse_group')}</th>
                                        {/if}
                                        <th class="text-end" width="100">{$LANG->getModule('warehouse_quantity')}</th>
                                        <th class="text-end" width="150">{$LANG->getModule('warehouse_price')}</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {foreach from=$WAREHOUSE.logs item=LOG}
                                    <tr>
                                        <td class="text-center">{$LOG@iteration}</td>
                                        <td>
                                            {if !empty($LOG.link)}
                                            <a href="{$LOG.link}" class="text-decoration-none fw-medium d-flex align-items-center">
                                                <i class="fas fa-box me-2 text-secondary"></i>
                                                {$LOG.title}
                                            </a>
                                            {else}
                                            <span class="fw-medium d-flex align-items-center">
                                                <i class="fas fa-box me-2 text-secondary"></i>
                                                {$LOG.title}
                                            </span>
                                            {/if}
                                        </td>
                                        <td>
                                            {if !empty($LOG.supplier_name)}
                                            <span class="badge bg-secondary rounded-pill">{$LOG.supplier_name}</span>
                                            {else}
                                            <span class="text-muted">--</span>
                                            {/if}
                                        </td>
                                        {if $WAREHOUSE.has_groups}
                                        <td>
                                            {if !empty($LOG.group_info)}
                                            <div class="d-flex flex-wrap gap-2">
                                                {foreach from=$LOG.group_info item=GROUP_INFO}
                                                <div class="badge bg-light text-dark p-2 d-inline-flex align-items-center border">
                                                    {foreach from=$GROUP_INFO.groups item=GROUP}
                                                    <span class="badge bg-success me-1" data-bs-toggle="tooltip" title="{$GROUP.parent_title}">{$GROUP.title}</span>
                                                    {/foreach}
                                                    
                                                    {if !empty($GROUP_INFO.quantity)}
                                                    <span class="badge bg-info ms-1" data-bs-toggle="tooltip" title="{$LANG->getModule('warehouse_quantity')}">{$GROUP_INFO.quantity}</span>
                                                    {/if}
                                                    
                                                    {if !empty($GROUP_INFO.price_format)}
                                                    <span class="badge bg-warning ms-1" data-bs-toggle="tooltip" title="{$LANG->getModule('warehouse_price')}">{$GROUP_INFO.price_format} {$LOG.money_unit}</span>
                                                    {/if}
                                                </div>
                                                {/foreach}
                                            </div>
                                            {else}
                                            <span class="text-muted">--</span>
                                            {/if}
                                        </td>
                                        {/if}
                                        <td class="text-end fw-bold">{$LOG.total_quantity}</td>
                                        <td class="text-end">{if !empty($LOG.price)}{number_format($LOG.price)} {$LOG.money_unit}{else}--{/if}</td>
                                    </tr>
                                    {/foreach}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            {/if}
        </div>
    </div>
</div>

<div class="modal fade" id="warehouseDetailModal" tabindex="-1" aria-labelledby="warehouseDetailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="warehouseDetailModalLabel">
                    <i class="fas fa-info-circle me-2"></i>
                    <span id="modal-title">Chi tiết nhập kho</span>
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-0">
                <div id="warehouse-detail-content">
                    <!-- Nội dung chi tiết nhập kho sẽ được load động -->
                    <div class="text-center py-5">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Đang tải...</span>
                        </div>
                        <p class="mt-3">Đang tải thông tin nhập kho...</p>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="fas fa-times me-2"></i>Đóng
                </button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
var checksess = '{$CHECKSESS}';
var warehouseModal;

$(document).ready(function() {
    // Khởi tạo datepicker
    $("#from,#to").datepicker({
        dateFormat: "dd/mm/yy",
        changeMonth: true,
        changeYear: true,
        showOtherMonths: true,
        showOn: 'focus'
    });
    
    $('#to-btn').click(function(){
        $("#to").datepicker('show');
    });
    
    $('#from-btn').click(function(){
        $("#from").datepicker('show');
    });

    // Khởi tạo DataTable với các tùy chọn mới
    var otable = $('#warehouseLogs').DataTable({
        "pageLength": 25,
        "lengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "Tất cả"]],
        "language": {
            "lengthMenu": "Hiển thị _MENU_ dữ liệu/trang",
            "search": "{$LANG->getModule('datatable_search')}",
            "info": "Hiển thị từ _START_ đến _END_ của _TOTAL_ dòng",
            "zeroRecords": "Không tìm thấy dữ liệu",
            "infoFiltered": "(lọc từ _MAX_ dòng)",
            "infoEmpty": "Không có dữ liệu",
            "paginate": {
                "first": "&laquo;",
                "last": "&raquo;",
                "next": "&rsaquo;",
                "previous": "&lsaquo;"
            }
        },
        "dom": '<"top d-flex justify-content-between align-items-center mb-3"lf>rt<"bottom d-flex justify-content-between align-items-center mt-3"ip>',
        "responsive": true,
        "ordering": true,
        "autoWidth": false
    });

    // Tùy chỉnh style cho các phần tử DataTable
    $('.dataTables_length select').addClass('form-select form-select-sm');
    $('.dataTables_filter input').addClass('form-control form-control-sm');
    $('.dataTables_filter input').attr('placeholder', 'Tìm kiếm nhanh...');
    $('.dataTables_filter label').addClass('d-flex align-items-center');
    $('.dataTables_filter label').html('<i class="fas fa-search me-2 text-muted"></i>' + $('.dataTables_filter input')[0].outerHTML);

    // Xử lý submit form tìm kiếm
    $('#search_form').on('submit', function(e) {
        e.preventDefault();
        otable.draw();
    });

    // Khởi tạo tooltips
    initTooltips();
    
    // Khởi tạo modal
    warehouseModal = new bootstrap.Modal(document.getElementById('warehouseDetailModal'));
    
    // Hiệu ứng hover cho hàng
    $(".warehouse-row").hover(
        function() {
            $(this).find(".warehouse-title").addClass("text-primary");
        },
        function() {
            $(this).find(".warehouse-title").removeClass("text-primary");
        }
    );
    
    // Xử lý sự kiện xem chi tiết nhập kho
    $(document).on('click', '.view-detail', function() {
        var wid = $(this).data('wid');
        loadWarehouseDetail(wid);
    });
});

// Hàm khởi tạo tooltips
function initTooltips() {
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl, {
            trigger: 'hover',
            placement: 'top'
        });
    });
}

// Hàm load chi tiết nhập kho
function loadWarehouseDetail(wid) {
    // Hiển thị loading
    $('#warehouse-detail-content').html(
        '<div class="text-center py-5">' +
        '<div class="spinner-border text-primary" role="status">' +
        '<span class="visually-hidden">Đang tải...</span>' +
        '</div>' +
        '<p class="mt-3">Đang tải thông tin nhập kho...</p>' +
        '</div>'
    );
    
    // Hiển thị modal
    warehouseModal.show();
    
    $.ajax({
        url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=warehouse_logs',
        type: 'POST',
        data: {
            action: 'get_detail',
            wid: wid,
            checkss: checksess
        },
        dataType: 'json',
        success: function(response) {
            console.log('AJAX response:', response);
            
            if (response && response.status === 'OK') {
                $('#modal-title').text(response.data.title || 'Chi tiết nhập kho');
                try {
                    var hasGroups = false;
                    if (response.data.logs && response.data.logs.length > 0) {
                        response.data.logs.forEach(function(log) {
                            if (log.group_info && log.group_info.length > 0) {
                                hasGroups = true;
                                return false;
                            }
                        });
                    }
                    
                    var html = 
                        '<div class="warehouse-detail">' +
                            '<!-- Thông tin chung -->' +
                            '<div class="card m-3 rounded shadow-sm">' +
                                '<div class="card-body">' +
                                    '<div class="row g-4">' +
                                        '<div class="col-md-4">' +
                                            '<div class="warehouse-info-item">' +
                                                '<div class="d-flex align-items-center mb-2">' +
                                                    '<div class="bg-primary bg-opacity-10 rounded-circle p-2 me-3 d-flex align-items-center justify-content-center" style="width: 36px; height: 36px;">' +
                                                        '<i class="fas fa-user text-primary"></i>' +
                                                    '</div>' +
                                                    '<label class="fw-medium">' + response.lang.user_payment + '</label>' +
                                                '</div>' +
                                                '<div class="ps-5 fw-medium">' + response.data.full_name + '</div>' +
                                            '</div>' +
                                        '</div>' +
                                        '<div class="col-md-4">' +
                                            '<div class="warehouse-info-item">' +
                                                '<div class="d-flex align-items-center mb-2">' +
                                                    '<div class="bg-success bg-opacity-10 rounded-circle p-2 me-3 d-flex align-items-center justify-content-center" style="width: 36px; height: 36px;">' +
                                                        '<i class="fas fa-calendar-alt text-success"></i>' +
                                                    '</div>' +
                                                    '<label class="fw-medium">' + response.lang.warehouse_time + '</label>' +
                                                '</div>' +
                                                '<div class="ps-5 fw-medium">' + response.data.addtime + '</div>' +
                                            '</div>' +
                                        '</div>';
                                        
                    // Thêm ghi chú nếu có
                    if (response.data.note) {
                        html += '<div class="col-12">' +
                            '<div class="alert alert-light border">' +
                                '<div class="d-flex">' +
                                    '<div class="bg-warning bg-opacity-10 rounded-circle p-2 me-3 d-flex align-items-center justify-content-center" style="width: 36px; height: 36px;">' +
                                        '<i class="fas fa-sticky-note text-warning"></i>' +
                                    '</div>' +
                                    '<div>' +
                                        '<h6 class="fw-bold mb-2">' + response.lang.content_note + '</h6>' +
                                        '<div>' + response.data.note + '</div>' +
                                    '</div>' +
                                '</div>' +
                            '</div>' +
                        '</div>';
                    }
                    
                    html += '</div>' +
                            '</div>' +
                        '</div>';
                        
                    // Thêm bảng chi tiết sản phẩm
                    html += 
                        '<!-- Chi tiết nhập kho -->' +
                        '<div class="card mx-3 mb-3 rounded shadow-sm">' +
                            '<div class="card-header bg-light d-flex align-items-center">' +
                                '<i class="fas fa-list-ul me-2 text-primary"></i>' +
                                '<h5 class="mb-0 fw-bold">' + response.lang.warehouse_detail_info + '</h5>' +
                            '</div>' +
                            '<div class="card-body p-0">' +
                                '<div class="table-responsive">' +
                                    '<table class="table table-striped table-hover mb-0">' +
                                        '<thead class="table-light">' +
                                            '<tr>' +
                                                '<th width="50" class="text-center">' + response.lang.setting_stt + '</th>' +
                                                '<th>' + response.lang.name + '</th>' +
                                                '<th>' + response.lang.supplier + '</th>' +
                                                (hasGroups ? '<th>' + response.lang.warehouse_group + '</th>' : '') +
                                                '<th class="text-end" width="100">' + response.lang.warehouse_quantity + '</th>' +
                                                '<th class="text-end" width="150">' + response.lang.warehouse_price + '</th>' +
                                            '</tr>' +
                                        '</thead>' +
                                        '<tbody>';
                                        
                    // Kiểm tra và render từng sản phẩm
                    if (response.data.logs && response.data.logs.length > 0) {
                        response.data.logs.forEach(function(log, index) {
                            html += '<tr>' +
                                '<td class="text-center">' + (index + 1) + '</td>' +
                                '<td>' +
                                    '<span class="fw-medium d-flex align-items-center">' +
                                        '<i class="fas fa-box me-2 text-secondary"></i>' +
                                        log.title +
                                    '</span>' +
                                '</td>' +
                                '<td>' +
                                    (log.supplier_name ? 
                                    '<span class="badge bg-secondary rounded-pill">' + log.supplier_name + '</span>' : 
                                    '<span class="text-muted">--</span>') +
                                '</td>';
                            
                            if (hasGroups) {
                                html += '<td>';
                                
                                if (log.group_info && log.group_info.length > 0) {
                                    html += '<div class="d-flex flex-wrap gap-2">';
                                    
                                    log.group_info.forEach(function(groupInfo) {
                                        html += '<div class="badge bg-light text-dark p-2 d-inline-flex align-items-center border">';
                                        
                                        if (groupInfo.groups && groupInfo.groups.length > 0) {
                                            groupInfo.groups.forEach(function(group) {
                                                html += '<span class="badge bg-success me-1" title="' + (group.parent_title || '') + '">' + group.title + '</span>';
                                            });
                                        }
                                        
                                        if (groupInfo.quantity) {
                                            html += '<span class="badge bg-info ms-1" title="' + (response.lang.warehouse_quantity || 'Số lượng') + '">' + groupInfo.quantity + '</span>';
                                        }
                                        
                                        if (groupInfo.price_format) {
                                            html += '<span class="badge bg-warning ms-1" title="' + (response.lang.warehouse_price || 'Giá nhập') + '">' + groupInfo.price_format + ' ' + log.money_unit + '</span>';
                                        }
                                        
                                        html += '</div>';
                                    });
                                    
                                    html += '</div>';
                                } else {
                                    html += '<span class="text-muted">--</span>';
                                }
                                
                                html += '</td>';
                            }
                            
                            html += '<td class="text-end fw-bold">' + log.total_quantity + '</td>' +
                                '<td class="text-end">' + (log.price ? formatNumber(log.price) + ' ' + log.money_unit : '--') + '</td>' +
                            '</tr>';
                        });
                    } else {
                        html += '<tr><td colspan="7" class="text-center">Không có dữ liệu</td></tr>';
                    }
                    
                    html += '</tbody>' +
                                    '</table>' +
                                '</div>' +
                            '</div>' +
                        '</div>' +
                    '</div>';
                    
                    // Cập nhật nội dung modal
                    $('#warehouse-detail-content').html(html);
                    
                    // Khởi tạo tooltips cho nội dung mới
                    initTooltipsInModal();
                } catch (e) {
                    console.error("Error rendering template: ", e);
                    $('#warehouse-detail-content').html(
                        '<div class="alert alert-danger m-3">' +
                        '<i class="fas fa-exclamation-triangle me-2"></i>' +
                        'Lỗi khi hiển thị dữ liệu: ' + e.message +
                        '</div>'
                    );
                }
            } else {
                // Hiển thị lỗi
                $('#warehouse-detail-content').html(
                    '<div class="alert alert-danger m-3">' +
                    '<i class="fas fa-exclamation-triangle me-2"></i>' +
                    (response && response.message ? response.message : 'Đã có lỗi xảy ra khi tải thông tin nhập kho') +
                    '</div>'
                );
            }
        },
        error: function(xhr, status, error) {
            console.error("AJAX error: ", status, error);
            // Hiển thị lỗi
            $('#warehouse-detail-content').html(
                '<div class="alert alert-danger m-3">' +
                '<i class="fas fa-exclamation-triangle me-2"></i>' +
                'Không thể kết nối tới máy chủ. Vui lòng thử lại sau.' +
                '<div class="small mt-2">Chi tiết lỗi: ' + status + ' - ' + error + '</div>' +
                '</div>'
            );
        }
    });
}

// Hàm định dạng số
function formatNumber(number) {
    return new Intl.NumberFormat().format(number);
}

// Khởi tạo tooltips cho nội dung trong modal
function initTooltipsInModal() {
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('#warehouse-detail-content [title]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl, {
            trigger: 'hover',
            placement: 'top'
        });
    });
}

// Hàm xóa warehouse
function nv_del_warehouse(wid, checkss) {
    if (confirm(nv_is_del_confirm[0])) {
        $.post(script_name + '?' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=warehouse_logs&nocache=' + new Date().getTime(), 'delete=1&wid=' + wid + '&checkss=' + checkss, function(res) {
            if (res == 'OK') {
                location.reload();
            } else {
                alert(nv_is_del_confirm[2]);
            }
        });
    }
    return false;
}
</script> 