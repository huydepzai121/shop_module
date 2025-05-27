<!-- BEGIN: main -->
<link rel="stylesheet" href="{LINK_URL}/css/swiper-bundle.min.css">
<link rel="stylesheet" href="{LINK_URL}/css/picbox.css">
<link rel="stylesheet" href="{LINK_URL}/css/lightgallery.css">
<script src="{LINK_URL}/js/swiper-bundle.min.js"></script>
<script src="{LINK_URL}/js/picbox.js"></script>
<script type="text/javascript" src="{LINK_URL}/js/custom_swiper.js"></script>

<style>
    /* Reset và cơ bản */
    .product-detail {
        padding: 20px 0;
        font-family: 'Roboto', sans-serif;
        color: #333;
    }

    /* Phần gallery sản phẩm */
    .product-gallery {
        margin-bottom: 30px;
    }
    .main-image {
        border-radius: 4px;
        overflow: hidden;
        margin-bottom: 15px;
        border: 1px solid #f0f0f0;
        position: relative;
    }
    .main-image img {
        width: 100%;
        height: auto;
        transition: all 0.3s ease;
    }
    .main-image:hover img {
        transform: scale(1.03);
    }
    .main-image img.zooming {
        animation: zoom-effect 0.3s ease;
    }
    @keyframes zoom-effect {
        0% { transform: scale(0.95); opacity: 0.7; }
        100% { transform: scale(1); opacity: 1; }
    }
    .thumbnail-gallery {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
    }
    .thumbnail-item {
        width: 80px;
        height: 80px;
        border-radius: 4px;
        overflow: hidden;
        cursor: pointer;
        border: 2px solid transparent;
        transition: all 0.2s ease;
    }
    .thumbnail-item.active {
        border-color: #4CAF50;
    }
    .thumbnail-item img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    /* Phần thông tin sản phẩm */
    .product-info h1 {
        font-size: 24px;
        font-weight: 700;
        margin-bottom: 15px;
        color: #222;
        line-height: 1.4;
    }
    .info-meta {
        margin-bottom: 15px;
        font-size: 13px;
        color: #777;
    }

    /* Đánh giá và số lượng bán */
    .rating-section {
        display: flex;
        align-items: center;
        flex-wrap: wrap;
        margin-bottom: 20px;
        padding-bottom: 15px;
        border-bottom: 1px dashed #eee;
    }
    .rating-stars {
        color: #FFC107;
        margin-right: 10px;
    }
    .rating-count {
        color: #666;
        margin-right: 15px;
        font-size: 14px;
    }
    .sales-count {
        color: #4CAF50;
        font-size: 14px;
    }
    .sales-count i {
        margin-right: 5px;
    }

    /* Giá sản phẩm */
    .price-section {
        margin: 20px 0;
        padding: 15px;
        background-color: #f9f9f9;
        border-radius: 8px;
        display: flex;
        align-items: center;
        flex-wrap: wrap;
    }
    .current-price {
        font-size: 28px;
        font-weight: 700;
        color: #e53935;
        margin-right: 15px;
    }
    .old-price {
        font-size: 18px;
        color: #999;
        text-decoration: line-through;
        margin-right: 10px;
    }
    .discount-badge {
        display: inline-block;
        padding: 3px 8px;
        background-color: #e53935;
        color: white;
        border-radius: 4px;
        font-size: 14px;
    }

    /* Đặc điểm nổi bật */
    .product-highlights {
        margin: 20px 0;
        padding: 15px;
        background-color: #f9f9f9;
        border-radius: 8px;
    }
    .highlight-title {
        font-weight: 600;
        margin-bottom: 10px;
        color: #333;
        font-size: 16px;
    }
    .highlight-content {
        color: #555;
        line-height: 1.6;
    }

    /* Chọn thuộc tính sản phẩm */
    .size-selector {
        margin: 20px 0;
    }
    .size-title {
        font-weight: 600;
        margin-bottom: 10px;
        font-size: 16px;
    }
    .size-options {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        margin-bottom: 15px;
    }
    .size-btn {
        padding: 8px 15px;
        border: 1px solid #ddd;
        border-radius: 4px;
        background: white;
        cursor: pointer;
        transition: all 0.2s;
        margin-bottom: 5px;
        margin-right: 5px;
        display: inline-block;
        font-size: 14px;
    }
    .size-btn:hover {
        border-color: #4CAF50;
        color: #4CAF50;
    }
    .size-btn.active,
    .size-btn.active__order {
        border-color: #4CAF50;
        color: #4CAF50;
        background-color: #f0fff0;
        font-weight: 600;
    }

    /* Số lượng */
    .quantity-selector {
        margin: 20px 0;
    }
    .quantity-title {
        font-weight: 600;
        margin-bottom: 10px;
        font-size: 16px;
    }
    .quantity-input {
        display: flex;
        align-items: center;
        max-width: 150px;
    }
    .quantity-input .btn {
        width: 40px;
        height: 40px;
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: #f5f5f5;
        border: 1px solid #ddd;
        color: #333;
        font-size: 16px;
        cursor: pointer;
        transition: all 0.2s;
    }
    .quantity-input .btn:hover {
        background-color: #e9e9e9;
    }
    .quantity-input input {
        width: 60px;
        height: 40px;
        text-align: center;
        border: 1px solid #ddd;
        border-left: none;
        border-right: none;
        font-size: 16px;
    }
    .stock-info {
        margin-top: 5px;
        font-size: 13px;
        color: #666;
    }

    /* Nút mua hàng */
    .action-buttons {
        display: flex;
        gap: 15px;
        margin-top: 25px;
    }
    .btn-add-cart,
    .btn-buy-now {
        flex: 1;
        padding: 12px 20px;
        border-radius: 4px;
        font-weight: 600;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.3s ease;
        text-transform: uppercase;
        font-size: 14px;
    }
    .btn-add-cart {
        background-color: #fff;
        color: #4CAF50;
        border: 1px solid #4CAF50;
    }
    .btn-add-cart:hover {
        background-color: #f0fff0;
    }
    .btn-buy-now {
        background-color: #4CAF50;
        color: white;
        border: 1px solid #4CAF50;
    }
    .btn-buy-now:hover {
        background-color: #3d9c40;
    }
    .btn-add-cart i,
    .btn-buy-now i {
        margin-right: 8px;
        font-size: 16px;
    }

    /* Chính sách */
    .product-policy {
        margin-top: 30px;
        padding: 15px;
        background-color: #f9f9f9;
        border-radius: 8px;
    }
    .policy-item {
        display: flex;
        align-items: flex-start;
        margin-bottom: 15px;
    }
    .policy-item:last-child {
        margin-bottom: 0;
    }
    .policy-item i {
        font-size: 18px;
        color: #4CAF50;
        margin-right: 10px;
        width: 24px;
        text-align: center;
        margin-top: 2px;
    }
    .policy-text {
        font-size: 14px;
        color: #555;
        line-height: 1.5;
    }

    /* Tabs thông tin chi tiết */
    .panel-default {
        border: 1px solid #eee;
        border-radius: 8px;
        margin-top: 30px;
        overflow: hidden;
    }
    .nav-tabs {
        background-color: #f9f9f9;
        border-bottom: 1px solid #eee;
    }
    .nav-tabs > li > a {
        margin-right: 0;
        border: none;
        border-radius: 0;
        padding: 15px 20px;
        color: #555;
        font-weight: 500;
        transition: all 0.2s;
    }
    .nav-tabs > li.active > a,
    .nav-tabs > li.active > a:focus,
    .nav-tabs > li.active > a:hover {
        border: none;
        border-bottom: 3px solid #4CAF50;
        color: #4CAF50;
        background-color: #fff;
    }
    .tab-content {
        padding: 20px;
    }
    .product-description {
        line-height: 1.8;
        color: #444;
    }

    /* Sản phẩm liên quan */
    .panel-product-others,
    .panel-product-viewed {
        margin-top: 40px;
        border: 1px solid #eee;
        border-radius: 8px;
        overflow: hidden;
    }
    .panel-heading {
        background-color: #f9f9f9;
        border-bottom: 1px solid #eee;
        padding: 15px 20px;
        font-weight: 600;
        color: #333;
        font-size: 16px;
    }
    .panel-body {
        padding: 20px;
    }

    /* Responsive */
    @media (max-width: 767px) {
        .action-buttons {
            flex-direction: column;
        }
        .btn-add-cart,
        .btn-buy-now {
            width: 100%;
        }
    }
    .product-info h1 {
        font-size: 24px;
        font-weight: 600;
        margin-bottom: 15px;
        color: #333;
    }
    .rating-section {
        display: flex;
        align-items: center;
        margin-bottom: 20px;
    }
    .rating-stars {
        color: #ffc107;
        margin-right: 10px;
    }
    .rating-count {
        color: #666;
        margin-right: 15px;
    }
    .sales-count {
        color: #28a745;
    }
    .price-section {
        margin: 20px 0;
        display: flex;
        align-items: center;
    }
    .current-price {
        font-size: 28px;
        font-weight: 700;
        color: #e83e8c;
    }
    .old-price {
        text-decoration: line-through;
        color: #999;
        margin-left: 10px;
    }
    .discount-badge {
        background: #e83e8c;
        color: white;
        padding: 3px 8px;
        border-radius: 4px;
        margin-left: 10px;
        font-size: 14px;
    }
    .product-highlights {
        margin: 20px 0;
        padding: 15px;
        background: #f8f9fa;
        border-radius: 8px;
    }
    .highlight-title {
        font-weight: 600;
        color: #333;
        margin-bottom: 10px;
    }
    .size-selector {
        margin: 20px 0;
    }
    .size-title {
        font-weight: 600;
        margin-bottom: 10px;
    }
    .size-options {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
    }
    .size-btn {
        padding: 8px 15px;
        border: 1px solid #ddd;
        border-radius: 4px;
        background: white;
        cursor: pointer;
        transition: all 0.2s;
        margin-bottom: 5px;
        margin-right: 5px;
        display: inline-block;
    }
    .size-btn:hover {
        border-color: #e83e8c;
        color: #e83e8c;
    }
    .size-btn.active,
    .size-btn.active__order {
        border-color: #e83e8c;
        color: #e83e8c;
        background-color: #fff0f5;
        font-weight: bold;
    }
    .quantity-selector {
        margin: 20px 0;
    }
    .quantity-title {
        font-weight: 600;
        margin-bottom: 10px;
    }
    .quantity-input {
        width: 120px;
    }
    .quantity-input .form-control {
        text-align: center;
    }
    .stock-info {
        color: #666;
        margin-top: 5px;
        font-size: 13px;
    }
    .action-buttons {
        display: flex;
        gap: 15px;
        margin-top: 30px;
    }
    .btn-add-cart,
    .btn-buy-now {
        flex: 1;
        padding: 12px;
        border: none;
        border-radius: 4px;
        font-weight: 600;
        text-transform: uppercase;
        transition: opacity 0.2s;
    }
    .btn-add-cart {
        background: #e83e8c;
        color: white;
    }
    .btn-buy-now {
        background: #6f42c1;
        color: white;
    }
    .btn-add-cart:hover,
    .btn-buy-now:hover {
        opacity: 0.9;
    }
