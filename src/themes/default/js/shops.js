/**
 * @Project NUKEVIET 4.x
 * @Author VINADES.,JSC (contact@vinades.vn)
 * @Copyright (C) 2017 VINADES.,JSC. All rights reserved
 * @License GNU/GPL version 2 or any later version
 * @Createdate 04/18/2017 09:47
 */

function sendrating(id, point, newscheckss) {
    if (point == 1 || point == 2 || point == 3 || point == 4 || point == 5) {
        $.post(nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=rating&nocache=' + new Date().getTime(), 'id=' + id + '&checkss=' + newscheckss + '&point=' + point, function (res) {
            $("#stringrating").html(res);
        });
    }
}

function remove_text() {
    document.getElementById('to_date').value = "";
    document.getElementById('from_date').value = "";
}

function nv_del_content(id, checkss, base_adminurl) {
    if (confirm(nv_is_del_confirm[0])) {
        $.post(base_adminurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=del_content&nocache=' + new Date().getTime(), 'id=' + id + '&checkss=' + checkss, function (res) {
            var r_split = res.split("_");
            if (r_split[0] == 'OK') {
                window.location.href = strHref;
            } else if (r_split[0] == 'ERR') {
                alert(r_split[1]);
            } else {
                alert(nv_is_del_confirm[2]);
            }
        });
    }
    return false;
}

/**
 * Nút thêm vào giỏ hàng
 * popup = 0 tức sản phẩm không phân theo nhóm
 * popup = 1 tức sản phẩm phân theo nhóm, cần mở popup để chọn nhóm
 */
