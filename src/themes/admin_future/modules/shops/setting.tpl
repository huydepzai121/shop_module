<form action="" method="post">
    <div class="row g-4">
        <div class="col-xxl-6">
            <!-- Card Cấu hình chung -->
            <div class="card border-primary border-3 border-bottom-0 border-start-0 border-end-0">
                <div class="card-header fs-5 fw-medium">{$LANG->getModule('general_config')}</div>
                <div class="card-body pt-4">
                    <!-- Các cấu hình chung -->
                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_active_order_active')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" name="active_order"
                                    value="1" {if $DATA.active_order}checked{/if}>
                            </div>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_active_payment')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" name="active_payment"
                                    value="1" {if $DATA.active_payment}checked{/if}>
                                <label
                                    class="form-check-label">{$LANG->getModule('setting_active_payment_note')}</label>
                            </div>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_shipping')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" name="use_shipping"
                                    value="1" {if $DATA.use_shipping}checked{/if}>
                            </div>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_coupons')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" name="use_coupons"
                                    value="1" {if $DATA.use_coupons}checked{/if}>
                            </div>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_point_active')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" name="point_active"
                                    value="1" {if $DATA.point_active}checked{/if}>
                            </div>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_active_wishlist')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" name="active_wishlist"
                                    value="1" {if $DATA.active_wishlist}checked{/if}>
                            </div>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_active_gift')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" name="active_gift"
                                    value="1" {if $DATA.active_gift}checked{/if}>
                            </div>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_active_warehouse')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" name="active_warehouse"
                                    value="1" {if $DATA.active_warehouse}checked{/if}>
                            </div>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('review_setting_active')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" name="review_active"
                                    value="1" {if $DATA.review_active}checked{/if}>
                            </div>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('template_setting_active')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" name="template_active"
                                    value="1" {if $DATA.template_active}checked{/if}>
                            </div>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('download_setting_active')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" name="download_active"
                                    id="download_active" value="1" {if $DATA.download_active}checked{/if}>
                            </div>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('saleprice_setting_active')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" name="saleprice_active"
                                    value="1" {if $DATA.saleprice_active}checked{/if}>
                            </div>
                        </div>
                    </div>
                    <div class="row mb-3" id="download_groups" {if !$DATA.download_active}style="display:none" {/if}>
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('download_setting_groups')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            {foreach from=$DOWNLOAD_GROUPS item=group}
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="download_groups[]"
                                    value="{$group.value}" {if $group.checked}checked{/if}>
                                <label class="form-check-label">{$group.title}</label>
                            </div>
                            {/foreach}
                        </div>
                    </div>
                </div>
            </div>

            <!-- Card Cấu hình hiển thị -->
            <div class="card border-primary border-3 border-bottom-0 border-start-0 border-end-0 mt-4">
                <div class="card-header fs-5 fw-medium">{$LANG->getModule('display_config')}</div>
                <div class="card-body pt-4">
                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_home_view')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <select class="form-select" name="home_view">
                                {foreach from=$HOME_VIEWS item=view}
                                <option value="{$view.index}" {if $view.selected}selected{/if}>{$view.value}</option>
                                {/foreach}
                            </select>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_homesite')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <input class="form-control" type="text" value="{$DATA.homewidth}" style="width: 60px;"
                                name="homewidth" /><span class="text-middle"> x </span><input class="form-control"
                                type="text" value="{$DATA.homeheight}" style="width: 60px;" name="homeheight" />
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_per_page')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <input class="form-control" type="text" value="{$DATA.per_page}" style="width: 60px;"
                                name="per_page" /><span class="text-middle">
                                {$LANG->getModule('setting_per_note_home')} </span>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_per_row')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <select class="form-control" name="per_row">
                                {foreach from=$PER_ROWS item=row}
                                <option value="{$row.value}" {if $row.selected}selected{/if}>{$row.value}</option>
                                {/foreach}
                            </select>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_displays')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <input type="checkbox" value="1" name="show_displays" {if
                                $DATA.show_displays}checked{/if} />
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_active_tooltip')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <input type="checkbox" value="1" name="active_tooltip" {if $DATA.active_tooltip}checked{/if}
                                id="active_tooltip" />
                        </div>
                    </div>
                </div>
            </div>

            <!-- Card Cấu hình module -->
            <div class="card border-primary border-3 border-bottom-0 border-start-0 border-end-0">
                <div class="card-header fs-5 fw-medium">{$LANG->getModule('setting')}</div>
                <div class="card-body pt-4">
                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_hometext')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" name="active_showhomtext"
                                    value="1" {if $DATA.active_showhomtext}checked{/if}>
                            </div>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_active_price')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" name="active_price"
                                    value="1" {if $DATA.active_price}checked{/if} id="active_price">
                            </div>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_compare')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" name="show_compare"
                                    value="1" {if $DATA.show_compare}checked{/if}>
                            </div>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_money_all')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <select class="form-select" name="money_unit">
                                {foreach from=$MONEY_UNITS item=unit}
                                <option value="{$unit.value}" {if $unit.selected}selected{/if}>{$unit.title}</option>
                                {/foreach}
                            </select>
                            <em class="fa fa-info-circle fa-lg text-info ms-2" data-toggle="tooltip" title=""
                                data-original-title="{$LANG->getModule('setting_money_all_note')}">&nbsp;</em>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_weight_all')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <select class="form-select" name="weight_unit">
                                {foreach from=$WEIGHT_UNITS item=unit}
                                <option value="{$unit.value}" {if $unit.selected}selected{/if}>{$unit.title}</option>
                                {/foreach}
                            </select>
                            <em class="fa fa-info-circle fa-lg text-info ms-2" data-toggle="tooltip" title=""
                                data-original-title="{$LANG->getModule('setting_weight_all_note')}">&nbsp;</em>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('format_order_id')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="d-flex align-items-center">
                                <input class="form-control" type="text" value="{$DATA.format_order_id}"
                                    style="width: 100px;" name="format_order_id" />
                                <span class="text-middle ms-2">{$LANG->getModule('format_order_id_note')}</span>
                            </div>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('format_code_id')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="d-flex align-items-center">
                                <input class="form-control" type="text" value="{$DATA.format_code_id}"
                                    style="width: 100px;" name="format_code_id" />
                                <span class="text-middle ms-2">{$LANG->getModule('format_order_id_note')}</span>
                            </div>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_facebookAppID')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="d-flex align-items-center">
                                <input class="form-control w150" name="facebookappid" value="{$DATA.facebookappid}"
                                    type="text" />
                                <span class="text-middle ms-2">{$LANG->getModule('setting_facebookAppIDNote')}</span>
                            </div>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_alias_lower')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" name="alias_lower"
                                    value="1" {if $DATA.alias_lower}checked{/if} id="alias_lower">
                            </div>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_show_product_code')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" name="show_product_code"
                                    value="1" {if $DATA.show_product_code}checked{/if} id="show_product_code">
                            </div>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_sortdefault')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <select class="form-select w200" name="sortdefault">
                                {foreach from=$SORT_DEFAULTS item=sort}
                                <option value="{$sort.index}" {if $sort.selected}selected{/if}>{$sort.value}</option>
                                {/foreach}
                            </select>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xxl-6">
            <!-- Card Cấu hình chức năng đặt hàng -->
            <div class="card border-primary border-3 border-bottom-0 border-start-0 border-end-0">
                <div class="card-header fs-5 fw-medium">{$LANG->getModule('setting_active_order')}</div>
                <div class="card-body pt-4">
                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_guest_order')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" name="active_guest_order"
                                    value="1" {if $DATA.active_guest_order}checked{/if}>
                            </div>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_active_order_non_detail')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch"
                                    name="active_order_non_detail" value="1" {if
                                    $DATA.active_order_non_detail}checked{/if}>
                            </div>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_active_order_popup')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" name="active_order_popup"
                                    value="1" {if $DATA.active_order_popup}checked{/if}>
                            </div>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_active_order_number')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" name="active_order_number"
                                    value="1" {if $DATA.active_order_number}checked{/if}>
                                <label
                                    class="form-check-label">{$LANG->getModule('setting_active_order_number_note')}</label>
                            </div>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_active_auto_check_order')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" name="auto_check_order"
                                    value="1" {if $DATA.auto_check_order}checked{/if}>
                            </div>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_group_notify')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <em class="help-block">{$LANG->getModule('setting_group_notify_note')}</em>
                            {foreach from=$NOTIFY_GROUPS item=group}
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="groups_notify[]"
                                    value="{$group.value}" {if $group.checked}checked{/if}>
                                <label class="form-check-label">{$group.title}</label>
                            </div>
                            {/foreach}
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_order_day')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <input type="text" name="order_day" class="form-control" value="{$DATA.order_day}">
                            <span class="help-block">{$LANG->getModule('setting_order_day_note')}</span>
                            <span class="text-middle">{$LANG->getModule('setting_order_num_day')}</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Card Đánh giá sản phẩm -->
            <div class="card border-primary border-3 border-bottom-0 border-start-0 border-end-0 mt-4">
                <div class="card-header fs-5 fw-medium">{$LANG->getModule('review')}</div>
                <div class="card-body pt-4">
                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('review_setting_check')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" name="review_check"
                                    value="1" {if $DATA.review_check}checked{/if}>
                            </div>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('review_setting_captcha')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" name="review_captcha"
                                    value="1" {if $DATA.review_captcha}checked{/if}>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Card Từ khóa -->
            <div class="card border-primary border-3 border-bottom-0 border-start-0 border-end-0 mt-4">
                <div class="card-header fs-5 fw-medium">{$LANG->getModule('keywords')}</div>
                <div class="card-body pt-4">
                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('tags_alias')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" name="tags_alias"
                                    value="1" {if $DATA.tags_alias}checked{/if}>
                            </div>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_auto_tags')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" name="auto_tags" value="1"
                                    {if $DATA.auto_tags}checked{/if}>
                            </div>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_tags_remind')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch" name="tags_remind"
                                    value="1" {if $DATA.tags_remind}checked{/if}>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Card Cấu hình điểm tích lũy -->
            <div class="card border-primary border-3 border-bottom-0 border-start-0 border-end-0 mt-4">
                <div class="card-header fs-5 fw-medium">{$LANG->getModule('setting_point')}</div>
                <div class="card-body pt-4">
                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_point_conversion')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="d-flex align-items-center">
                                <input type="text" name="point_conversion" class="form-control"
                                    value="{$DATA.point_conversion}" onkeyup="this.value=FormatNumber(this.value);">
                                <span class="text-middle ms-2">{$DATA.money_unit} /
                                    {$LANG->getModule('setting_point_1')}</span>
                            </div>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_point_new_order')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <input type="text" name="point_new_order" class="form-control"
                                value="{$DATA.point_new_order}">
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_money_to_point')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="d-flex align-items-center">
                                <input type="text" name="money_to_point" class="form-control"
                                    value="{$DATA.money_to_point}" onkeyup="this.value=FormatNumber(this.value);">
                                <span class="text-middle ms-2">{$DATA.money_unit}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Card Cấu hình lọc sản phẩm theo giá -->
            <div class="card border-primary border-3 border-bottom-0 border-start-0 border-end-0 mt-4">
                <div class="card-header fs-5 fw-medium">{$LANG->getModule('setting_group_price')}</div>
                <div class="card-body pt-4">
                    <div class="row mb-3">
                        <label
                            class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('setting_group_price_space')}</label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <em class="help-block">{$LANG->getModule('setting_group_price_space_note')}</em>
                            <textarea class="form-control" name="group_price" rows="9"
                                style="width: 100%">{$DATA.group_price}</textarea>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="text-center mt-4">
        <input type="hidden" value="1" name="savesetting">
        <button type="submit" class="btn btn-primary">
            <i class="fa-solid fa-save"></i> {$LANG->getModule('save')}
        </button>
    </div>
</form>

<script type="text/javascript">
    $(document).ready(function () {
        $('#download_active').change(function () {
            if ($(this).is(':checked')) {
                $('#download_groups').slideDown();
            } else {
                $('#download_groups').slideUp();
            }
        });
    });
</script>