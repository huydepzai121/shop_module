<link rel="stylesheet" href="{$smarty.const.NV_BASE_SITEURL}{$smarty.const.NV_ASSETS_DIR}/js/select2/select2.min.css">
<link rel="stylesheet" type="text/css"
    href="{$smarty.const.NV_BASE_SITEURL}{$smarty.const.NV_ASSETS_DIR}/js/jquery-ui/jquery-ui.min.css">
<script type="text/javascript">var inrow = '{$inrow}';</script>

<form class="form-horizontal" action="" enctype="multipart/form-data" method="post" id="frm-submit">
    <input type="hidden" value="1" name="save"> <input type="hidden" value="{$rowcontent.id}" name="id">
    <div class="row">
        <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 col-xl-9 col-xxl-9">
            <div class="card border-primary border-3 border-bottom-0 border-start-0 border-end-0">
                <div class="card-header py-2" role="button" data-bs-toggle="collapse"
                    data-bs-target="#collapse-general0" aria-expanded="true" aria-controls="collapse-general0">
                    <div class="hstack gap-2 align-items-center justify-content-between">
                        <div class="fw-medium fs-5">{$LANG->getModule('product_info')}</div>
                        <div class="collapse-button"></div>
                    </div>
                </div>

                <div class="collapse show" id="collapse-general0">
                    <div class="card card-body">
                        <div class="row">
                            <label for="element_site_name"
                                class="col-sm-12 col-xxl-12 col-form-label">{$LANG->getModule('name')} <span
                                    class="text-danger">(*)</span></label>
                            <div class="col-sm-12 col-lg-12 col-xxl-12">
                                <input type="text" maxlength="255" value="{$rowcontent.title}" name="title" id="idtitle"
                                    class="form-control" />
                            </div>
                        </div>

                        <div class="row">
                            <label for="element_site_name"
                                class="col-sm-12 col-xxl-12 col-form-label">{$LANG->getModule('alias')} <span
                                    class="text-danger">(*)</span></label>
                            <div class="col-sm-12 col-lg-12 col-xxl-12">
                                <div class="input-group">
                                    <input class="form-control" name="alias" type="text" id="idalias"
                                        value="{$rowcontent.alias}" maxlength="255" />
                                    <button class="btn btn-default" type="button">
                                        <i class="fa fa-refresh fa-lg"
                                            onclick="get_alias('content', {$ALIAS});">&nbsp;</i>
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <label for="element_site_name"
                                class="col-sm-12 col-xxl-12 col-form-label">{$LANG->getModule('content_cat')} <span
                                    class="text-danger">(*)</span></label>
                            <div class="col-sm-12 col-lg-12 col-xxl-12">
                                <select class="form-control" name="catid" id="catid"
                                    onchange="nv_change_catid(this, {$rowcontent.id})" style="width: 100%">
                                    <option value="0" data-label="1">---{$LANG->getModule('content_cat_c')}---</option>
                                    {foreach from=$ROWSCAT key=k item=v}
                                    <option value="{$v.catid}" {$v.selected} data-label="{$v.typeprice}">{$v.title}
                                    </option>
                                    {/foreach}
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-sm-12 col-lg-6 col-xxl-6">
                                <label class="col-form-label">{$LANG->getModule('content_product_code')}</label>
                                <input class="form-control" name="product_code" type="text"
                                    value="{$rowcontent.product_code}" maxlength="255" />
                            </div>

                            <div class="col-sm-12 col-lg-6 col-xxl-6">
                                <label class="col-form-label">{$LANG->getModule('prounit')}</label>
                                <select class="form-control" name="product_unit">
                                    {foreach from=$arr_unitid_i key=k item=v}
                                    <option value="{$v.uid}" {$v.uch}>{$v.utitle}</option>
                                    {/foreach}
                                </select>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-sm-12 col-lg-3 col-xxl-3">
                                <label class="col-form-label">{$LANG->getModule('weights')}</label>
                                <input class="form-control" type="text" maxlength="50"
                                    value="{$rowcontent.product_weight}" name="product_weight"
                                    onkeyup="this.value=FormatNumber(this.value);" id="f_weight" />
                            </div>

                            <div class="col-sm-12 col-lg-3 col-xxl-3">
                                <label class="col-form-label invisible">{$LANG->getModule('weights')}</label>
                                <select class="form-control" name="weight_unit">
                                    {foreach from=$weight_config key=k item=v}
                                    <option value="{$v.code}" {$v.select}>{$v.title}</option>
                                    {/foreach}
                                </select>
                            </div>

                            <div class="col-sm-12 col-lg-6 col-xxl-6">
                                {if (empty($pro_config['active_warehouse']))}
                                {if ($rowcontent['id'] > 0 and !$is_copy)}
                                <label class="col-form-label">{$LANG->getModule('content_product_number_edit')}</label>
                                {else}
                                <label class="col-form-label">{$LANG->getModule('content_product_number')}</label>
                                {/if}


                                {if ($rowcontent['id'] > 0 and !$is_copy)}
                                <div class="input-group">
                                    <button type="button" class="btn btn-secondary"
                                        id="element_site_logo_btn">{$rowcontent.product_number} +</button>
                                    <input class="form-control" type="number" maxlength="50" value="0"
                                        name="product_number" />
                                </div>
                                {else}
                                <input class="form-control" type="number" min="0" maxlength="50"
                                    value="{$rowcontent.product_number}" name="product_number" />
                                {/if}
                                {/if}
                            </div>
                        </div>

                        <div class="row">
                            {if !empty($product_price)}
                            <div class="col-sm-12 col-lg-3 col-xxl-3">
                                <label
                                    class="col-form-label">{$LANG->getModule('content_product_product_price')}</label>
                                <input class="form-control" type="text" maxlength="50"
                                    value="{$rowcontent.product_price}" name="product_price"
                                    onkeyup="this.value=FormatNumber(this.value);" id="f_money" />
                            </div>

                            <div class="col-sm-12 col-lg-3 col-xxl-3">
                                <label class="col-form-label invisible">--</label>
                                <select class="form-control" name="money_unit">
                                    {foreach from=$money_config key=k item=v}
                                    <option value="{$v.code}" {$v.select}>{$v.currency}</option>
                                    {/foreach}
                                </select>
                            </div>
                            {/if}

                            <div class="col-sm-12 col-lg-6 col-xxl-6">
                                <label class="col-form-label">{$LANG->getModule('content_product_discounts')}</label>
                                <select class="form-control" name="discount_id" id="discount_id">
                                    <option value="0">---{$LANG->getModule('content_product_discounts')}---</option>
                                </select>
                            </div>

                            <div class="col-sm-12 col-lg-12 col-xxl-12">
                                {if isset($typeprice2)}
                                <div class="form-group">
                                    <label
                                        class="col-md-4 control-label">{$LANG->getModule('content_product_product_price')}</label>
                                    <div class="col-md-15">
                                        <table id="id_price_config"
                                            class="table table-striped table-bordered table-hover">
                                            <thead>
                                                <tr>
                                                    <th class="text-center">{$LANG->getModule('discount_to')}</th>
                                                    <th class="text-center">
                                                        {$LANG->getModule('content_product_product_price')}</th>
                                                </tr>
                                            </thead>
                                            <tfoot>
                                                <tr>
                                                    <td colspan="2"><input type="button"
                                                            value="{$LANG->getModule('price_config_add')}"
                                                            onclick="nv_price_config_add_item();"
                                                            class="btn btn-info" /></td>
                                                </tr>
                                            </tfoot>
                                            <tbody>
                                                {foreach from=$typeprice2 key=k item=v}
                                                <tr>
                                                    <td><input class="form-control" type="number"
                                                            name="price_config[{$v.id}][number_to]"
                                                            value="{$v.number_to}" /></td>
                                                    <td><input class="form-control" type="text"
                                                            name="$v[{$v.id}][price]" value="{$v.price}"
                                                            onkeyup="this.value=FormatNumber(this.value);"
                                                            style="text-align: right" /></td>
                                                </tr>
                                                {/foreach}
                                            </tbody>
                                        </table>
                                    </div>
                                    <div class="col-md-5">
                                        <select class="form-control" name="money_unit">
                                            {foreach from=$money_config key=k item=v}
                                            <option value="{$v.code}" {$v.select}>{$v.currency}</option>
                                            {/foreach}
                                        </select>
                                    </div>
                                </div>
                                {/if}
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card border-primary border-3 border-bottom-0 border-start-0 border-end-0 mt-4">
                <div class="card-header py-2" role="button" data-bs-toggle="collapse"
                    data-bs-target="#collapse-general-img" aria-expanded="true" aria-controls="collapse-general-img">
                    <div class="hstack gap-2 align-items-center justify-content-between">
                        <div class="fw-medium fs-5">{$LANG->getModule('content_homeimg')}</div>
                        <div class="collapse-button"></div>
                    </div>
                </div>

                <div class="collapse show" id="collapse-general-img">
                    <div class="card card-body">
                        <div id="otherimage">
                            <div class="row">
                                <div class="col-sm-12 col-lg-12 col-xxl-12">
                                    <div class="input-group">
                                        <input class="form-control" type="text" name="homeimg" id="homeimg"
                                            value="{$rowcontent.homeimgfile}" />
                                        <button class="btn btn-default" type="button" id="selectimg">
                                            <em class="fa fa-folder-open-o fa-fix">&nbsp;</em>
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <div class="row mt-2">
                                <div class="col-sm-12 col-lg-12 col-xxl-12">
                                    <input class="form-control" type="text" maxlength="255"
                                        value="{$rowcontent.homeimgalt}" name="homeimgalt"
                                        placeholder="{$LANG->getModule('content_homeimgalt')}" />
                                </div>
                            </div>

                            {if !empty($DATAOTHERIMAGE)}
                            {foreach from=$DATAOTHERIMAGE key=k item=v}
                            <div class="row mt-2">
                                <div class="col-sm-12 col-lg-12 col-xxl-12">
                                    <div class="input-group">
                                        <input value="{$v.value}" name="otherimage[]" id="otherimage_{$v.id}"
                                            class="form-control" maxlength="255">
                                        <button class="btn btn-default" type="button"
                                            onclick="nv_open_browse( '{$smarty.const.NV_BASE_ADMINURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&{$smarty.const.NV_NAME_VARIABLE}=upload&popup=1&area=otherimage_{$v.id}&path={$smarty.const.NV_UPLOADS_DIR}/{$MODULE_UPLOAD}&currentpath={$CURRENT}&type=file', 'NVImg', 850, 500, 'resizable=no,scrollbars=no,toolbar=no,location=no,status=no' ); return false; ">
                                            <em class="fa fa-folder-open-o fa-fix">&nbsp;</em>
                                        </button>
                                    </div>
                                </div>
                            </div>
                            {/foreach}
                            {/if}
                        </div>

                        <div class="row mt-2">
                            <div class="col-sm-12 col-lg-12 col-xxl-12">
                                <input type="button" class="btn btn-info" onclick="nv_add_otherimage();"
                                    value="{$LANG->getModule('add_otherimage')}">
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card border-primary border-3 border-bottom-0 border-start-0 border-end-0 mt-4">
                <div class="card-header py-2" role="button" data-bs-toggle="collapse" data-bs-target="#collapse-gtng"
                    aria-expanded="true" aria-controls="collapse-gtng">
                    <div class="hstack gap-2 align-items-center justify-content-between">
                        <div class="fw-medium fs-5">
                            {$LANG->getModule('content_hometext')} <span class="require">(*)</span>
                            {$LANG->getModule('content_notehome')}
                        </div>
                        <div class="collapse-button"></div>
                    </div>
                </div>

                <div class="collapse show" id="collapse-gtng">
                    <div class="card card-body">
                        <div id="hometext">
                            {$edit_hometext}
                        </div>

                    </div>
                </div>
            </div>

            <div class="card border-primary border-3 border-bottom-0 border-start-0 border-end-0 mt-4">
                <div class="card-header py-2" role="button" data-bs-toggle="collapse"
                    data-bs-target="#collapse-bodytext" aria-expanded="true" aria-controls="collapse-bodytext">
                    <div class="hstack gap-2 align-items-center justify-content-between">
                        <div class="fw-medium fs-5">
                            {$LANG->getModule('content_bodytext')} <span class="require">(*)</span>
                            {$LANG->getModule('content_notehome')}
                        </div>
                        <div class="collapse-button"></div>
                    </div>
                </div>

                <div class="collapse show" id="collapse-bodytext">
                    <div class="card card-body">
                        <div id="bodytext">
                            {$edit_bodytext}
                        </div>

                    </div>
                </div>
            </div>

            {if !empty($FILES)}
            <div class="card border-primary border-3 border-bottom-0 border-start-0 border-end-0 mt-4">
                <div class="card-header py-2" role="button" data-bs-toggle="collapse"
                    data-bs-target="#collapse-bodytext" aria-expanded="true" aria-controls="collapse-bodytext">
                    <div class="hstack gap-2 align-items-center justify-content-between">
                        <div class="fw-medium fs-5">{$LANG->getModule('download_file')}</div>
                        <div class="collapse-button"></div>
                    </div>
                </div>

                <div class="collapse show" id="collapse-bodytext">
                    <div class="card card-body">
                        <div class="row">
                            <div class="col-md-19">
                                <select name="files[]" id="files" class="form-control" style="width: 100%"
                                    multiple="multiple">
                                    {foreach from=$FILES key=k item=v}
                                    <option value="{$v.id}" {$v.selected}>{$v.title}</option>
                                    {/foreach}
                                </select>
                            </div>
                            <div class="col-md-1">
                                <span class="text-middle">{$LANG->getModule('download_file_or')}</span>
                            </div>
                            <div class="col-md-4">
                                <button class="btn btn-primary" id="add_file"
                                    type="button">{$LANG->getModule('download_file_add')}</button>
                            </div>
                        </div>
                    </div>
                </div>
                {/if}

                {if $pro_config['active_gift']}
                <div class="card border-primary border-3 border-bottom-0 border-start-0 border-end-0 mt-4">
                    <div class="card-header py-2" role="button" data-bs-toggle="collapse"
                        data-bs-target="#collapse-active-gift" aria-expanded="true"
                        aria-controls="collapse-active-gift">
                        <div class="hstack gap-2 align-items-center justify-content-between">
                            <div class="fw-medium fs-5">{$LANG->getModule('content_gift')}</div>
                        </div>
                    </div>

                    <div class="collapse show" id="collapse-active-gift">
                        <div class="card card-body">
                            <div class="row">
                                <div class="col-xs-6 col-sm-6">
                                    <div class="form-group">
                                        <textarea class="form-control" name="gift_content"
                                            style="height: 85px">{$rowcontent.gift_content}</textarea>
                                    </div>
                                </div>

                                <div class="col-xs-6 col-sm-6">
                                    <div class="row">
                                        <div class="col-sm-6">
                                            <div class="form-group">
                                                <div class="input-group">
                                                    <input type="text" class="form-control" name="gift_from"
                                                        value="{$rowcontent.gift_from}" id="gift_from"
                                                        placeholder="{$LANG->getModule('date_from')}"> <span
                                                        class="input-group-btn">
                                                        <button class="btn btn-default" type="button" id="from-btn">
                                                            <em class="fa fa-calendar fa-fix">&nbsp;</em>
                                                        </button>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-3">
                                            <select class="form-control" name="gift_from_h" style="width: 100%">
                                                {$gift_from_h}
                                            </select>
                                        </div>
                                        <div class="col-sm-3">
                                            <select class="form-control" name="gift_from_m" style="width: 100%">
                                                {$gift_from_m}
                                            </select>
                                        </div>
                                    </div>

                                    <div class="row mt-3">
                                        <div class="col-sm-6">
                                            <div class="form-group">
                                                <div class="input-group">
                                                    <input type="text" class="form-control" name="gift_to"
                                                        value="{$rowcontent.gift_to}" id="gift_to"
                                                        placeholder="{$LANG->getModule('date_to')}" autocomplete="off">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-default" type="button" id="to-btn">
                                                            <em class="fa fa-calendar fa-fix">&nbsp;</em>
                                                        </button>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-3">
                                            <select class="form-control" name="gift_to_h" style="width: 100%">
                                                {$gift_to_h}
                                            </select>
                                        </div>
                                        <div class="col-sm-3">
                                            <select class="form-control" name="gift_to_m" style="width: 100%">
                                                {$gift_to_m}
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                {/if}

                <div class="card border-primary border-3 border-bottom-0 border-start-0 border-end-0 mt-4">
                    <div class="card-header py-2" role="button" data-bs-toggle="collapse"
                        data-bs-target="#collapse-active-gift" aria-expanded="true"
                        aria-controls="collapse-active-gift">
                        <div class="hstack gap-2 align-items-center justify-content-between">
                            <div class="fw-medium fs-5">{$DATACUSTOM_FORM}{$LANG->getModule('tag')}</div>
                        </div>
                    </div>

                    <div class="collapse show" id="collapse-active-gift">
                        <div class="card card-body">
                            <div class="row">
                                <div class="form-group">
                                    <label class="col-md-12 control-label">{$LANG->getModule('tag_title')}</label>
                                    <div class="col-md-12">
                                        <input type="text" maxlength="255" value="{$rowcontent.tag_title}"
                                            name="tag_title" class="form-control" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-md-12 control-label">{$LANG->getModule('tag_description')}</label>
                                    <div class="col-md-12">
                                        <textarea class="form-control"
                                            name="tag_description">{$rowcontent.tag_description}</textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 col-xl-3 col-xxl-3">
                {if !empty($row_block)}
                <div class="card border-success border-3 border-bottom-0 border-start-0 border-end-0">
                    <div class="card-header py-2" role="button" data-bs-toggle="collapse"
                        data-bs-target="#collapse-general-right-0" aria-expanded="true"
                        aria-controls="collapse-general-right-0">
                        <div class="hstack gap-2 align-items-center justify-content-between">
                            <div class="fw-medium fs-5">{$LANG->getModule('content_block')}</div>
                            <div class="collapse-button"></div>
                        </div>
                    </div>

                    <div class="collapse show" id="collapse-general-right-0">
                        <div class="card card-body">
                            {$row_block}
                        </div>
                    </div>
                </div>
                {/if}

                <div class="card border-success border-3 border-bottom-0 border-start-0 border-end-0 mt-4">
                    <div class="card-header py-2" role="button" data-bs-toggle="collapse"
                        data-bs-target="#collapse-general-right-1" aria-expanded="true"
                        aria-controls="collapse-general-right-1">
                        <div class="hstack gap-2 align-items-center justify-content-between">
                            <div class="fw-medium fs-5">{$LANG->getModule('content_keywords')}</div>
                            <div class="collapse-button"></div>
                        </div>
                    </div>

                    <div class="collapse show" id="collapse-general-right-1">
                        <div class="card card-body">
                            <div class="message_body" style="overflow: auto">
                                <div class="clearfix uiTokenizer uiInlineTokenizer">
                                    <div id="keywords" class="tokenarea">
                                        {foreach from=$KEYWORDS key=k item=v}
                                        <span class="uiToken removable" title="{$v}"> {$v}
                                            <input type="hidden" autocomplete="off" name="keywords[]" value="{$v}" />
                                            <a onclick="$(this).parent().remove();"
                                                class="remove uiCloseButton uiCloseButtonSmall"
                                                href="javascript:void(0);"></a>
                                        </span>
                                        {/foreach}
                                    </div>
                                    <div class="uiTypeahead">
                                        <div class="wrap">
                                            <div class="input-group">
                                                <input id="keywords-search" type="text" class="form-control"
                                                    placeholder="Nhập từ khóa..." />

                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card border-success border-3 border-bottom-0 border-start-0 border-end-0 mt-4">
                    <div class="card-header py-2" role="button" data-bs-toggle="collapse"
                        data-bs-target="#collapse-general-right-2" aria-expanded="true"
                        aria-controls="collapse-general-right-2">
                        <div class="hstack gap-2 align-items-center justify-content-between">
                            <div class="fw-medium fs-5">{$LANG->getModule('content_publ_date')} <span
                                    class="timestamp">{$LANG->getModule('content_notetime')}</span></div>
                            <div class="collapse-button"></div>
                        </div>
                    </div>

                    <div class="collapse show" id="collapse-general-right-2">
                        <div class="card card-body">
                            <div class="form-group">
                                <div class="input-group">
                                    <input class="form-control" name="publ_date" id="publ_date" value="{$publ_date}"
                                        maxlength="10" type="text" /> <span class="input-group-btn">
                                        <button class="btn btn-default" type="button" id="publ_date-btn">
                                            <em class="fa fa-calendar fa-fix">&nbsp;</em>
                                        </button>
                                    </span>
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col-sm-6">
                                    <select class="form-control" name="phour"> {$phour}
                                    </select>
                                </div>
                                <div class="col-sm-6">
                                    <select class="form-control" name="pmin"> {$pmin}
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card border-success border-3 border-bottom-0 border-start-0 border-end-0 mt-4">
                    <div class="card-header py-2" role="button" data-bs-toggle="collapse"
                        data-bs-target="#collapse-general-right-3" aria-expanded="true"
                        aria-controls="collapse-general-right-3">
                        <div class="hstack gap-2 align-items-center justify-content-between">
                            <div class="fw-medium fs-5">{$LANG->getModule('content_exp_date')} <span
                                    class="timestamp">{$LANG->getModule('content_notetime')}</span></div>
                            <div class="collapse-button"></div>
                        </div>
                    </div>

                    <div class="collapse show" id="collapse-general-right-3">
                        <div class="card card-body">
                            <div class="form-group">
                                <div class="input-group">
                                    <input class="form-control" name="exp_date" id="exp_date" value="{$exp_date}"
                                        maxlength="10" type="text" /> <span class="input-group-btn">
                                        <button class="btn btn-default" type="button" id="exp_date-btn">
                                            <em class="fa fa-calendar fa-fix">&nbsp;</em>
                                        </button>
                                    </span>
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col-sm-6">
                                    <select class="form-control" name="ehour"> {$ehour}
                                    </select>
                                </div>
                                <div class="col-sm-6">
                                    <select class="form-control" name="emin"> {$emin}
                                    </select>
                                </div>
                            </div>

                            <div class="mt-2">
                                <div class="form-check">
                                    <input class="form-check-input" name="archive" type="checkbox" value="1"
                                        id="archive" {$archive_checked}>
                                    <label class="form-check-label" for="archive">
                                        {$LANG->getModule('content_archive')}
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card border-success border-3 border-bottom-0 border-start-0 border-end-0 mt-4">
                    <div class="card-header py-2" role="button" data-bs-toggle="collapse"
                        data-bs-target="#collapse-general-right-5" aria-expanded="true"
                        aria-controls="collapse-general-right-5">
                        <div class="hstack gap-2 align-items-center justify-content-between">
                            <div class="fw-medium fs-5">{$LANG->getModule('content_extra')}</div>
                            <div class="collapse-button"></div>
                        </div>
                    </div>

                    <div class="collapse show" id="collapse-general-right-5">
                        <div class="card card-body">
                            <div style="margin-bottom: 2px;">
                                <input type="checkbox" value="1" name="inhome" {$inhome_checked} />
                                <label>{$LANG->getModule('content_inhome')}</label>
                            </div>
                            <div style="margin-bottom: 2px;">
                                <input type="checkbox" value="1" name="allowed_rating" {$allowed_rating_checked} />
                                <label>{$LANG->getModule('content_allowed_rating')}</label>
                            </div>
                            <div style="margin-bottom: 2px;">
                                <input type="checkbox" value="1" name="allowed_send" {$allowed_send_checked} />
                                <label>{$LANG->getModule('content_allowed_send')}</label>
                            </div>
                            <div style="margin-bottom: 2px;">
                                <input type="checkbox" value="1" name="allowed_print" {$allowed_print_checked} />
                                <label>{$LANG->getModule('content_allowed_print')}</label>
                            </div>
                            <div style="margin-bottom: 2px;">
                                <input type="checkbox" value="1" name="allowed_save" {$allowed_save_checked} />
                                <label>{$LANG->getModule('content_allowed_save')}</label>
                            </div>
                            <div style="margin-bottom: 2px;">
                                <input type="checkbox" name="showprice" value="1"
                                    {$ck_showprice} />{$LANG->getModule('content_showprice')}
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card border-success border-3 border-bottom-0 border-start-0 border-end-0 mt-4">
                    <div class="card-header py-2" role="button" data-bs-toggle="collapse"
                        data-bs-target="#collapse-general-right-6" aria-expanded="true"
                        aria-controls="collapse-general-right-6">
                        <div class="hstack gap-2 align-items-center justify-content-between">
                            <div class="fw-medium fs-5">{$LANG->getModule('content_allowed_comm')}</div>
                            <div class="collapse-button"></div>
                        </div>
                    </div>

                    <div class="collapse show" id="collapse-general-right-6">
                        <div class="card card-body">
                            {foreach from=$groups_list key=k item=v}
                            <div class="row">
                                <label><input name="allowed_comm[]" type="checkbox" value="{$v.value}"
                                        {$v.checked} />&nbsp;{$v.title}</label>
                            </div>
                            {/foreach}
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12 col-xl-12 col-xxl-12">
                <div class="card border-success border-3 border-bottom-0 border-start-0 border-end-0">
                    <div class="card-header py-2" role="button" data-bs-toggle="collapse"
                        data-bs-target="#collapse-general-right-10" aria-expanded="true"
                        aria-controls="collapse-general-right-10">
                        <div class="hstack gap-2 align-items-center justify-content-between">
                            <div class="fw-medium fs-5">{$LANG->getModule('content_group')}</div>
                        </div>
                    </div>

                    <div class="collapse show" id="collapse-general-right-0">
                        <div class="card card-body">
                            <div id="list_group" class="custom-checkbox-group">
                                <div id="listgroupid">&nbsp;</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="text-center" style="margin-top: 10px">
            <input type="hidden" name="copy" value="{$IS_COPY}">
            {if ($rowcontent['status'] == 1)}
            <input class="btn btn-primary submitform" name="sst1" data-status="1" type="submit"
                value="{$LANG->getModule('save')}" />
            {else}
            <input class="btn btn-primary submitform" name="sst0" data-status="0" type="submit"
                value="{$LANG->getModule('save_temp')}" />
            <input class="btn btn-primary submitform" name="sst1" data-status="1" type="submit"
                value="{$LANG->getModule('publtime')}" />
            {/if}
        </div>