</style>

<div class="product-detail <!-- BEGIN: popupid -->prodetail-popup<!-- END: popupid -->" itemtype="http://schema.org/Product" itemscope>
    <span class="d-none hidden hide" itemprop="mpn" content="{PRODUCT_CODE}"></span>
    <span class="d-none hidden hide" itemprop="sku" content="{PRODUCT_CODE}"></span>
    <div class="d-none hidden hide" itemprop="brand" itemtype="http://schema.org/Thing" itemscope>
        <span itemprop="name">N/A</span>
    </div>
    <!-- BEGIN: allowed_rating_snippets -->
    <div class="d-none hidden hide" itemprop="aggregateRating" itemtype="http://schema.org/AggregateRating" itemscope>
        <span itemprop="reviewCount">{RATE_TOTAL}</span>
        <span itemprop="ratingValue">{RATE_VALUE}</span>
    </div>
    <!-- END: allowed_rating_snippets -->
    <div class="d-none hidden hide" itemprop="offers" itemtype="http://schema.org/Offer" itemscope>
        <!-- BEGIN: price1 -->
        <span itemprop="price">{PRICE.sale}</span>
        <span itemprop="priceCurrency">{PRICE.unit}</span>
        <!-- END: price1 -->
        <a itemprop="url" href="{PRO_FULL_LINK}"></a>
        <span itemprop="priceValidUntil">{PRICEVALIDUNTIL}</span>
        <span itemprop="availability">{AVAILABILITY}</span>
    </div>
    <div class="row">
        <div class="col-xs-24 col-sm-12 col-md-12">
            <div class="product-gallery">
                <!-- BEGIN: oneimage -->
                <div class="main-image">
                    <img src="{IMAGE.file}" alt="{IMAGE.homeimgalt}" class="img-responsive">
                </div>
                <!-- END: oneimage -->

                <!-- BEGIN: image -->
                <div class="main-image">
                    <img src="{IMAGE.file}" alt="{DATA.homeimgalt}" class="img-responsive">
                </div>
                <div class="thumbnail-gallery">
                    <!-- BEGIN: loop -->
                    <div class="thumbnail-item <!-- BEGIN: active -->active<!-- END: active -->">
                        <img src="{IMAGE.thumb}" alt="{DATA.homeimgalt}" data-src="{IMAGE.file}">
                    </div>
                    <!-- END: loop -->
                </div>
                <!-- END: image -->

                <!-- BEGIN: product_code -->
                <p class="product-code"><strong>{LANG.product_code}:</strong> <span>{PRODUCT_CODE}</span></p>
                <!-- END: product_code -->
            </div>
        </div>

        <div class="col-xs-24 col-sm-12 col-md-12">
            <div class="product-info">
                <h1 itemprop="name">{TITLE}</h1>
                <p class="info-meta text-muted">{DATE_UP} - {NUM_VIEW} {LANG.detail_num_view}</p>

                <div class="rating-section">
                    <div class="rating-stars">
                        <i class="fa fa-star"></i>
                        <i class="fa fa-star"></i>
                        <i class="fa fa-star"></i>
                        <i class="fa fa-star"></i>
                        <i class="fa fa-star-half-o"></i>
                    </div>
                    <span class="rating-count">({RATE_TOTAL} đánh giá)</span>
                    <span class="sales-count"><i class="fa fa-check-circle"></i> Đã bán 350+</span>
                </div>

                <!-- BEGIN: price -->
                <div class="price-section">
                    <!-- BEGIN: discounts -->
                    <span class="current-price">{PRICE.sale_format} {PRICE.unit}</span>
                    <span class="old-price">{PRICE.price_format} {PRICE.unit}</span>
                    <span class="discount-badge">-{PRICE.discount_percent}%</span>
                    <!-- END: discounts -->

                    <!-- BEGIN: no_discounts -->
                    <span class="current-price">{PRICE.price_format} {PRICE.unit}</span>
                    <!-- END: no_discounts -->
                </div>
                <!-- END: price -->

                <!-- BEGIN: hometext -->
                <div class="product-highlights">
                    <div class="highlight-title">Đặc điểm nổi bật:</div>
                    <div class="highlight-content" itemprop="description">{hometext}</div>
                </div>
                <!-- END: hometext -->

                <ul class="product-info">
                    <li class="info-title name-sp"></li>

                    <!-- BEGIN: product_code -->
                    <li class="info-code">{LANG.product_code}: <strong>{PRODUCT_CODE}</strong></li>
                    <!-- END: product_code -->

                    <!-- BEGIN: product_weight -->
                    <li class="info-weight">{LANG.weights}: <strong>{PRODUCT_WEIGHT}</strong>&nbsp<span>{WEIGHT_UNIT}</span></li>
                    <!-- END: product_weight -->
                    <!-- BEGIN: contact -->
                    <li class="info-priceno">{LANG.detail_pro_price}: <span class="money">{LANG.price_contact}</span></li>
                    <!-- END: contact -->
                    <!-- BEGIN: group_detail -->
                    <li class="info-groups">
                        <!-- BEGIN: loop --> <!-- BEGIN: maintitle -->
                        <div class="pull-left">
                            <strong>{MAINTITLE}:</strong>&nbsp;
                        </div> <!-- END: maintitle --> <!-- BEGIN: subtitle -->
                        <ul class="pull-left list-inline" style="padding: 0 10px 0">
                            <!-- BEGIN: loop -->
                            <li>{SUBTITLE.title}</li>
                            <!-- END: loop -->
                        </ul>
                        <div class="clear"></div> <!-- END: subtitle --> <!-- END: loop -->
                    </li>
                    <!-- END: group_detail -->
                    <!-- BEGIN: custom_data -->
                    <div class="info-customs">{CUSTOM_DATA}</div>
                    <!-- END: custom_data -->
                    <!-- BEGIN: hometext -->
                    <li class="info-hometext">
                        <p class="text-justify" itemprop="description">{hometext}</p>
                    </li>
                    <!-- END: hometext -->
                    <!-- BEGIN: promotional -->
                    <li class="info-promotion"><strong>{LANG.detail_promotional}:</strong> {promotional}</li>
                    <!-- END: promotional -->
                    <!-- BEGIN: warranty -->
                    <li class="info-warranty"><strong>{LANG.detail_warranty}:</strong> {warranty}</li>
                    <!-- END: warranty -->
                </ul>
                <hr />
                <!-- BEGIN: gift -->
                <div class="alert alert-info pro-gift">
                    <div class="pull-left">
                        <em class="fa fa-gift fa-3x">&nbsp;</em>
                    </div>
                    <div class="pull-left">
                        <h4>{gift_content}</h4>
                    </div>
                    <div class="clearfix"></div>
                </div>
                <!-- END: gift -->
                <!-- BEGIN: group -->
                <div class="size-selector">
                    <!-- BEGIN: items -->
                        <!-- BEGIN: header -->
                        <div class="size-title">{HEADER}:</div>
                        <!-- END: header -->
                        <div class="size-options">
                            <!-- BEGIN: loop -->
                            <label class="size-btn <!-- BEGIN: active -->active<!-- END: active -->">
                                <!-- BEGIN: image -->
                                <img src="{GROUP.image}" alt="{GROUP.title}" style="width: 16px; height: 16px">
                                <!-- END: image -->
                                <input type="checkbox" class="hidden" name="groupid[{GROUPID}]" value="{GROUP.groupid}"
                                <!-- BEGIN: checked -->checked="checked"<!-- END: checked -->
                                onclick="check_quantity($(this))">{GROUP.title}
                            </label>
                            <!-- END: loop -->
                        </div>
                    <!-- END: items -->
                </div>
                <!-- END: group -->
                <!-- BEGIN: order_number -->
                <div class="quantity-selector">
                    <div class="quantity-title">{LANG.detail_pro_number}:</div>
                    <div class="quantity-input">
                        <button class="btn" type="button"><i class="fa fa-minus"></i></button>
                        <input type="number" name="num" value="1" min="1" max="{PRODUCT_NUMBER}" id="pnum" class="form-control">
                        <button class="btn" type="button"><i class="fa fa-plus"></i></button>
                    </div>
                    <!-- BEGIN: product_number -->
                    <div class="stock-info">{LANG.detail_pro_number}: <strong>{PRODUCT_NUMBER}</strong> {pro_unit}</div>
                    <!-- END: product_number -->
                </div>
                <!-- END: order_number -->
                <div class="clearfix"></div>
                <!-- BEGIN: typepeice -->
                <table class="table table-striped table-bordered table-hover type-peice">
                    <thead>
                        <tr>
                            <th class="text-right">{LANG.detail_pro_number}</th>
                            <th class="text-left">{LANG.cart_price} ({money_unit})</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- BEGIN: items -->
                        <tr>
                            <td class="text-right">{ITEMS.number_from} -> {ITEMS.number_to}</td>
                            <td class="text-left">{ITEMS.price}</td>
                        </tr>
                        <!-- END: items -->
                    </tbody>
                </table>
                <!-- END: typepeice -->


                <!-- BEGIN: order -->
                <div class="action-buttons">
                    <button class="btn-add-cart" data-id="{proid}" onclick="cartorder_detail(this, {POPUP}, 0); return false;">
                        <i class="fa fa-shopping-cart"></i> {LANG.add_cart}
                    </button>
                    <button class="btn-buy-now" data-id="{proid}" onclick="cartorder_detail(this, {POPUP}, 1); return false;">
                        <i class="fa fa-flash"></i> {LANG.buy_now}
                    </button>
                </div>

                <div class="product-policy">
                    <div class="policy-item">
                        <i class="fa fa-truck"></i>
                        <div class="policy-text">Giao hàng toàn quốc, thanh toán tại nhà (COD)</div>
                    </div>
                    <div class="policy-item">
                        <i class="fa fa-shield"></i>
                        <div class="policy-text">Cam kết 100% hàng chính hãng, chất lượng</div>
                    </div>
                    <div class="policy-item">
                        <i class="fa fa-exchange"></i>
                        <div class="policy-text">Đổi trả trong vòng 7 ngày nếu sản phẩm lỗi</div>
                    </div>
                    <div class="policy-item">
                        <i class="fa fa-phone"></i>
                        <div class="policy-text">Hotline hỗ trợ: {LANG.phone_number_format}</div>
                    </div>
                </div>
                <!-- END: order -->
                <!-- BEGIN: product_empty -->
                <button class="btn btn-danger btn-lg btn-block disabled">{LANG.product_empty}</button>
                <!-- END: product_empty -->
            </div>
        </div>
    </div>
    <!-- BEGIN: product_detail -->
    <!-- BEGIN: tabs -->
    <div class="panel panel-default">
        <div class="panel-body">
            <ul class="nav nav-tabs">
                <!-- BEGIN: tabs_title -->
                <li role="presentation" <!-- BEGIN: active -->class="active"<!-- END: active -->>
                    <a href="#{TABS_KEY}-{TABS_ID}" role="tab" data-toggle="tab">
                        <!-- BEGIN: icon -->
                        <img src="{TABS_ICON}" alt="{TABS_TITLE}">
                        <!-- END: icon -->
                        <!-- BEGIN: icon_default -->
                        <em class="fa fa-info-circle"></em>
                        <!-- END: icon_default -->
                        {TABS_TITLE}
                    </a>
                </li>
                <!-- END: tabs_title -->
            </ul>
            <div class="tab-content">
                <!-- BEGIN: tabs_content -->
                <div role="tabpanel" class="tab-pane fade <!-- BEGIN: active -->active in<!-- END: active -->" id="{TABS_KEY}-{TABS_ID}">
                    <div class="product-description">
                        {TABS_CONTENT}
                    </div>
                </div>
                <!-- END: tabs_content -->
            </div>
        </div>
    </div>
    <!-- END: tabs -->
    <!-- BEGIN: keywords -->
    <div class="panel panel-default panel-product-keywords">
        <div class="panel-body">
            <div class="keywords">
                <em class="fa fa-tags">&nbsp;</em><strong>{LANG.keywords}: </strong>
                <!-- BEGIN: loop -->
                <a title="{KEYWORD}" href="{LINK_KEYWORDS}" rel="dofollow"><em>{KEYWORD}</em></a>{SLASH}
                <!-- END: loop -->
            </div>
        </div>
    </div>
    <!-- END: keywords -->
    <!-- BEGIN: other -->
    <div class="panel panel-default panel-product-others">
        <div class="panel-heading"><span>{LANG.detail_others}</span></div>
        <div class="panel-body">{OTHER}</div>
    </div>
    <!-- END: other -->
    <!-- BEGIN: other_view -->
    <div class="panel panel-default panel-product-viewed">
        <div class="panel-heading"><span>{LANG.detail_others_view}</span></div>
        <div class="panel-body">{OTHER_VIEW}</div>
    </div>
    <!-- END: other_view -->
    <!-- END: product_detail -->
