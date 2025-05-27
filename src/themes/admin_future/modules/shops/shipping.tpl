<!-- BEGIN: main -->
{if $main}
{include file="shipping_menu.tpl"}

<div class="card mb-4">
    <div class="card-header">
        <h5 class="card-title mb-0">{$LANG->getModule('search')}</h5>
    </div>
    <div class="card-body">
        <form action="{$NV_BASE_ADMINURL}index.php" method="get">
            <input type="hidden" name="{$NV_LANG_VARIABLE}" value="{$NV_LANG_DATA}" />
            <input type="hidden" name="{$NV_NAME_VARIABLE}" value="{$MODULE_NAME}" />
            <input type="hidden" name="{$NV_OP_VARIABLE}" value="{$OP}" />
            <div class="row">
                <div class="col-sm-8 col-md-6 col-lg-4 mb-3">
                    <input type="text" class="form-control" value="{$SEARCH.keywords}" name="keywords"
                        placeholder="{$LANG->getModule('search_key')}" />
                </div>
                <div class="col-sm-8 col-md-6 col-lg-4 mb-3">
                    <select class="form-select" name="shops_id">
                        <option value="">---{$LANG->getModule('shops_chose')}---</option>
                        {foreach from=$SHOPS item=SHOP}
                        <option value="{$SHOP.id}" {$SHOP.selected}>{$SHOP.name}</option>
                        {/foreach}
                    </select>
                </div>
                <div class="col-sm-8 col-md-6 col-lg-4 mb-3">
                    <select class="form-select" name="carrier_id">
                        <option value="">---{$LANG->getModule('carrier_chose')}---</option>
                        {foreach from=$CARRIERS item=CARRIER}
                        <option value="{$CARRIER.id}" {$CARRIER.selected}>{$CARRIER.name}</option>
                        {/foreach}
                    </select>
                </div>
                <div class="col-sm-8 col-md-6 col-lg-4">
                    <button type="submit" class="btn btn-primary">
                        <i class="fa fa-search"></i> {$LANG->getModule('search')}
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<div class="card">
    <div class="card-header">
        <h5 class="card-title mb-0">{$LANG->getModule('shipping_list')}</h5>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-striped table-bordered table-hover">
                <thead>
                    <tr>
                        <th>{$LANG->getModule('order_code')}</th>
                        <th>{$LANG->getModule('shipping_name')}</th>
                        <th>{$LANG->getModule('order_address')}</th>
                        <th>{$LANG->getModule('shops')}</th>
                        <th>{$LANG->getModule('carrier')}</th>
                        <th>{$LANG->getModule('weights')}</th>
                        <th class="text-end">{$LANG->getModule('carrier_price')}</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$DATA item=VIEW}
                    <tr>
                        <td><a href="{$VIEW.order_view}" title="{$VIEW.order_code}">{$VIEW.order_code}</a></td>
                        <td>{$VIEW.ship_name} - {$VIEW.ship_phone}</td>
                        <td>{$VIEW.ship_location_title} <span class="help-block">{$VIEW.ship_address_extend}</span></td>
                        <td>{$VIEW.ship_shops_title}</td>
                        <td>{$VIEW.ship_carrier_title}</td>
                        <td>{$VIEW.weight}{$VIEW.weight_unit}</td>
                        <td class="text-end">{$VIEW.ship_price} {$VIEW.ship_price_unit}</td>
                    </tr>
                    {/foreach}
                </tbody>
                {if !empty($GENERATE_PAGE)}
                <tfoot>
                    <tr>
                        <td colspan="7" class="text-center">{$GENERATE_PAGE}</td>
                    </tr>
                </tfoot>
                {/if}
            </table>
        </div>
    </div>
</div>
{/if}
<!-- END: main -->