{include file="shipping_menu.tpl"}
<link rel="stylesheet" href="{$smarty.const.NV_BASE_SITEURL}{$smarty.const.NV_ASSETS_DIR}/js/select2/select2.min.css">
<script type="text/javascript"
	src="{$smarty.const.NV_BASE_SITEURL}{$smarty.const.NV_ASSETS_DIR}/js/select2/select2.min.js"></script>
<div class="card mb-4">
	<div class="card-body">
		<div class="table-responsive">
			<table class="table table-striped table-bordered table-hover">
				<thead>
					<tr>
						<th class="w100">{$LANG->getModule('weight')}</th>
						<th>{$LANG->getModule('title')}</th>
						<th class="w150">{$LANG->getModule('action')}</th>
					</tr>
				</thead>
				<tbody>
					{foreach from=$DATA item=VIEW}
					<tr>
						<td>
							<select class="form-select" id="id_weight_{$VIEW.id}"
								onchange="nv_chang_weight('{$VIEW.id}')">
								{foreach from=$VIEW.weight_options item=WEIGHT}
								    <option value="{$WEIGHT.key}" {$WEIGHT.selected}>{$WEIGHT.title}</option>
								{/foreach}
							</select>
						</td>
						<td>
							<strong>{$VIEW.title}</strong>
							{if !empty($VIEW.description)}
							    <div class="help-block text-muted">{$VIEW.description}</div>
							{/if}
						</td>
						<td class="text-center">
							<div class="btn-group">
								<a class="btn btn-primary btn-sm" href="{$VIEW.link_edit}">
									<i class="fa fa-edit"></i> {$LANG->getModule('edit')}
								</a>
								<button class="btn btn-danger btn-sm"
									onclick="nv_del_carrier_config_item('{$VIEW.id}', '{$VIEW.delete_checkss}')">
									<i class="fa fa-trash"></i> {$LANG->getModule('delete')}
								</button>
							</div>
						</td>
					</tr>
					{/foreach}
				</tbody>
				{if !empty($GENERATE_PAGE)}
				<tfoot>
					<tr>
						<td colspan="3" class="text-center">{$GENERATE_PAGE}</td>
					</tr>
				</tfoot>
				{/if}
			</table>
		</div>
	</div>
</div>

<!-- Form thêm/sửa -->
<div class="card">
	<div class="card-header">
		<h3 class="card-title">{$CAPTION}</h3>
	</div>
	<div class="card-body">
		{if !empty($ERROR)}
		<div class="alert alert-warning">{$ERROR}</div>
		{/if}

		<form
			action="{$smarty.const.NV_BASE_ADMINURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&{$smarty.const.NV_NAME_VARIABLE}={$MODULE_NAME}&{$NV_OP_VARIABLE}={$OP}"
			method="post">
			<input type="hidden" name="id" value="{$ROW.id}" />
			<div class="row">
				<div class="col-md-18">
					<div class="form-group mb-3">
						<label class="form-label required">{$LANG->getModule('title')}</label>
						<input class="form-control" type="text" name="title" value="{$ROW.title}" required="required" oninvalid="setCustomValidity(nv_required)" oninput="setCustomValidity('')" />
					</div>

					<div class="form-group mb-3">
						<label class="form-label">{$LANG->getModule('carrier_config_items_cg')}</label>
						<select class="form-select" name="cid">
							{foreach from=$CONFIGS item=CONFIG}
							    <option value="{$CONFIG.id}" {$CONFIG.selected}>{$CONFIG.title}</option>
							{/foreach}
						</select>
					</div>

					<div class="form-group mb-3">
						<label class="form-label">{$LANG->getModule('carrier_config_description')}</label>
						<textarea class="form-control" name="description" rows="3">{$ROW.description}</textarea>
					</div>

					<div class="form-group mb-3">
						<label class="form-label">{$LANG->getModule('location')}</label>
						<select id="location" name="config_location[]" class="form-select" multiple>
							{foreach from=$LOCATIONS item=LOCATION}
							<option value="{$LOCATION.id}" {$LOCATION.selected}>{$LOCATION.title}</option>
							{/foreach}
						</select>
					</div>

					<div class="form-group mb-3">
						<label class="form-label">{$LANG->getModule('carrier_config_weight')}</label>
						<div class="table-responsive">
							<table class="table table-bordered" id="table_weight">
								<thead>
									<tr>
										<th>{$LANG->getModule('carrier_config_value')}</th>
										<th>{$LANG->getModule('carrier_price')}</th>
										<th class="w100">&nbsp;</th>
									</tr>
								</thead>
								<tbody>
									{assign var="i" value=0}
									{foreach from=$ROW.config_weight item=CONFIG}
									<tr id="weight_{$i}">
										<td>
											<div class="row">
												<div class="col-8">
													<input class="form-control" type="number"
														name="config_weight[{$i}][weight]" value="{$CONFIG.weight}" />
												</div>
												<div class="col-4">
													<select name="config_weight[{$i}][weight_unit]" class="form-select">
														{foreach from=$WEIGHT_CONFIG key=unit item=info}
														<option value="{$unit}" {if $CONFIG.weight_unit eq
															$unit}selected{/if}>
															{$info.title}
														</option>
														{/foreach}
													</select>
												</div>
											</div>
										</td>
										<td>
											<div class="row">
												<div class="col-8">
													<input class="form-control" type="text"
														name="config_weight[{$i}][carrier_price]"
														value="{$CONFIG.carrier_price}"
														onkeyup="this.value=FormatNumber(this.value);" />
												</div>
												<div class="col-4">
													<select class="form-select"
														name="config_weight[{$i}][carrier_price_unit]">
														{foreach from=$MONEY_CONFIG key=code item=info}
														<option value="{$code}" {if $CONFIG.carrier_price_unit eq
															$code}selected{/if}>
															{$info.currency}
														</option>
														{/foreach}
													</select>
												</div>
											</div>
										</td>
										<td class="text-center">
											<button type="button" class="btn btn-danger btn-sm"
												onclick="$('#weight_{$i}').remove();">
												<i class="fa fa-trash"></i>
											</button>
										</td>
									</tr>
									{assign var="i" value=$i+1}
									{/foreach}
								</tbody>
								<tfoot>
									<tr>
										<td colspan="3" class="text-end">
											<button type="button" class="btn btn-info btn-sm"
												onclick="nv_add_weight_items()">
												<i class="fa fa-plus"></i> {$LANG->getModule('carrier_config_add')}
											</button>
										</td>
									</tr>
								</tfoot>
							</table>
						</div>
					</div>
				</div>
			</div>
			<div class="text-center">
				<button class="btn btn-primary" type="submit" name="submit">
					<i class="fa fa-save"></i> {$LANG->getModule('save')}
				</button>
			</div>
		</form>
	</div>