</div>
<div class="modal fade" id="idmodals" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                &nbsp;
            </div>
            <div class="modal-body">
                <p class="text-center">
                    <em class="fa fa-spinner fa-spin fa-3x">&nbsp;</em>
                </p>
            </div>
        </div>
    </div>
</div>
<!-- BEGIN: allowed_print_js -->
<script type="text/javascript" data-show="after">
    $(function() {
        $('#click_print').click(function(event) {
            var href = $(this).attr("href");
            event.preventDefault();
            nv_open_browse(href, '', 640, 500, 'resizable=no,scrollbars=yes,toolbar=no,location=no,status=no');
            return false;
        });
    });
</script>
<!-- END: allowed_print_js -->
<!-- BEGIN: imagemodal -->
<script type="text/javascript" data-show="after">
    $('.open_modal').click(function(e){
        e.preventDefault();
         $('#idmodals .modal-body').html( '<img src="' + $(this).data('src') + '" alt="" class="img-responsive" />' );
         $('#idmodals').modal('show');
    });
</script>
<!-- END: imagemodal -->
<!-- BEGIN: order_number_limit -->
<script type="text/javascript" data-show="after">
    $('#pnum').attr( 'max', '{PRODUCT_NUMBER}' );
    $('#pnum').change(function(){
        if( intval($(this).val()) > intval($(this).attr('max')) ){
            alert('{LANG.detail_error_number} ' + $(this).attr('max') );
            $(this).val( $(this).attr('max') );
        }
    });