function cartorder(a_ob, popup, url) {
    var id = $(a_ob).attr("id");
    if (popup == '0') {
        $.ajax({
            type: "GET",
            url: nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=setcart' + '&id=' + id + "&nocache=" + new Date().getTime(),
            data: '',
            success: function (data) {
                var s = data.split('_');
                var strText = s[1];
                if (strText != null) {
                    var intIndexOfMatch = strText.indexOf('#@#');
                    while (intIndexOfMatch != -1) {
                        strText = strText.replace('#@#', '_');
                        intIndexOfMatch = strText.indexOf('#@#');
                    }
                    alert_msg(strText);
                    $("#cart_" + nv_module_name).load(nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=loadcart');
                }
            }
        });
    } else {
        $("#sitemodal").find(".modal-content").addClass('sh-popup-modal');
        $("#sitemodal").find(".modal-title").html('');
        $("#sitemodal").find(".modal-body").html('<iframe class="popup-product-detail" src="' + url + '&amp;popup=1"></iframe>');
        $("#sitemodal").modal({
            backdrop: "static"
        });
        $('#sitemodal').on('hidden.bs.modal', function () {
            $("#sitemodal").find(".modal-content").removeClass('sh-popup-modal');
            $('#sitemodal').unbind('hidden.bs.modal');
        });
    }
}

// Nút mua ngay
function cartorder_detail(a_ob, popup, buy_now) {
    var num = $('#pnum').val();
    var id = $(a_ob).attr("data-id");
    var group = '';
    var label = '';

    var i = 0;
    $('.itemsgroup').each(function () {
        if ($('input[name="groupid[' + $(this).data('groupid') + ']"]:checked').length == 0) {
            i++;
            if (i == 1) {
                label = label + $(this).data('header');
            } else {
                label = label + ', ' + $(this).data('header');
            }
        }
    });
    if (label != '') {
        $('#group_error').css('display', 'block');
        $('#group_error').html(detail_error_group + ' <strong>' + label + '</strong>');
        resize_popup();
        return false;
    }

    i = 0;
    $('.groupid').each(function () {
        if ($(this).is(':checked')) {
            i++;
            if (i == 1) {
                group = group + $(this).val();
            } else {
                group = group + ',' + $(this).val();
            }
        }
    });

    $.ajax({
        type: "POST",
        url: nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=setcart' + '&id=' + id + "&group=" + group + "&nocache=" + new Date().getTime(),
        data: 'num=' + num,
        success: function (data) {
            var s = data.split('_');
            var strText = s[1];
            if (strText != null) {
                var intIndexOfMatch = strText.indexOf('#@#');
                while (intIndexOfMatch != -1) {
                    strText = strText.replace('#@#', '_');
                    intIndexOfMatch = strText.indexOf('#@#');
                }
                alert_msg(strText);
                $("#cart_" + nv_module_name).load(nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=loadcart');
                if (buy_now) {
                    parent.location = nv_base_siteurl + "index.php?" + nv_lang_variable + "=" + nv_lang_data + "&" + nv_name_variable + "=" + nv_module_name + "&" + nv_fc_variable + "=cart";
                } else if (popup) {
                    parent.location = parent.location;
                }
            }
        }
    });
}

function alert_msg(msg) {
    $('body').removeClass('.msgshow').append('<div class="msgshow" id="msgshow">&nbsp;</div>');
    $('#msgshow').html(msg);
    $('#msgshow').show('slide').delay(3000).hide('slow');
}

function checknum() {
    var price1 = $('#price1').val();
    var price2 = $('#price2').val();
    if (price2 == '') {
        price2 = 0;
    }
    if (price2 < price1) {
        document.getElementById('price2').value = '';
    }
    if (isNaN(price1)) {
        alert(isnumber);
        document.getElementById('submit').disabled = true;
    } else if (price2 != 0 && isNaN(price2)) {
        alert(isnumber);
        document.getElementById('submit').disabled = true;
    }
}

function cleartxtinput(id, txt_default) {
    $("#" + id).focusin(function () {
        var txt = $(this).val();
        if (txt_default == txt) {
            $(this).val('');
        }
    });
    $("#" + id).focusout(function () {
        var txt = $(this).val();
        if (txt == '') {
            $(this).val(txt_default);
        }
    });
}

function onsubmitsearch(module) {
    var keyword = $('#keyword').val();
    var price1 = $('#price1').val();
    if (price1 == null)
        price1 = '';
    var price2 = $('#price2').val();
    if (price2 == null)
        price2 = '';
    var typemoney = $('#typemoney').val();
    if (typemoney == null)
        typemoney = '';
    var catid = $('#cata').val();
    if (keyword == '' && price1 == '' && price2 == '' && catid == 0) {
        return false;
    } else {
        window.location.href = nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + module + '&' + nv_fc_variable + '=search&q=' + rawurlencode(keyword) + '&price1=' + price1 + '&price2=' + price2 + '&typemoney=' + typemoney + '&catid=' + catid;
    }
    return false;
}

function onsubmitsearch1() {
    var keyword = $('#keyword1').val();
    var price1 = $('#price11').val();
    if (price1 == null)
        price1 = '';
    var price2 = $('#price21').val();
    if (price2 == null)
        price2 = '';
    var typemoney = $('#typemoney1').val();
    if (typemoney == null)
        typemoney = '';
    var cataid = $('#cata1').val();
    if (keyword == '' && price1 == '' && price2 == '' && cataid == 0) {
        return false;
    } else {
        window.location.href = nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=search_result&keyword=' + rawurlencode(keyword) + '&price1=' + price1 + '&price2=' + price2 + '&typemoney=' + typemoney + '&cata=' + cataid;
    }
    return false;
}

function nv_chang_price() {
    var newsort = $("#sort").val();
    $.post(nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=ajax&nocache=' + new Date().getTime(), 'changesprice=1&sort=' + newsort, function (res) {
        if (res != 'OK') {
            alert(res);
        } else {
            window.location.href = window.location.href;
        }
    });
}

function nv_chang_viewtype(viewtype) {
    $.post(nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=ajax&nocache=' + new Date().getTime(), 'changeviewtype=1&viewtype=' + viewtype, function (res) {
        if (res != 'OK') {
            alert(res);
        } else {
            window.location.href = window.location.href;
        }
    });
}

function nv_compare(a) {
    nv_settimeout_disable("compare_" + a, 5E3);
    $.post(nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=compare&nocache=' + new Date().getTime(), 'compare=1&id=' + a, function (res) {
        res = res.split("[NV]");
        if (res[0] != 'OK') {
            $("#compare_" + res[2]).removeAttr("checked");
            alert(res[1]);
        }
    });
}

function nv_compare_click() {
    $.post(nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=compare&nocache=' + new Date().getTime(), 'compareresult=1', function (res) {
        if (res != 'OK') {
            alert(res);
        } else {
            window.location.href = nv_base_siteurl + "index.php?" + nv_lang_variable + "=" + nv_lang_data + "&" + nv_name_variable + "=" + nv_module_name + "&" + nv_fc_variable + "=compare";
        }
    });
    return;
}

function nv_compare_del(id, all) {
    if (confirm(lang_del_confirm)) {
        $.post(nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=compare&nocache=' + new Date().getTime(), 'compare_del=1&id=' + id + '&all=' + all, function (res) {
            if (res == 'OK') {
                window.location.href = window.location.href;
            }
        });
    }
    return;
}

function wishlist(id, object) {
    $.ajax({
        type: "GET",
        url: nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=wishlist_update' + '&id=' + id + "&ac=add&nocache=" + new Date().getTime(),
        data: '',
        success: function (data) {
            var s = data.split('_');
            if (s[0] == 'OK') {
                $(object).addClass('disabled');
                $('#wishlist_num_id').text(s[1]);
            }
            alert_msg(s[2]);
        }
    });
}

