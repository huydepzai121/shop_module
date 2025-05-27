{* Main template *}
<div class="table-responsive">
	<table class="table table-striped table-bordered table-hover">
		<caption>
			{$LANG->getModule('coupons_info')}
		</caption>
		<tbody>
			<tr>
				<td><strong>{$LANG->getModule('title')}</strong></td>
				<td>{$DATA.title}</td>
				<td><strong>{$LANG->getModule('coupons_product')}</strong></td>
				<td>{if !empty($DATA.product)}<a href="javascript:void(0)" data-toggle="tooltip"
						title="{$LANG.coupons_product_custom_edit}">{$LANG.coupons_product_custom}</a>{/if}</td>
			</tr>
			<tr>
				<td><strong>{$LANG->getModule('coupons')}</strong></td>
				<td>{$DATA.code}</td>
				<td><strong>{$LANG->getModule('begin_time')}</strong></td>
				<td>{$DATA.date_start}</td>
			</tr>
			<tr>
				<td><strong>{$LANG->getModule('coupons_discount')}</strong></td>
				<td>{$DATA.discount}{$DATA.discount_text}</td>
				<td><strong>{$LANG->getModule('end_time')}</strong></td>
				<td>{$DATA.date_end}</td>
			</tr>
			<tr>
				<td><strong>{$LANG->getModule('coupons_total_amount')}</strong></td>
				<td>{$DATA.total_amount} {$MONEY_UNIT}</td>
				<td><strong>{$LANG->getModule('coupons_uses_per_coupon')}</strong></td>
				<td>{$DATA.uses_per_coupon_count}/{$DATA.uses_per_coupon}</td>
			</tr>
		</tbody>
	</table>
</div>

<div id="coupons_history">
	<p class="text-center">
		<em class="fa fa-spinner fa-spin fa-3x">&nbsp;</em>
	</p>
</div>

<script type="text/javascript">
	$(document).ready(function () {
		$('#coupons_history').load(script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=coupons_view&coupons_history=1&id={$CID}');
	});

	$(function () {
		$('[data-toggle="tooltip"]').tooltip();
	});
</script>

{* History template *}
{if isset($HISTORY)}
<div class="table-responsive">
	<table class="table table-striped table-bordered table-hover">
		<caption>{$LANG->getModule('coupons_history')}</caption>
		<thead>
			<tr>
				<th>{$LANG->getModule('order_code')}</th>
				<th>{$LANG->getModule('coupons_discount')} ({$MONEY_UNIT})</th>
				<th>{$LANG->getModule('order_time')}</th>
			</tr>
		</thead>
		<tbody>
			{foreach from=$HISTORY item=history}
			<tr>
				<td><a href="{$history.order_view}">{$history.order_code}</a></td>
				<td>{$history.amount}</td>
				<td>{$history.date_added}</td>
			</tr>
			{/foreach}
		</tbody>
		{if !empty($GENERATE_PAGE)}
		<tfoot>
			<tr class="text-center">
				<td colspan="3">{$GENERATE_PAGE}</td>
			</tr>
		</tfoot>
		{/if}
	</table>
</div>
{/if}