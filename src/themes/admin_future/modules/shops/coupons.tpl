<link type="text/css" href="{$smarty.const.NV_STATIC_URL}{$smarty.const.NV_ASSETS_DIR}/js/jquery-ui/jquery-ui.min.css"
    rel="stylesheet" />
<script type="text/javascript"
    src="{$smarty.const.NV_STATIC_URL}{$smarty.const.NV_ASSETS_DIR}/js/jquery-ui/jquery-ui.min.js"></script>
<script type="text/javascript"
    src="{$smarty.const.NV_STATIC_URL}{$smarty.const.NV_ASSETS_DIR}/js/language/jquery.ui.datepicker-{$smarty.const.NV_LANG_INTERFACE}.js"></script>

{if $main}
<div class="row">
    <!-- Phần tìm kiếm -->
    <div class="col-24 mb-3">
        <form action="{$smarty.const.NV_BASE_ADMINURL}index.php" method="get" class="d-flex gap-2">
            <input type="hidden" name="{$smarty.const.NV_LANG_VARIABLE}" value="{$smarty.const.NV_LANG_DATA}" />
            <input type="hidden" name="{$smarty.const.NV_NAME_VARIABLE}" value="{$MODULE_NAME}" />
            <input type="hidden" name="{$smarty.const.NV_OP_VARIABLE}" value="{$OP}" />
            <div class="input-group w-50">
                <input class="form-control w-50" type="text" value="{$Q}" name="q" maxlength="255"
                    placeholder="{$LANG->getModule('search_key')}" />
                <button class="btn btn-primary" type="submit">
                    <i class="fa fa-search"></i> {$LANG->getModule('search')}
                </button>
            </div>
        </form>
    </div>

    <!-- Phần danh sách -->
    <div class="col-24">
        <div class="table-responsive">
            <table class="table table-striped table-bordered table-hover">
                <thead>
                    <tr>
                        <th>{$LANG->getModule('title')}</th>
                        <th>{$LANG->getModule('coupons')}</th>
                        <th class="w200">{$LANG->getModule('coupons_discount')}</th>
                        <th class="w150">{$LANG->getModule('begin_time')}</th>
                        <th class="w150">{$LANG->getModule('end_time')}</th>
                        <th class="w150">{$LANG->getModule('status')}</th>
                        <th class="w150 text-center">{$LANG->getModule('action')}</th>
                    </tr>
                </thead>
                {if !empty($VIEW_DATA)}
                <tbody>
                    {foreach from=$VIEW_DATA item=VIEW}
                    <tr>
                        <td><a href="{$VIEW.link_view}" title="{$VIEW.title}">{$VIEW.title}</a></td>
                        <td>{$VIEW.code}</td>
                        <td>{$VIEW.discount}{$VIEW.discount_text}</td>
                        <td>{$VIEW.date_start}</td>
                        <td>{$VIEW.date_end}</td>
                        <td>{$VIEW.status}</td>
                        <td class="text-center">
                            <div class="btn-group">
                                <a class="btn btn-sm btn-primary" href="{$VIEW.link_edit}"
                                    title="{$LANG->getGlobal('edit')}">
                                    <i class="fa fa-edit"></i>
                                </a>
                                <button class="btn btn-sm btn-danger" onclick="nv_del_coupons({$VIEW.id})"
                                    title="{$LANG->getGlobal('delete')}">
                                    <i class="fa fa-trash"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                    {/foreach}
                </tbody>
                {/if}
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

    <!-- Form thêm/sửa -->
    <div class="col-24 mt-4">
        <div class="card">
            <div class="card-header">
                <h5 class="card-title mb-0">{$LANG->getModule('coupons_add')}</h5>
            </div>
            <div class="card-body">
                {if !empty($ERROR)}
                <div class="alert alert-danger">{$ERROR}</div>
                {/if}

                <form action="" method="post">
                    <input type="hidden" name="id" value="{$ROW.id}" />

                    <div class="table-responsive">
                        <table class="table table-striped table-bordered table-hover">
                            <tbody>
                                <tr>
                                    <td style="width: 200px"> {$LANG->getModule('title')} <span
                                            class="text-danger">*</span></td>
                                    <td><input class="form-control w-50" type="text" name="title" value="{$ROW.title}"
                                            required="required"></td>
                                </tr>
                                <tr>
                                    <td> {$LANG->getModule('coupons')} <span class="text-danger">*</span></td>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <input class="form-control w-50" type="text" name="code" value="{$ROW.code}"
                                                required="required" id="coupon_code" disabled>
                                            <button type="button" class="btn btn-info" onclick="generateCouponCode()">
                                                <i class="fa fa-refresh"></i> Tạo mã
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td> {$LANG->getModule('coupons_discount')} <span class="text-danger">*</span></td>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <input class="form-control w-50" type="number" name="discount"
                                                value="{$ROW.discount}" required="required" step="0.01">
                                            <select class="form-select w-50" name="type">
                                                {foreach from=$TYPE_OPTIONS item=TYPE}
                                                <option value="{$TYPE.key}" {$TYPE.selected}>{$TYPE.title}</option>
                                                {/foreach}
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td> {$LANG->getModule('coupons_total_amount')}</td>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <input class="form-control w-50" type="text" name="total_amount"
                                                value="{$ROW.total_amount}">
                                            <em class="fa fa-info-circle fa-lg text-info" data-toggle="tooltip"
                                                title="{$LANG->getModule('coupons_total_amount_note')}">&nbsp;</em>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td> {$LANG->getModule('coupons_product')}</td>
                                    <td>
                                        <div class="message_body" style="overflow: auto">
                                            <div class="clearfix uiTokenizer uiInlineTokenizer">
                                                <div id="product" class="tokenarea">
                                                    {if !empty($PRODUCTS)}
                                                    {foreach from=$PRODUCTS item=PRODUCT}
                                                    <span class="uiToken removable" title="{$PRODUCT.title}">
                                                        {$PRODUCT.title}
                                                        <input type="hidden" name="product[]" value="{$PRODUCT.id}" />
                                                        <a onclick="$(this).parent().remove();"
                                                            class="remove uiCloseButton uiCloseButtonSmall"
                                                            href="javascript:void(0);"></a>
                                                    </span>
                                                    {/foreach}
                                                    {/if}
                                                </div>
                                                <div class="uiTypeahead">
                                                    <div class="wrap">
                                                        <input type="hidden" class="hiddenInput" autocomplete="off"
                                                            value="" />
                                                        <div class="innerWrap">
                                                            <input id="get_product" type="text"
                                                                placeholder="{$LANG->getModule('input_keyword_tags')}"
                                                                class="form-control textInput" style="width: 400px;" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="help-block">{$LANG->getModule('coupons_product_note')}</div>
                                    </td>
                                </tr>
                                <tr>
                                    <td> {$LANG->getModule('begin_time')}</td>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <input class="form-control w-25" type="text" name="date_start"
                                                value="{$ROW.date_start}" id="date_start">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td> {$LANG->getModule('end_time')}</td>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <input class="form-control w-25" type="text" name="date_end"
                                                value="{$ROW.date_end}" id="date_end">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td> {$LANG->getModule('coupons_uses_per_coupon')}</td>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <input class="form-control w-auto" type="text" name="uses_per_coupon"
                                                value="{$ROW.uses_per_coupon}">
                                            <em class="fa fa-info-circle fa-lg text-info" data-toggle="tooltip"
                                                title="{$LANG->getModule('coupons_uses_per_coupon_note')}">&nbsp;</em>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="text-center">
                        <button type="submit" name="submit" id="submit" class="btn btn-primary" value="{$LANG->getModule('save')}"><i class="fa fa-floppy-o" aria-hidden="true"></i> {$LANG->getModule('save')}</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        // Datepicker
        $("#date_start,#date_end").datepicker({
            dateFormat: "dd/mm/yy",
            changeMonth: true,
            changeYear: true,
            showOtherMonths: true,
            showOn: 'focus',
            onSelect: function (selectedDate) {
                $("#date_end").datepicker("option", "minDate", selectedDate);
            }
        });

        // Tooltip
        $('[data-toggle="tooltip"]').tooltip();

        // Autocomplete sản phẩm
        $("#get_product").autocomplete({
            source: function (request, response) {
                $.getJSON(script_name + "?" + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + "=" + nv_module_name + "&" + nv_fc_variable + "=coupons&get_product=1", {
                    term: extractLast(request.term)
                }, response);
            },
            search: function () {
                var term = extractLast(this.value);
                if (term.length < 2) {
                    return false;
                }
            },
            select: function (event, ui) {
                var html = '<span title="' + ui.item.value + '" class="uiToken removable">' + ui.item.value +
                    '<input type="hidden" value="' + ui.item.key + '" name="product[]" autocomplete="off">' +
                    '<a onclick="$(this).parent().remove();" href="javascript:void(0);" class="remove uiCloseButton uiCloseButtonSmall"></a></span>';
                $("#product").append(html);
                $(this).val('');
                return false;
            }
        });
    });

    function split(val) {
        return val.split(/,\s*/);
    }

    function extractLast(term) {
        return split(term).pop();
    }

    function nv_del_coupons(id) {
        if (confirm(nv_is_del_confirm[0])) {
            $.post(script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=coupons&nocache=' + new Date().getTime(), 'delete_id=' + id, function (res) {
                if (res == 'OK') {
                    location.reload();
                } else {
                    alert(nv_is_del_confirm[2]);
                }
            });
        }
    }

    function generateCouponCode() {
        // Tạo mã ngẫu nhiên gồm 8 ký tự chữ hoa và số
        const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        let code = '';
        for (let i = 0; i < 8; i++) {
            code += chars.charAt(Math.floor(Math.random() * chars.length));
        }

        // Gán mã vào input
        $('#coupon_code').val(code);
    }
</script>
{/if}