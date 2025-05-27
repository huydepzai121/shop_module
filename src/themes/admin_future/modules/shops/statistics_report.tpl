{*
Template cho trang báo cáo thống kê
*}

<div class="card">
    <div class="card-header">
        <h3 class="card-title">{$LANG->get('statistics_title')}</h3>
    </div>
    <div class="card-body">
        <div class="row mb-4">
            <div class="col-md-12">
                <div class="card bg-light">
                    <div class="card-body">
                        <form action="{$NV_BASE_ADMINURL}index.php" method="get" class="form-horizontal">
                            <input type="hidden" name="{$NV_LANG_VARIABLE}" value="{$NV_LANG_DATA}" />
                            <input type="hidden" name="{$NV_NAME_VARIABLE}" value="{$MODULE_NAME}" />
                            <input type="hidden" name="{$NV_OP_VARIABLE}" value="{$OP}" />
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label">{$LANG->get('from_date')}:</label>
                                        <div class="input-group">
                                            <input type="text" class="form-control datepicker" name="from" value="{$SEARCH.from}" autocomplete="off" placeholder="dd/mm/yyyy">
                                            <span class="input-group-text"><i class="fa fa-calendar"></i></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label">{$LANG->get('to_date')}:</label>
                                        <div class="input-group">
                                            <input type="text" class="form-control datepicker" name="to" value="{$SEARCH.to}" autocomplete="off" placeholder="dd/mm/yyyy">
                                            <span class="input-group-text"><i class="fa fa-calendar"></i></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label">{$LANG->get('product_type')}:</label>
                                        <select name="product_type" class="form-select">
                                            <option value="0">{$LANG->get('all_products')}</option>
                                            {foreach $PRODUCT_TYPES as $type}
                                            <option value="{$type.id}" {if $SEARCH.product_type == $type.id}selected="selected"{/if}>{$type.title}</option>
                                            {/foreach}
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label">{$LANG->get('supplier')}:</label>
                                        <select name="supplier_id" class="form-select">
                                            <option value="0">{$LANG->get('all_suppliers')}</option>
                                            {foreach $SUPPLIERS as $supplier}
                                            <option value="{$supplier.id}" {if $SEARCH.supplier_id == $supplier.id}selected="selected"{/if}>{$supplier.title}</option>
                                            {/foreach}
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="text-center">
                                <button type="submit" class="btn btn-primary"><i class="fa fa-search"></i> {$LANG->get('search')}</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        
        {if !empty($STATS)}
        <div class="row mb-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="card-title mb-0">{$LANG->get('summary_statistics')}</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3">
                                <div class="card bg-success text-white">
                                    <div class="card-body text-center">
                                        <h3>{$STATS.total_products}</h3>
                                        <p class="mb-0">{$LANG->get('total_products')}</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card bg-info text-white">
                                    <div class="card-body text-center">
                                        <h3>{$STATS.total_suppliers}</h3>
                                        <p class="mb-0">{$LANG->get('total_suppliers')}</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card bg-warning text-white">
                                    <div class="card-body text-center">
                                        <h3>{$STATS.total_stock}</h3>
                                        <p class="mb-0">{$LANG->get('total_in_stock')}</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card bg-danger text-white">
                                    <div class="card-body text-center">
                                        <h3>{$STATS.total_value}</h3>
                                        <p class="mb-0">{$LANG->get('total_value')}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row mb-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">{$LANG->get('price_history_chart')}</h5>
                    </div>
                    <div class="card-body">
                        <div id="price-chart" style="height: 300px;"></div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <div class="d-flex justify-content-between">
                            <h5 class="card-title mb-0">{$LANG->get('detailed_report')}</h5>
                            <div>
                                <button class="btn btn-success btn-sm" id="export-excel">
                                    <i class="fa fa-file-excel-o"></i> {$LANG->get('export_excel')}
                                </button>
                                <button class="btn btn-danger btn-sm" id="export-pdf">
                                    <i class="fa fa-file-pdf-o"></i> {$LANG->get('export_pdf')}
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-bordered table-hover">
                                <thead>
                                    <tr class="bg-light">
                                        <th class="text-center">{$LANG->get('no')}</th>
                                        <th>{$LANG->get('product_name')}</th>
                                        <th>{$LANG->get('supplier')}</th>
                                        <th class="text-center">{$LANG->get('price')}</th>
                                        <th class="text-center">{$LANG->get('quantity')}</th>
                                        <th class="text-center">{$LANG->get('total_value')}</th>
                                        <th class="text-center">{$LANG->get('last_update')}</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {foreach $REPORT_DATA as $key => $item}
                                    <tr>
                                        <td class="text-center">{$key+1}</td>
                                        <td>{$item.product_name}</td>
                                        <td>{$item.supplier_name}</td>
                                        <td class="text-end">{$item.price} {$item.money_unit}</td>
                                        <td class="text-center">{$item.quantity}</td>
                                        <td class="text-end">{$item.total_value} {$item.money_unit}</td>
                                        <td class="text-center">{$item.update_time}</td>
                                    </tr>
                                    {/foreach}
                                </tbody>
                                <tfoot>
                                    <tr class="bg-light">
                                        <th colspan="3" class="text-end">{$LANG->get('total')}:</th>
                                        <th class="text-end">{$TOTAL.avg_price} {$DEFAULT_CURRENCY}</th>
                                        <th class="text-center">{$TOTAL.quantity}</th>
                                        <th class="text-end">{$TOTAL.value} {$DEFAULT_CURRENCY}</th>
                                        <th></th>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                        
                        {if !empty($GENERATE_PAGE)}
                        <div class="mt-3">
                            {$GENERATE_PAGE}
                        </div>
                        {/if}
                    </div>
                </div>
            </div>
        </div>
        {else}
        <div class="alert alert-info">
            <i class="fa fa-info-circle"></i> {$LANG->get('no_data_found')}
        </div>
        {/if}
    </div>