</script>
<!-- END: order_number_limit -->
<script type="text/javascript">
var detail_error_group = '{LANG.detail_error_group}';
function check_quantity(_this) {
    // Xử lý chọn nhiều nhóm và cho phép không chọn nhóm nào
    // Hàm này được gọi khi checkbox thay đổi trạng thái

    // Xóa thông báo lỗi nếu có
    $('#group_error').css( 'display', 'none' );

    // Gọi hàm check_price để cập nhật giá
    // BEGIN: check_price
    check_price( '{proid}', '{pro_unit}' );
    // END: check_price

    // Resize popup nếu cần
    resize_popup();
}
$(document).ready(function() {
    // Không chọn nhóm sản phẩm nào mặc định để người dùng có thể chọn hoặc không chọn
    var itemsgroup = $('.itemsgroup');
    // Bỏ chọn tất cả các checkbox
    $('input[type="checkbox"]').prop('checked', false);
    // Bỏ active tất cả các nút
    $('.size-btn').removeClass('active active__order');

    // Xử lý sự kiện khi click vào hình ảnh thumbnail
    const thumbnails = document.querySelectorAll('.swiper-slide img');
    const mainImage = document.querySelector('.imgage__slide_first');

    thumbnails.forEach(thumb => {
        thumb.addEventListener('click', function() {
            mainImage.src = this.getAttribute('data-image');
        });
    });

    // Xử lý sự kiện khi click vào nút kích thước
    const sizeBtns = document.querySelectorAll('.size-btn');

    // Xử lý sự kiện click trực tiếp vào checkbox
    document.querySelectorAll('.size-btn input[type="checkbox"]').forEach(checkbox => {
        checkbox.addEventListener('change', function(e) {
            // Ngăn chặn sự kiện lan truyền để tránh xung đột với sự kiện click của label
            e.stopPropagation();

            const parentBtn = this.closest('.size-btn');
            const parentGroup = parentBtn.closest('.size-options');

            if (this.checked) {
                // Nếu checkbox được chọn, bỏ chọn tất cả các checkbox khác trong cùng nhóm
                parentGroup.querySelectorAll('.size-btn input[type="checkbox"]').forEach(cb => {
                    if (cb !== this && cb.checked) {
                        cb.checked = false;
                        $(cb.closest('.size-btn')).removeClass('active');
                    }
                });

                // Thêm class active cho nút chứa checkbox này
                $(parentBtn).addClass('active');
            } else {
                // Nếu checkbox bị bỏ chọn, bỏ class active của nút
                $(parentBtn).removeClass('active');
            }
        });
    });

    // Xử lý sự kiện click vào nút
    sizeBtns.forEach(btn => {
        btn.addEventListener('click', function(e) {
            // Ngăn chặn sự kiện mặc định để tránh gây xung đột
            e.preventDefault();

            const checkbox = this.querySelector('input[type="checkbox"]');
            if (!checkbox) return;

            // Đảo trạng thái checkbox
            checkbox.checked = !checkbox.checked;

            // Kích hoạt sự kiện change của checkbox
            const event = new Event('change', { bubbles: true });
            checkbox.dispatchEvent(event);
        });
    });

    // Xử lý nút tăng giảm số lượng
    const quantityBtns = document.querySelectorAll('.quantity-input .btn');
    const quantityInput = document.querySelector('.quantity-input input');

    if (quantityBtns.length && quantityInput) {
        quantityBtns.forEach(btn => {
            btn.addEventListener('click', function() {
                const currentValue = parseInt(quantityInput.value) || 1;
                const minValue = parseInt(quantityInput.getAttribute('min')) || 1;
                const maxValue = parseInt(quantityInput.getAttribute('max')) || 100;

                if (this.querySelector('.fa-minus')) {
                    // Giảm số lượng
                    if (currentValue > minValue) {
                        quantityInput.value = currentValue - 1;
                    }
                } else {
                    // Tăng số lượng
                    if (currentValue < maxValue) {
                        quantityInput.value = currentValue + 1;
                    }
                }
            });
        });

        // Kiểm tra giá trị nhập vào
        quantityInput.addEventListener('change', function() {
            const currentValue = parseInt(this.value) || 1;
            const minValue = parseInt(this.getAttribute('min')) || 1;
            const maxValue = parseInt(this.getAttribute('max')) || 100;

            if (currentValue < minValue) {
                this.value = minValue;
            } else if (currentValue > maxValue) {
                this.value = maxValue;
            }
        });
    }

    // Xử lý các nút tăng giảm số lượng khác nếu có
    const legacyMinusBtn = document.querySelector('.btn__order_minus');
    const legacyPlusBtn = document.querySelector('.btn__order_plus');
    const legacyQuantityInput = document.querySelector('.input__num_order');

    if (legacyMinusBtn && legacyPlusBtn && legacyQuantityInput) {
        legacyMinusBtn.addEventListener('click', function() {
            let value = parseInt(legacyQuantityInput.value);
            if (value > 1) {
                legacyQuantityInput.value = value - 1;
            }
        });

        legacyPlusBtn.addEventListener('click', function() {
            let value = parseInt(legacyQuantityInput.value);
            let max = parseInt(legacyQuantityInput.getAttribute('max') || 20);
            if (value < max) {
                legacyQuantityInput.value = value + 1;
            }
        });
    }

    // Xử lý thumbnail gallery
    $('.thumbnail-item').click(function() {
        $('.thumbnail-item').removeClass('active');
        $(this).addClass('active');
        const newSrc = $(this).find('img').data('src');
        $('.main-image img').attr('src', newSrc);

        // Thêm hiệu ứng zoom khi thay đổi hình ảnh
        const mainImg = $('.main-image img')[0];
        if (mainImg) {
            mainImg.classList.add('zooming');
            setTimeout(() => {
                mainImg.classList.remove('zooming');
            }, 300);
        }
    });

    // Xử lý nút tăng giảm số lượng jQuery
    // Đã được xử lý bằng JavaScript ở trên

    // Xử lý nút chọn size đã được xử lý ở trên
});
</script>
<!-- BEGIN: popup -->
<script type="text/javascript">
$(window).on('load', function() {
    setTimeout(function() {
        resize_popup();
    }, 300);
});
</script>
<!-- END: popup -->
<!-- END: main -->