function wishlist_del_item(id) {
    if (confirm(lang_del_confirm)) {
        $.ajax({
            type: "GET",
            url: nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=wishlist_update' + '&id=' + id + "&ac=del&nocache=" + new Date().getTime(),
            data: '',
            success: function (data) {
                var s = data.split('_');
                if (s[0] == 'OK') {
                    $('#wishlist_num_id').text(s[1]);
                    $('#item_' + id).remove();
                    if (s[1] == '0') {
                        window.location.href = window.location.href;
                    }
                }
                alert_msg(s[2]);
            }
        });
    }
}

function payment_point(order_id, checkss, lang_confirm) {
    if (confirm(lang_confirm)) {
        $.ajax({
            type: "GET",
            url: nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=point' + '&paypoint=1&checkss=' + checkss + '&order_id=' + order_id + "&nocache=" + new Date().getTime(),
            data: '',
            success: function (data) {
                var s = data.split('_');
                if (s[0] == 'OK') {
                    alert(s[1]);
                    window.location.href = window.location.href;
                } else {
                    alert(s[1]);
                }
            }
        });
    }
}

function check_price(id_pro, pro_unit) {
    var data = [];
    $('.groupid:checked').each(function () {
        var value = $(this).val();
        if (value != '') {
            data.push(value);
        }
    });

    if (data.length > 0) {
        $.ajax({
            method: "POST",
            url: nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=detail&nocache=' + new Date().getTime(),
            data: 'check_quantity=1&id_pro=' + id_pro + '&pro_unit=' + pro_unit + '&listid=' + data + '&get_price=1',
            dataType: 'json',
            success: function (result) {
                console.log(result);
                if (result.status == 'OK') {
                    $('#product_number').html(result.message).removeClass('text-danger');
                    $('#pnum, .btn-order').attr('disabled', false);
                    $('#pnum').attr('max', result.quantity);

                    // Cập nhật giá từ kho
                    if (result.price) {
                        if (result.price.sale_price && parseFloat(result.price.sale_price) > 0 && parseFloat(result.price.sale_price) < parseFloat(result.price.price)) {
                            // Có giá khuyến mãi
                            $('.info-price .money').html(result.price.sale_price_format + ' ' + result.price.money_unit);
                            $('.info-price .discounts_money').html(result.price.price_format + ' ' + result.price.money_unit);
                            $('.info-price .discounts_money').show();
                        } else {
                            // Không có giá khuyến mãi
                            $('.info-price .money').html(result.price.price_format + ' ' + result.price.money_unit);
                            $('.info-price .discounts_money').hide();
                        }
                    }
                } else {
                    $('#pnum, .btn-order').attr('disabled', true);
                    $('#product_number').html(result.message).addClass('text-danger');
                }
            },
            error: function (xhr, status, error) {
                console.error("AJAX Error:", status, error);
                console.log("Response:", xhr.responseText);
            }
        });
    }
}