</div>

<!-- Script khởi tạo select2 -->
<script type="text/javascript">
	$(document).ready(function () {
		$("#location").select2({
			width: '100%',
			placeholder: '{$LANG->getModule('location_select')}',
			allowClear: true
		});
	});
</script>

<!-- Script xử lý các chức năng -->
<script type="text/javascript">
	//<![CDATA[
	// Khai báo biến toàn cục
	var num_weight = '{$ROW.config_weight|@count}';
	var weight_config = '{$WEIGHT_CONFIG}';
	var money_config = '{$MONEY_CONFIG}';

	function nv_chang_weight(id) {
		var new_vid = $('#id_weight_' + id).val();
		$.ajax({
			type: 'POST',
			url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=carrier_config_items&nocache=' + new Date().getTime(),
			data: {
				ajax_action: 1,
				id: id,
				cid: '{$ROW.cid}',
				new_vid: new_vid
			},
			dataType: 'json',
			success: function (res) {
				if (res.status == 'OK') {
					location.reload();
				} else {
					alert(res.message);
				}
			}
		});
	}

	function nv_del_carrier_config_item(id, delete_checkss) {
		if (confirm(nv_is_del_confirm[0])) {
			$.ajax({
				type: 'POST',
				url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=carrier_config_items&nocache=' + new Date().getTime(),
				data: {
					delete: 1,
					delete_id: id,
					delete_checkss: delete_checkss
				},
				success: function (res) {
					if (res['status'] == 'OK') {
						location.reload();
					} else {
						alert(res['message']);
					}
				}
			});
		}
	}

	function nv_add_weight_items() {
		var html = '';
		html += '<tr id="weight_' + num_weight + '">';
		html += '   <td>';
		html += '       <div class="row">';
		html += '           <div class="col-8">';
		html += '               <input class="form-control" type="number" name="config_weight[' + num_weight + '][weight]" value="" />';
		html += '           </div>';
		html += '           <div class="col-4">';
		html += '               <select name="config_weight[' + num_weight + '][weight_unit]" class="form-select">';
		{foreach from = $WEIGHT_CONFIG key = unit item = info }
		html += '               <option value="{$unit}" selected={$unit == 'kg'}>{$info.title}</option>';
		{/foreach }
		html += '               </select>';
		html += '           </div>';
		html += '       </div>';
		html += '   </td>';
		html += '   <td>';
		html += '       <div class="row">';
		html += '           <div class="col-8">';
		html += '               <input class="form-control" type="text" name="config_weight[' + num_weight + '][carrier_price]" value="" onkeyup="this.value=FormatNumber(this.value);" />';
		html += '           </div>';
		html += '           <div class="col-4">';
		html += '               <select class="form-select" name="config_weight[' + num_weight + '][carrier_price_unit]">';
		{foreach from = $MONEY_CONFIG key = code item = info }
		html += '               <option value="{$code}" selected={$code == 'VND'}>{$info.currency}</option>';
		{/foreach }
		html += '               </select>';
		html += '           </div>';
		html += '       </div>';
		html += '   </td>';
		html += '   <td class="text-center">';
		html += '       <button type="button" class="btn btn-danger btn-sm" onclick="$(\'#weight_' + num_weight + '\').remove();">';
		html += '           <i class="fa fa-trash"></i>';
		html += '       </button>';
		html += '   </td>';
		html += '</tr>';

		$('#table_weight tbody').append(html);
		num_weight++;
	}
	//]]>
</script>