</form>
<div id="message"></div>
<div class="modal fade" id="idmodals" tabindex="-1" role="dialog"
    aria-labelledby="{$LANG->getModule('download_file_add')}" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4>{$LANG->getModule('download_file_add')}</h4>
            </div>
            <div class="modal-body">
                <p class="text-center">
                    <i class="fa fa-spinner fa-spin fa-3x"></i>
                </p>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript"
    src="{$smarty.const.NV_BASE_SITEURL}{$smarty.const.NV_ASSETS_DIR}/js/select2/select2.min.js"></script>
<script type="text/javascript"
    src="{$smarty.const.NV_BASE_SITEURL}{$smarty.const.NV_ASSETS_DIR}/js/jquery-ui/jquery-ui.min.js"></script>
<script type="text/javascript"
    src="{$smarty.const.NV_BASE_SITEURL}{$smarty.const.NV_ASSETS_DIR}/js/language/jquery.ui.datepicker-{$smarty.const.NV_LANG_INTERFACE}.js"></script>
<script type="text/javascript" src="{$smarty.const.NV_BASE_SITEURL}themes/admin_default/js/content.js"></script>

<script type="text/javascript">
    var file_items = '{$FILE_ITEMS}';
    var file_selectfile = '{$LANG->getModule('file_selectfile')}'
    var nv_base_adminurl = '{$NV_BASE_ADMINURL}';
    var inputnumber = '{$LANG->getModule('error_inputnumber')}'
    var file_dir = '{$NV_UPLOADS_DIR}/{$MODULE_UPLOAD}';
    var currentpath = "{$CURRENT}";
    console.log(inputnumber);

    $(document).ready(function () {
        $("#catid").select2();
        $("#catid").trigger("change");

        $('.submitform').click(function (e) {
            e.preventDefault();

            const editorData = {};

            // Duyệt qua các editor trong window.nveditor
            for (const editorId in window.nveditor) {
                if (window.nveditor.hasOwnProperty(editorId)) {
                    const editorInstance = window.nveditor[editorId];
                    editorData[editorId] = editorInstance.getData(); // Lấy dữ liệu của từng editor
                }
            }

            let formData = $('#frm-submit').serialize() + '&status=' + $(this).data('status');

            // Thêm dữ liệu từ editor vào dữ liệu gửi
            for (const key in editorData) {
                if (editorData.hasOwnProperty(key)) {
                    formData += '&' + key + '=' + encodeURIComponent(editorData[key]);
                }
            }
            console.log(location.href);
            $.ajax({
                type: 'POST',
                url: location.href,
                data: formData,
                success: function (json) {
                    if (json['status'] == 'success') {
                        $(window).unbind();
                        nvToast("Cập nhật sản phẩm thành công", 'success', "l", "t");
                        setTimeout(function () {
                            window.location.href = json.redirect;
                        }, 1000);
                    } else {
                        alert(json.msg);
                    }
                }
            });
        });
    });

    $("#selectimg").click(function () {
        var area = "homeimg";
        var path = "{$NV_UPLOADS_DIR}/{$MODULE_UPLOAD}";
        var currentpath = "{$CURRENT}";
        var type = "image";
        nv_open_browse("{$smarty.const.NV_BASE_ADMINURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&{$smarty.const.NV_NAME_VARIABLE}=upload&popup=1&area=" + area + "&path=" + path + "&type=" + type + "&currentpath=" + currentpath, "NVImg", 850, 500, "resizable=no,scrollbars=no,toolbar=no,location=no,status=no");
        return false;
    });

    $('[type="submit"]').hover(function () {
        if ($('[name="keywords[]"]').length == 0) {
            if ($('#message-tags').length == 0) {
                $('#message').html('<div style="margin-top: 10px" id="message-tags" class="alert alert-danger">{$LANG->getModule('content_tags_empty')}.{$LANG->getModule('content_tags_empty_auto')}.</div>');
            }
        } else {
            $('#message-tags').remove();
        }
    });

    $.get('{$url_load}', function (data) {
        if (data != '') {
            $('#list_group').show();
            $("#listgroupid").html(data);
        }
    });

    console.log('{$url_load}');