function fix_image_content() {
    var news = $('.tab-content'),
        newsW, w, h;
    var newsInner = $('.tab-content > .tab-pane');
    if (news.length && newsInner.length) {
        var newsW = newsInner.width();
        $.each($('img', news), function () {
            if (typeof $(this).data('width') == "undefined") {
                w = $(this).innerWidth();
                h = $(this).innerHeight();
                $(this).data('width', w);
                $(this).data('height', h);
            } else {
                w = $(this).data('width');
                h = $(this).data('height');
            }

            if (w > newsW) {
                $(this).prop('width', newsW);
                $(this).prop('height', h * newsW / w);
            }
        });
    }
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

function GetNumber(str) {
    var count = 0;
    for (var i = 0; i < str.length; i++) {
        var temp = str.substring(i, i + 1);
        if (!(temp == "," || temp == "." || (temp >= 0 && temp <= 9))) {
            alert(inputnumber);
            return str.substring(0, i);
        }
        if (temp == " ")
            return str.substring(0, i);
        if (temp == ".") {
            if (count > 0)
                return str.substring(0, i);
            count++;
        }
    }
    return str;
}

function IsNumberInt(str) {
    for (var i = 0; i < str.length; i++) {
        var temp = str.substring(i, i + 1);
        if (!(temp == "." || (temp >= 0 && temp <= 9))) {
            alert(inputnumber);
            return str.substring(0, i);
        }
        if (temp == ",") {
            return str.substring(0, i);
        }
    }
    return str;
}

function resize_popup() {
    if ($('.prodetail-popup').length) {
        var popheight = $('.prodetail-popup > .panel').height();
        $('html,body').css({
            overflow: 'hidden',
            'background-color': 'transparent'
        });
        $('.popup-product-detail', window.parent.document).height(popheight);
    }
}

$(window).on('load', function () {
    fix_image_content();
});

$(window).on("resize", function () {
    fix_image_content();
});

$(document).ready(function () {
    $('[data-toggle="checkorder"]').click(function (e) {
        e.preventDefault();
        var $this = $(this);
        var $icon = $this.find('.fa');
        if ($icon.hasClass('fa-spin')) {
            return false;
        }
        $icon.addClass('fa-spin');
        $.post(
            nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=checkorder&nocache=' + new Date().getTime(),
            'id=' + $this.data('id') + '&checkss=' + $this.data('checksess'),
            function (res) {
                if (res.status == 'CHANGED') {
                    if (confirm(res.message)) {
                        window.location.href = res.link;
                    } else {
                        window.location.href = window.location.href.replace(/#(.*)/, "");
                    }
                } else {
                    alert(res.message);
                    $icon.removeClass('fa-spin');
                }
            }
        );
    });

    // Chọn ngay nhóm sản phẩm đầu tiên nếu có 1 nhóm mỗi loại
    var itemsgroup = $('.itemsgroup');
    itemsgroup.each(function () {
        var item = $(this);
        var radio = $('[type="radio"]', item);
        if (radio.length == 1) {
            radio.trigger('click');
        }
    });

    // Tự động tìm và chọn thuộc tính có trong kho
    autoSelectAvailableAttributes();
});

// Hàm tự động tìm và chọn thuộc tính có trong kho
function autoSelectAvailableAttributes() {
    // Lấy ID sản phẩm và đơn vị
    var id_pro = $('[name="proid"]').val();
    var pro_unit = $('[name="pro_unit"]').val();

    if (!id_pro || !pro_unit) {
        return;
    }

    // Lấy danh sách tất cả các nhóm thuộc tính
    var groups = {};
    $('.itemsgroup').each(function () {
        var groupId = $(this).data('groupid');
        var radios = $('input[type="radio"]', this);
        groups[groupId] = radios;
    });

    // Nếu không có nhóm thuộc tính, thoát
    if (Object.keys(groups).length === 0) {
        return;
    }

    // Gửi AJAX để lấy thuộc tính có sẵn trong kho
    $.ajax({
        method: "POST",
        url: nv_base_siteurl + 'index.php?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=detail&nocache=' + new Date().getTime(),
        data: 'get_available_attributes=1&id_pro=' + id_pro,
        dataType: 'json',
        success: function (result) {
            if (result.status == 'OK' && result.data && result.data.length > 0) {
                // Nếu có thuộc tính có sẵn, chọn chúng
                var attributes = result.data;

                // Chọn thuộc tính đầu tiên có sẵn
                var firstAttribute = attributes[0];
                var attributeIds = firstAttribute.attribute_ids.split(',');

                // Chọn từng thuộc tính
                attributeIds.forEach(function (attrId) {
                    $('input[type="radio"][value="' + attrId + '"]').prop('checked', true).parent().css('border-color', 'blue');
                });

                // Cập nhật giá trực tiếp từ dữ liệu đã có
                updatePriceDirectly(firstAttribute);

                // Cập nhật số lượng
                if (firstAttribute.quantity) {
                    $('#product_number').html($('#product_number').text().split(':')[0] + ': ' + firstAttribute.quantity + ' ' + pro_unit).removeClass('text-danger');
                    $('#pnum').attr('max', firstAttribute.quantity).attr('disabled', false);
                    $('.btn-order').attr('disabled', false);
                }
            } else {
                // Nếu không có thuộc tính nào, gọi check_price để lấy giá mặc định
                check_price(id_pro, pro_unit);
            }
        }
    });
}

// Hàm cập nhật giá trực tiếp từ dữ liệu
function updatePriceDirectly(attribute) {
    if (!attribute) return;

    if (attribute.sale_price && parseFloat(attribute.sale_price) > 0 && parseFloat(attribute.sale_price) < parseFloat(attribute.price)) {
        // Có giá khuyến mãi
        $('.info-price .money').html(attribute.sale_price_format + ' ' + attribute.money_unit);
        $('.info-price .discounts_money').html(attribute.price_format + ' ' + attribute.money_unit);
        $('.info-price .discounts_money').show();
    } else {
        // Không có giá khuyến mãi
        $('.info-price .money').html(attribute.price_format + ' ' + attribute.money_unit);
        $('.info-price .discounts_money').hide();
    }
}