</div>

<script type="text/javascript">
$(document).ready(function() {
    $('.datepicker').datepicker({
        dateFormat: 'dd/mm/yy',
        changeMonth: true,
        changeYear: true,
        showOtherMonths: true
    });
    
    $('#export-excel').on('click', function() {
        window.location.href = '{$NV_BASE_ADMINURL}index.php?{$NV_LANG_VARIABLE}={$NV_LANG_DATA}&{$NV_NAME_VARIABLE}={$MODULE_NAME}&{$NV_OP_VARIABLE}={$OP}&export=excel&' + $.param({
            from: '{$SEARCH.from}',
            to: '{$SEARCH.to}',
            product_type: '{$SEARCH.product_type}',
            supplier_id: '{$SEARCH.supplier_id}'
        });
    });
    
    $('#export-pdf').on('click', function() {
        window.location.href = '{$NV_BASE_ADMINURL}index.php?{$NV_LANG_VARIABLE}={$NV_LANG_DATA}&{$NV_NAME_VARIABLE}={$MODULE_NAME}&{$NV_OP_VARIABLE}={$OP}&export=pdf&' + $.param({
            from: '{$SEARCH.from}',
            to: '{$SEARCH.to}',
            product_type: '{$SEARCH.product_type}',
            supplier_id: '{$SEARCH.supplier_id}'
        });
    });
    
    {if !empty($CHART_DATA)}
    // Vẽ biểu đồ giá
    var options = {
        series: [{
            name: '{$LANG->get('price')}',
            data: [{$CHART_DATA.prices}]
        }],
        chart: {
            height: 300,
            type: 'line',
            zoom: {
                enabled: true
            }
        },
        dataLabels: {
            enabled: false
        },
        stroke: {
            curve: 'straight'
        },
        grid: {
            row: {
                colors: ['#f3f3f3', 'transparent'],
                opacity: 0.5
            },
        },
        xaxis: {
            categories: [{$CHART_DATA.dates}],
        },
        tooltip: {
            y: {
                formatter: function(val) {
                    return val + ' {$DEFAULT_CURRENCY}'
                }
            }
        }
    };

    var chart = new ApexCharts(document.querySelector("#price-chart"), options);
    chart.render();
    {/if}
});
</script> 