</script>

{if !empty($FILES)}
<script type="text/javascript">
    $(document).ready(function () {
        $("#files").select2({
            placeholder: "{$LANG->getModule('download_file_chose_h')}"
        });

        $('#add_file').click(function () {
            $('#idmodals').removeData('bs.modal');
            $('#idmodals').on('show.bs.modal', function () {
                $('#idmodals .modal-body').load(script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=download&popup=1');
            }).modal();
        });
    });
</script>
{/if}

{if empty($rowcontent['alias'])}
<script type="text/javascript">
    $(document).ready(function () {
        $("#idtitle").change(function () {
            get_alias('content', '{$ALIAS}');
        });
    });
</script>
{/if}

{if (!$is_submit and $is_copy)}
<script type="text/javascript">
    $(document).ready(function () {
        get_alias('content', '{$ALIAS}');
    });
</script>
{/if}
<style>
    .select2-container--default .select2-selection--single .select2-selection__rendered {
        line-height: unset;
    }

    .select2-container .select2-selection--single {
        height: auto !important;
    }

    .form-check-label {
        user-select: none;
    }

    /* Container tổng */
    .custom-checkbox-group {
        padding: 15px;
        background-color: #f9f9f9;
        border: 1px solid #ddd;
        border-radius: 8px;
    }

    /* Style cho mỗi item */
    .checkbox-item {
        display: inline-flex;
        align-items: center;
        margin: 8px 10px;
        padding: 8px;
        border: 1px solid #ddd;
        border-radius: 6px;
        background: #fff;
        cursor: pointer;
        transition: box-shadow 0.3s ease;
    }

    .checkbox-item:hover {
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    }

    /* Checkbox ẩn nhưng vẫn hoạt động */
    .checkbox-item input[type="checkbox"] {
        display: none;
    }

    /* Hình ảnh hiển thị bên cạnh */
    .checkbox-item img {
        width: 40px;
        height: 40px;
        object-fit: cover;
        margin-right: 8px;
        border-radius: 4px;
        border: 1px solid #ddd;
    }

    /* Văn bản */
    .checkbox-item span {
        font-size: 14px;
        font-weight: 500;
        color: #333;
    }

    /* Hiệu ứng khi chọn */
    .checkbox-item input[type="checkbox"]:checked+img {
        border-color: #0d6efd;
    }

    .checkbox-item input[type="checkbox"]:checked+span {
        color: #0d6efd;
        font-weight: 600;
    }
</style>

<script type="text/javascript">
    function nv_change_catid(obj, id) {
        var cid = $(obj).val();
        var parentid = $(obj).children('option:selected').attr('data-label');

        // Gọi AJAX để load lại dropdown discount
        $.ajax({
            type: 'POST',
            url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=content&nocache=' + new Date().getTime(),
            data: 'change_catid=1&catid=' + cid + '&id=' + id,
            dataType: 'json',
            success: function (json) {
                if (json.status == 'ok') {
                    $('#discount_id').replaceWith(json.html);
                    $('#discount_id').select2();
                }
            }
        });
    }

    $(document).ready(function () {
        $("#catid, #discount_id").select2();
    });

    function get_alias(mod, id) {
        var title = strip_tags(document.getElementById('idtitle').value);
        if (title != '') {
            $.post(script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=alias&nocache=' + new Date().getTime(), 'title=' + encodeURIComponent(title) + '&mod=' + mod + '&id=' + id, function (res) {
                if (res != "") {
                    document.getElementById('idalias').value = res;
                } else {
                    document.getElementById('idalias').value = '';
                }
            });
        }
    }

    // Hàm hỗ trợ
    function strip_tags(str) {
        str = str.toString();
        return str.replace(/<\/?[^>]+>/gi, '');
    }
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
            var strphanthapphan = strTemp.substring(strTemp.lastIndexOf("."), strTemp.length);
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

    $(document).ready(function () {
        $("#catid").select2();

        $("#idtitle").change(function () {
            get_alias('content', '{$ALIAS}');
        });

        $(".btn-default i.fa-refresh").parent().click(function () {
            get_alias('content', '{$ALIAS}');
        });
    });

</script>