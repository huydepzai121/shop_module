<div class="card">
    <div class="card-body">
        <div class="row">
            <div class="col-xs-24 col-sm-19">
                <table class="table table-striped">
                    <tr>
                        <td width="130px">{$LANG->getModule('order_name')}:</td>
                        <td><strong>{$DATA.order_name}</strong></td>
                    </tr>
                    <tr>
                        <td>{$LANG->getModule('order_email')}:</td>
                        <td>{$DATA.order_email}</td>
                    </tr>
                    <tr>
                        <td>{$LANG->getModule('order_phone')}:</td>
                        <td>{$DATA.order_phone}</td>
                    </tr>
                    {if !$DATA_SHIPPING}
                    <tr>
                        <td>{$LANG->getModule('order_address')}:</td>
                        <td>{$DATA.order_address}</td>
                    </tr>
                    {/if}
                    <tr>
                        <td>{$LANG->getModule('order_date')}:</td>
                        <td>{$dateup} {$LANG->getModule('order_moment')} {$moment}</td>
                    </tr>
                </table>
            </div>
            <div class="col-xs-24 col-sm-5">
                <div class="order_code text-center">
                    <div class="mb-2">{$LANG->getModule('order_code')}</div>
                    <div class="fs-4 fw-bold mb-2">{$DATA.order_code}</div>
                    <div
                        class="badge {if $ORDER_STATUS.is_paid}bg-success{elseif $ORDER_STATUS.is_processing}bg-warning{else}bg-secondary{/if}">
                        {$payment}</div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="card mt-4">
    <div class="card-header">
        <h3 class="card-title">{$LANG->getModule('content_list')}</h3>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-striped table-hover align-middle">
                <thead>
                    <tr>
                        <th width="30px">{$LANG->getModule('order_no_products')}</th>
                        <th>{$LANG->getModule('order_products_name')}</th>
                        <th>{$LANG->getModule('content_product_code')}</th>
                        <th class="text-center">{$LANG->getModule('order_product_price')} ({$unit})</th>
                        <th class="text-center" width="60px">{$LANG->getModule('order_product_numbers')}</th>
                        <th>{$LANG->getModule('order_product_unit')}</th>
                        <th class="text-end">{$LANG->getModule('order_product_price_total')} ({$unit})</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$DATA_PRO item=product key=i}
                    <tr>
                        <td class="text-center">{$i + 1}</td>
                        <td>
                            <a href="{$product.link_pro}" target="_blank" class="fw-bold">{$product.title}</a>
                            {if !empty($product.product_group)}
                            <div class="text-muted mt-2">
                                {foreach from=$product.product_group item=group}
                                <div>{$global_array_group[$group.parentid].title}: <strong>{$group.title}</strong></div>
                                {/foreach}
                            </div>
                            {/if}
                        </td>
                        <td><strong>{$product.product_code}</strong></td>
                        <td class="text-center">{$product.product_price}</td>
                        <td class="text-center">{$product.product_number}</td>
                        <td>{$product.product_unit}</td>
                        <td class="text-end"><strong>{$product.product_price_total}</strong></td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>
    </div>
</div>

{if !empty($DATA_SHIPPING)}
<div class="card mt-4">
    <div class="card-header">
        <h3 class="card-title">{$LANG->getModule('shipping_info')}</h3>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-striped table-hover align-middle">
                <thead>
                    <tr>
                        <th>{$LANG->getModule('shipping_name')}</th>
                        <th>{$LANG->getModule('order_address')}</th>
                        <th>{$LANG->getModule('carrier')}</th>
                        <th>{$LANG->getModule('weights')}</th>
                        <th class="text-end">{$LANG->getModule('carrier_price')}</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>{$DATA_SHIPPING.ship_name} - {$DATA_SHIPPING.ship_phone}</td>
                        <td>
                            {$DATA_SHIPPING.ship_location_title}
                            <div class="text-muted">{$DATA_SHIPPING.ship_address_extend}</div>
                        </td>
                        <td>{$DATA_SHIPPING.ship_shops_title}</td>
                        <td>{$DATA_SHIPPING.weight}{$DATA_SHIPPING.weight_unit}</td>
                        <td class="text-end">{$DATA_SHIPPING.ship_price} {$DATA_SHIPPING.ship_price_unit}</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>
{/if}

<div class="card mt-4">
    <div class="card-body">
        <div class="row align-items-center">
            <div class="col">
                {if !empty($DATA.order_note)}
                <div class="text-muted fst-italic">
                    {$LANG->getModule('order_products_note')}: {$DATA.order_note}
                </div>
                {/if}
            </div>
            <div class="col-auto">
                <div class="fs-4 fw-bold">{$LANG->getModule('order_total')}: {$order_total} {$unit}</div>
            </div>
        </div>
    </div>
</div>

{if !empty($TRANSACTION)}
<div class="card mt-4">
    <div class="card-header">
        <h3 class="card-title">{$LANG->getModule('history_transaction')}</h3>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-striped table-hover align-middle">
                <thead>
                    <tr>
                        <th width="30px">&nbsp;</th>
                        <th>{$LANG->getModule('payment_time')}</th>
                        <th>{$LANG->getModule('user_payment')}</th>
                        <th>{$LANG->getModule('payment_id')}</th>
                        <th>{$LANG->getModule('status')}</th>
                        <th class="text-end">{$LANG->getModule('order_total')}</th>
                        <th class="text-end">{$LANG->getModule('transaction_time')}</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$TRANSACTION item=TRANS}
                    <tr>
                        <td class="text-center">{$TRANS.a}</td>
                        <td>{$TRANS.payment_time}</td>
                        <td><a href="{$TRANS.link_user}">{$TRANS.payment}</a></td>
                        <td>{$TRANS.payment_id}</td>
                        <td>{$TRANS.transaction}</td>
                        <td class="text-end">{$TRANS.payment_amount}</td>
                        <td class="text-end">{$TRANS.transaction_time}</td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>
    </div>
</div>
{/if}

<div class="text-center mt-4">
    <form class="d-inline-block" action="" method="post" name="fpost" id="post">
        <input type="hidden" value="{$order_id}" name="order_id">
        <input type="hidden" value="1" name="save">
        {if $ORDER_STATUS.is_processing}
        <button type="submit" class="btn btn-primary" id="click_submit">
            <i class="fa fa-check-circle"></i> {$LANG->getModule('order_submit')}
        </button>
        {/if}
        {if $ORDER_STATUS.is_incomplete}
        <button type="button" class="btn btn-success" id="click_pay">
            <i class="fa fa-money"></i> {$LANG->getModule('order_submit_pay')}
        </button>
        {else}
        <button type="button" class="btn btn-danger" id="click_pay">
            <i class="fa fa-times-circle"></i> {$LANG->getModule('order_submit_unpay')}
        </button>
        {/if}
        <button type="button" class="btn btn-info" id="click_print">
            <i class="fa fa-print"></i> {$LANG->getModule('order_print')}
        </button>
    </form>
</div>

<script>
    $(function () {
        $('#click_submit').on('click', function (e) {
            e.preventDefault();
            if (confirm("{$LANG->getModule('order_submit_comfix')}")) {
                $('#post').submit();
            }
        });

        $('#click_print').on('click', function (e) {
            e.preventDefault();
            nv_open_browse('{$LINK_PRINT}', '', 640, 300, 'resizable=no,scrollbars=yes,toolbar=no,location=no,status=no');
        });

        $('#click_pay').on('click', function (e) {
            e.preventDefault();
            if (confirm("{$LANG->getModule('order_submit_pay_comfix')}")) {
                $.ajax({
                    type: 'POST',
                    url: '{$URL_ACTIVE_PAY}',
                    data: 'save=1',
                    success: function (data) {
                        alert(data);
                        window.location = "{$URL_BACK}";
                    }
                });
            }
        });
    });
</script>