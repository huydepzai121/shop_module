<!-- BEGIN: main -->
<div id="popup_not_dismiss" class="modal fade auto-height" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-body"></div>
        </div>
    </div>
</div>
<div class="msgshow" id="msgshow"></div>
<!-- BEGIN: popup_login -->
    {POPUP_LOGIN}
<!-- END: popup_login -->

<!-- BEGIN: popup_not_point -->
<script>
$(function() {
    var mess = '{LANG.info_point_not_enought}';
    mess += '<p class="text-center"><a class="btn btn-danger" href="https://id.dauthau.net/{NV_LANG_DATA}/points/#muadiem" target="_blank">{LANG.buy_points}</a></p>';

    $("#popup_not_dismiss").find(".modal-body").html(mess);
    $("#popup_not_dismiss").modal({
        backdrop: "static",
        keyboard: false
    });
});
</script>
<!-- END: popup_not_point -->
<!-- BEGIN: msgshow -->
<script>
alert_msg('{LANG.message_point_view_suss}');
</script>
<!-- END: msgshow -->

<!-- BEGIN: online -->
<!-- BEGIN: recaptcha -->
<div id="captchaModal" class="modal fade auto-width auto-height" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <p class="modal-title">{LANG.recapcha_title}</p>
            </div>
            <div class="modal-body">
                <div>{LANG.recapcha_body}</div>
                <div data-toggle="recaptcha" data-callback="verify_captcha" id="{RECAPTCHA_ELEMENT}"></div>
            </div>
        </div>
    </div>
</div>
<script>
function verify_captcha(e) {
    click_update();
}
</script>
<!-- END: recaptcha -->
<div class="bidding-detail-wrapper bidding-detail-wrapper-result">
    <div class="bidding-title">
        <h1 class="tl wrap__text bidding-name">{DATA.title}</h1>
    </div>
    <div class="margin-bottom">
        <div class="prb_container">
            <div class="prb clearfix">
                <!-- BEGIN: mess_item -->
                <span class="prb-progressbar">{MESS}</span>
                <!-- END: mess_item -->
            </div>
            <div class="prb clearfix">
                <!-- BEGIN: prb_item -->
                <!-- BEGIN: if_a -->
                <a class="item" href="{PROCESS.url}"><span class="icn {PROCESS.classes}" title="{PROCESS.title}"></span><span class="tl">{PROCESS.title}</span></a>
                <!-- END: if_a -->
                <!-- BEGIN: if_span -->
                <span class="item"><span class="icn {PROCESS.classes}" title="{PROCESS.title}"></span><span class="tl">{PROCESS.title}</span></span>
                <!-- END: if_span -->
                <!-- END: prb_item -->
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-xs-24 btn-share-group">
            <span>{LANG.share} </span>
            <a href="javascript:void(0)" class="btn-share" rel="nofollow" onclick="nv_fb_share();" title="{LANG.fb_share}">
                <span class="icon-facebook"></span>
            </a>
            <a href="javascript:void(0)" class="btn-share" rel="nofollow" onclick="nv_tw_share('', '{DATA.title}');" title="{LANG.tweet}">
                <span class="icon-twitter"></span>
            </a>
            <a href="javascript:void(0)" class="btn-share btn-copy-link" title="{LANG.copy_link}">
                <em class="fa fa-link"></em>
                <span class="tip" style="display: none;">{LANG.link_copy_successfully}</span>
            </a>
        </div>
    </div>

    <div class="bidding-page-btn">
        <!-- BEGIN: link_msc -->
        <a href="{LINK_MSC}"> <button class="btn btn-primary{BLUR_CLASS}">
            {LANG.icon_vneps}
            Link MSC</button></a>
        <!-- END: link_msc -->
        <div class="text-right m-bottom">
            <!-- BEGIN: update -->
            <div class="small">
                {LANG.crawl_time}: <strong>{DATA.fget_time}</strong>
            </div>
            <div class="margin-top-sm m-bottom">
                <span class="small">{DATA.update_info}</span> <a style="margin-left: auto" id="reupdate" class="btn btn-default btn-xs active" onclick="show_captcha()" href="javascript:void(0)" data-id="{DATA.id}" data-check="{CHECKSESS_UPDATE}">{LANG.reupdate}</a><img id="update_wait" style="display: none" src="{NV_BASE_SITEURL}{NV_ASSETS_DIR}/images/load_bar.gif" /><span id="show_error" class="text-danger margin-left" style="display: none"></span>
                <!-- BEGIN: crawl_request_history_button -->
                <a style="margin-left: auto" id="crawl_request_history" class="btn btn-default btn-xs active" href="javascript:void(0)">{LANG.crawl_request_history}</a>
                <!-- END: crawl_request_history_button -->
            </div>
            {FILE "crawl_request_history_list.tpl"}
            <!-- END: update -->
            {FILE "button_show_log.tpl"}
        </div>
    </div>

    <!-- BEGIN: show_waring_kqlcnt -->
    <div class="alert alert-warning">
        <p><i class="fa fa-exclamation-triangle" aria-hidden="true"></i> {LINK_WARNING_KQLCNT}</p>
    </div>
    <!-- END: show_waring_kqlcnt -->

    <div class="bidding-detail">
        <!-- BEGIN: show_huythau -->
            <p class="alert alert-warning"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i> {LANG.title_cancel_msc} <strong>{DATA.time_cancel}</strong></p>
        <!-- END: show_huythau -->

        <div class="bidding-detail-item col-four">
            <div>
                <div class="c-tit">{LANG.so_tbmt}</div>
                <div class="c-val">
                    <a href="{DATA.link_tbmt}">{DATA.code}</a>
                </div>
            </div>
            <!-- BEGIN: type_bid -->
            <div>
                <div class="c-tit">{LANG.type_bid}</div>
                <div class="c-val">{DATA.type_bid}</div>
            </div>
            <!-- END: type_bid -->
        </div>
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.totalview}</div>
            <div class="c-val title-strong">{DATA.totalview}</div>
        </div>
        <!-- BEGIN: plan_code -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.so_khlcnt}</div>
            <div class="c-val">
                <a href="{DATA.link_plan}">{DATA.plan_code}</a>
            </div>
        </div>
        <!-- END: plan_code -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.goi_thau}</div>
            <div class="c-val">{DATA.title}</div>
        </div>

        <!-- BEGIN: project_name -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.ten_du_an}</div>
            <div class="c-val">{DATA.project_name}</div>
        </div>
        <!-- END: project_name -->

        <!-- BEGIN: ben_moi_thau -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.ben_moi_thau}</div>
            <div class="c-val title-strong">
                <!-- BEGIN: if_link -->
                <a href="{DATA.link_solicitor}" title="{DATA.solicitor_title}">{DATA.solicitor_title}</a>
                <!-- END: if_link -->
                <!-- BEGIN: if_unlink -->
                    <a href="{DATA.link_solicitor_unlink}">{DATA.solicitor_title}</a>
                <!-- END: if_unlink -->
                <!-- BEGIN: if_no_link -->
                {DATA.solicitor_title}
                <!-- END: if_no_link -->
            </div>
        </div>
        <!-- END: ben_moi_thau -->
        <!-- BEGIN: investor -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.chu_dau_tu}</div>
            <div class="c-val title-strong">
                <!-- BEGIN: if_link -->
                <a href="{DATA.link_investor}" title="{DATA.investor}">{DATA.investor}</a>
                <!-- END: if_link -->
                <!-- BEGIN: if_no_link -->
                {DATA.investor}
                <!-- END: if_no_link -->
            </div>
        </div>
        <!-- END: investor -->

        <!-- BEGIN: type0 -->
        <div class="bidding-detail-item col-four">
            <div>
                <div class="c-tit">{LANG.cat}</div>
                <div class="c-val"><span class="online-code">{DATA.cat}</span></div>
            </div>
            <!-- BEGIN: time_post -->
            <div>
                <div class="c-tit">{LANG.time_post}</div>
                <div class="c-val red">{DATA.post_time}</div>
            </div>
            <!-- END: time_post -->
        </div>

        <div class="bidding-detail-item col-four">
            <div>
                <div class="c-tit">{LANG.price_contract}</div>
                <div class="c-val">{DATA.bid_price}</div>
            </div>

            <!-- BEGIN: show_price_estimate -->
            <div>
                <div class="c-tit">{LANG.price_estimate}</div>
                <div class="c-val">{DATA.price_estimate}</div>
            </div>
            <!-- END: show_price_estimate -->
        </div>

        <!-- BEGIN: finish_time -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.finish_time}</div>
            <div class="c-val red">{DATA.finish_time}</div>
        </div>
        <!-- END: finish_time -->

        <!-- BEGIN: show_data_msc_new -->
            <div class="bidding-detail-item col-four">
                <div>
                    <div class="c-tit">{LANG.bidder_name}</div>
                    <div class="c-val">{DATA.bidder_vip}{DATA.bidder_name_link}</div>
                </div>
                <div>
                    <div class="c-tit">{LANG.so_dkkd}</div>
                    <div class="c-val">{DATA.no_business_licence}</div>
                </div>
            </div>


            <div class="bidding-detail-item col-four">
                <div>
                    <div class="c-tit">{LANG.tender_price_discount}</div>
                    <div class="c-val">{DATA.tender_price_discount}</div>
                </div>
                <div>
                    <div class="c-tit">{LANG.win_price}</div>
                    <div class="c-val">{DATA.win_price}</div>
                </div>
            </div>
        <!-- END: show_data_msc_new -->

        <div class="bidding-detail-item col-four">
            <!-- BEGIN: tender_price -->
            <div>
                <div class="c-tit">{LANG.tender_price}</div>
                <div class="c-val">{DATA.tender_price}</div>
            </div>
            <!-- END: tender_price -->

            <!-- BEGIN: tender_price_discount_percent -->
            <div>
                <div class="c-tit">{LANG.tender_price_discount_percent}</div>
                <div class="c-val">{DATA.tender_price_discount_percent}</div>
            </div>
            <!-- END: tender_price_discount_percent -->
        </div>

        <!-- BEGIN: show_point -->
        <div class="bidding-detail-item col-four">
            <div>
                <div class="c-tit">{LANG.point}</div>
                <div class="c-val">{DATA.point}</div>
            </div>
            <div>
                <div class="c-tit">{LANG.evaluating_price}</div>
                <div class="c-val">{DATA.evaluating_price}</div>
            </div>
        </div>
        <!-- END: show_point -->

        <!-- BEGIN: ctype -->
        <div class="bidding-detail-item col-four">
            <div>
                <div class="c-tit">{LANG.type_contract_title}</div>
                <div class="c-val">{DATA.ctype}</div>
            </div>
        </div>
        <!-- END: ctype -->

        <!-- BEGIN: ho_so_msc_cu -->
        <div class="bidding-detail-item wrap__text">
            <div class="c-tit">{LANG.result_attach}</div>
            <div class="c-val download__file">
                <div class="tab-content download">
                    <div class="tab-pane fade active in">
                        <div class="list-group-item display-flex">
                            <a href="{LINK}" class="disable-link" target="_blank" rel="noopener noreferrer nofollow"><span class="">{DATA.document_approval_name}</span></a>
                            <div class="text-nowrap" style="margin-left:auto">
                                <a class="btn btn-primary btn-xs" href="{LINK}" target="_blank" rel="noopener noreferrer nofollow"><em class="fa fa-snowflake-o"></em> {LANG.download_title}</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- END: ho_so_msc_cu -->
        <!-- END: type0 -->
        <!-- BEGIN: type1 -->
        <div class="bidding-detail-item col-four">
            <div>
                <div class="c-tit">{LANG.loai_thong_bao}</div>
                <div class="c-val">{DATA.loai_thong_bao}</div>
            </div>
            <div>
                <div class="c-tit">{LANG.loai_du_an}</div>
                <div class="c-val">{DATA.loai_du_an}</div>
            </div>
        </div>
        <div class="bidding-detail-item col-four">
            <div>
                <div class="c-tit">{LANG.gia_du_an}</div>
                <div class="c-val">{DATA.total_cost}</div>
            </div>
            <div>
                <div class="c-tit">{LANG.dd_th}</div>
                <div class="c-val">{DATA.dia_diem}</div>
            </div>
        </div>
        <div class="bidding-detail-item col-four">
            <div>
                <div class="c-tit">{LANG.loai_hd}</div>
                <div class="c-val">{DATA.loai_hd}</div>
            </div>
            <div>
                <div class="c-tit">{LANG.ngay_dang_tai}</div>
                <div class="c-val red">{DATA.post_time}</div>
            </div>
        </div>
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.win_bidder}</div>
            <div class="c-val">{DATA.bidder_vip}{DATA.bidder_name_link}</div>
        </div>

        <!-- BEGIN: ineligiblerson -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.title_ineligiblerson}</div>
            <div class="c-val"><span class="text-danger">{DATA.ineligiblerson}</span></div>
        </div>
        <!-- END: ineligiblerson -->

        <!-- BEGIN: succbidderrson -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.reason_choose}</div>
            <div class="c-val"><span class="text-danger">{DATA.succbidderrson}</span></div>
        </div>
        <!-- END: succbidderrson -->

        <!-- BEGIN: plan_negotiating -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.plan_negotiating}</div>
            <div class="c-val">{DATA.plan_negotiating}</div>
        </div>
        <!-- END: plan_negotiating -->

        <!-- BEGIN: compensation_value -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.compensation}</div>
            <div class="c-val">{DATA.compensation_value}</div>
        </div>
        <!-- END: compensation_value -->

        <!-- BEGIN: state_budget -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.state_budget}</div>
            <div class="c-val">{DATA.state_budget}</div>
        </div>
        <!-- END: state_budget -->

        <!-- BEGIN: progres_project -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.progress_project}</div>
            <div class="c-val">{DATA.progres_project}</div>
        </div>
        <!-- END: progres_project -->

        <!-- BEGIN: other_info -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.noi_dung_khac}</div>
            <div class="c-val"><span class="text-danger">{DATA.other_info}</span></div>
        </div>
        <!-- END: other_info -->

        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.muc_tieu_da}</div>
            <div class="c-val">{DATA.muc_tieu}</div>
        </div>

        <!-- BEGIN: quy_mo -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.quy_mo_msc_new}</div>
            <div class="c-val">{DATA.quy_mo}</div>
        </div>
        <!-- END: quy_mo -->

        <!-- BEGIN: ground_area -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.ground_area}</div>
            <div class="c-val">{DATA.ground_area}</div>
        </div>
        <!-- END: ground_area -->

        <!-- BEGIN: use_period -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.use_period}</div>
            <div class="c-val">{DATA.use_period}</div>
        </div>
        <!-- END: use_period -->

        <!-- BEGIN: purpose -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.purpose}</div>
            <div class="c-val">{DATA.purpose}</div>
        </div>
        <!-- END: purpose -->

        <!-- BEGIN: dieu_kien -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.dieu_kien}</div>
            <div class="c-val">{DATA.dieu_kien}</div>
        </div>
        <!-- END: dieu_kien -->

        <!-- BEGIN: noi_dung_khac -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.noi_dung_khac}</div>
            <div class="c-val">{DATA.noidung_khac}</div>
        </div>
        <!-- END: noi_dung_khac -->

        <!-- BEGIN: von_nha_nuoc -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.von_nha_nuoc}</div>
            <div class="c-val">{DATA.von_nha_nuoc}</div>
        </div>
        <!-- END: von_nha_nuoc -->
        <!-- BEGIN: document_approval -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.document_approval}</div>
            <div class="c-val">
                {DATA.document_approval}
            </div>
        </div>
        <!-- END: document_approval -->
        <!-- BEGIN: dinhkem -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.qdkqdt}</div>
            <div class="c-val">
                <a href="{DATA.link_dinh_kem}"><i class="fa fa-download" aria-hidden="true"></i> {DATA.title_dinhkem}</a>
            </div>
        </div>
        <!-- END: dinhkem -->
        <!-- END: type1 -->

        <!-- BEGIN: show_time_todo -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.thoi_gian_hd}</div>
            <div class="c-val">{DATA.time_todo}</div>
        </div>
        <!-- END: show_time_todo -->

        <!-- BEGIN: document_test -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.document_test}</div>
            <div class="c-val">{DATA.document_test}</div>
        </div>
        <!-- END: document_test -->
        <!-- BEGIN: report_result -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.report_result}</div>
            <div class="c-val">{DATA.report_result}</div>
        </div>
        <!-- END: report_result -->

        <!-- BEGIN: show_new_msc -->
            <div class="bidding-detail-item">
                <div class="c-tit">{LANG.is_domestic}</div>
                <div class="c-val">{DATA.name_domestic}</div>
            </div>

            <div class="bidding-detail-item">
                <div class="c-tit">{LANG.method_bidder}</div>
                <div class="c-val">{DATA.pt_lcnt}</div>
            </div>

            <div class="bidding-detail-item{DATA.class_hidden}">
                <div class="c-tit">{LANG.phan_muc}</div>
                <div class="c-val">
                    {DATA.bidfieid}
                </div>
            </div>
            <div class="bidding-detail-item">
                <div class="c-tit">{LANG.so_qdpd}</div>
                <div class="c-val">{DATA.number_document1}</div>
            </div>
            <!-- BEGIN: quyet_dinh_phe_duyet_type1 -->
            <div class="bidding-detail-item flex-direction-column">
                <div class="c-tit">{LANG.quyet_dinh_phe_duyet}</div>
                <div class="c-val">
                    <div class="tab-content download {ICON_PLANE}">
                        <div class="tab-pane fade{HOME_ACTIVE} in" id="ho_so_nav_first" role="tabpanel" aria-labelledby="ho_so_nav_first_tab">
                            <div class="list-group download-link{IS_OTHER_BROWSER}">
                                {download_file_content}
                            </div>
                        </div>
                        <div id="myDiv" class="tab-pane fade{POINT_ACTIVE} in list-group download-link is_points{IS_OTHER_BROWSER}" id="ho_so_nav_second" role="tabpanel" aria-labelledby="ho_so_nav_second_tab">
                            {bao_cao}
                        </div>
                    </div>
                    <!-- BEGIN: if_ie_down -->
                    <small><i class="fa fa-paper-plane-o"></i> {note_ie_down}</small>
                    <!-- END: if_ie_down -->
                </div>
            </div>
            <!-- END: quyet_dinh_phe_duyet_type1 -->

            <!-- BEGIN: quyet_dinh_phe_duyet -->
            <div class="bidding-detail-item flex-direction-column">
                <div class="c-tit">{LANG.quyet_dinh_phe_duyet}</div>
                <div class="c-val">
                    <p id="tai_ho_so">{DOWNLOAD_MESS}</p>
                    <!-- BEGIN: point_or_t0 -->
                    <div class="container-download">
                        <div class="column-download">
                            <div class="button-container">
                                <div class="center-buttons">
                                    <button class="btn btn-primary" onclick="buy_fastlink(this)" data-id="{id}" data-confirm="{LANG_FILE.down_point_confirm}">{LANG.link_file_fast}</button>
                                </div>
                                <p>{info_T0}</p>
                            </div>
                        </div>
                        <div class="column-download">
                            <div class="button-container">
                                <div class="center-buttons">
                                    <button class="btn btn-primary" onclick="redirect_link('{link_T0}')">{LANG.buy_TO}</button>
                                </div>
                                <p>{LANG.show_info_down_t0_2227}</p>
                            </div>
                        </div>
                    </div>
                    <!-- END: point_or_t0 -->
                    <!-- BEGIN: vip_size_info -->
                    <p>
                        <em class="fa fa-bell"></em> {VIPSIZE_MESS}
                    </p>
                    <!-- END: vip_size_info -->
                    <div class="tab-content download {ICON_PLANE}">
                        <div class="tab-pane fade{HOME_ACTIVE} in" id="ho_so_nav_first" role="tabpanel" aria-labelledby="ho_so_nav_first_tab">
                            <div class="list-group download-link{IS_OTHER_BROWSER}">
                                {download_file_content}
                            </div>
                        </div>
                        <div id="myDiv" class="tab-pane fade{POINT_ACTIVE} in list-group download-link is_points{IS_OTHER_BROWSER}" id="ho_so_nav_second" role="tabpanel" aria-labelledby="ho_so_nav_second_tab">
                            {bao_cao}
                        </div>
                    </div>
                    <!-- BEGIN: if_ie_down -->
                    <small><i class="fa fa-paper-plane-o"></i> {note_ie_down}</small>
                    <br>
                    <small><i class="fa fa-exclamation-circle"></i> {LANG.note_ehsmt} </small>
                    <!-- END: if_ie_down -->
                </div>
            </div>
            <!-- END: quyet_dinh_phe_duyet -->
            <div class="bidding-detail-item">
                <div class="c-tit">{LANG.approval_org}</div>
                <div class="c-val">{DATA.decision_agency}</div>
            </div>

            <div class="bidding-detail-item">
                <div class="c-tit">{LANG.ngay_phe_duyet}</div>
                <div class="c-val">{DATA.date_approval}</div>
            </div>
        <!-- END: show_new_msc -->

        <!-- BEGIN: report_filename -->
        <div class="bidding-detail-item wrap__text">
            <div class="c-tit">{LANG.bcdghsdt}</div>
            <div class="c-val download__file">
                <a href="{LINK}"><i class="fa fa-cloud-download" aria-hidden="true"></i> {DATA.report_filename}</a>
            </div>
        </div>
        <!-- END: report_filename -->

        <!-- BEGIN: bidder_name_tt -->
            <div class="bidding-detail-item">
                <div class="c-tit">{LANG.kq_lcnt}</div>
                <div class="c-val">{TRUNGTHAU}</div>
            </div>
        <!-- END: bidder_name_tt -->

        <!-- BEGIN: link_khlcnt -->
            <div class="bidding-detail-item{DATA.class_hidden}">
                <div class="c-tit">{LANG.plan_tl}</div>
                <div class="c-val">{CONNECTIVE}</div>
            </div>
        <!-- END: link_khlcnt -->

        <!-- BEGIN: reason -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.reason_choose}</div>
            <div class="c-val"><p class="text-danger">{DATA.reason}</p></div>
        </div>
        <!-- END: reason -->
    </div>
</div>

<!-- BEGIN: show_business_kqlcndt -->
<div class="table-responsive bidding_table">
    <h2 class="mb-2 text-uppercase">{LANG.list_business_ndt}</h2>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>{LANG.number}</th>
                <th class="w100">{LANG.madinhdanh}</th>
                <th>{LANG.name_investor}</th>
                <th>{LANG.joint_venture_ndt}</th>
                <th>{LANG.link_follow_result}</th>
                <th>{LANG.ly_do}</th>
            </tr>
        </thead>
        <tbody id="list_business">
            <!-- BEGIN: loop -->
                <tr class="{ROW.class}">
                    <td class="text-center td__merge">{ROW.stt}</td>
                    <td class="text-center">{ROW.orgcode}</td>
                    <td class="text-center">{ROW.bidder_name}</td>
                    <td class="td__merge">{ROW.joint_venture}</td>
                    <td class="text-center td__merge">{ROW.result_status}</td>
                    <td class="text-center td__merge w200">{ROW.reason}</td>
                </tr>
            <!-- END: loop -->
        </tbody>
    </table>
</div>
<script type="text/javascript">
    $(document).ready(function($) {
        tr = $("#list_business .rowspan");
        for (i=0; i < tr.length; i++) {
            if (i > 0) {
                tr.eq(i).find('.td__merge').remove();
            } else {
                tr.eq(i).find('.td__merge').attr('rowspan', tr.length);
            }
        }
    });
</script>
<!-- END: show_business_kqlcndt -->

<!-- BEGIN: show_kqth -->
<div class="table-responsive bidding_table">
    <!-- BEGIN: list_business_online_old -->
        <h2 class="mb-2 text-uppercase">{LANG.list_solicitor_win}</h2>
        <table class="table table-bordered table-hover">
            <thead>
                <tr>
                    <th>{LANG.number}</th>
                    <th class="w100">{SODDKD}</th>
                    <th class="w150">{LANG.joint_venture}</th>
                    <th>{LANG.bidder_name}</th>
                    <th class="w150">{LANG.tender_price}</th>
                    <th class="w100">{LANG.point}</th>
                    <th class="w100">{LANG.win_price_number}</th>
                    <th class="w100">{TG_TRUNGTHAU}</th>
                </tr>
            </thead>
            <tbody>
                <!-- BEGIN: loop -->
                    <tr>
                        <td class="text-center">{ROW.stt}</td>
                        <td class="text-center">{ROW.no_business_licence}</td>
                        <td class="td__merge">
                            {ROW.tenliendanh}
                        </td>
                        <td class="text-center"><h3><a href="{ROW.link}" style="color: {ROW.color}">{ROW.show_vip}{ROW.bidder_name}</a></h3></td>
                        <td class="text-center td__merge">{DATA.tender_price}</td>
                        <td class="text-center td__merge">{DATA.point}</td>
                        <td class="text-center td__merge">{DATA.win_price_number}</td>
                        <td class="text-center td__merge">{ROW.cperiod}</td>
                    </tr>
                <!-- END: loop -->

                <!-- BEGIN: corrections -->
                    <tr>
                        <td colspan="8">
                            <h3 class="text-uppercase"><b></b>Thông tin đính chính: </h3>
                        </td>
                    </tr>
                    <!-- BEGIN: loop -->
                        <tr>
                            <td colspan="3">
                                {LANG.corrections_stt}
                            </td>
                            <td colspan="5">
                                <span>{ROW.corNum}</span>
                            </td>
                        </tr>

                        <tr>
                            <td colspan="3">
                               {LANG.order_log_time}
                            </td>
                            <td colspan="5">
                                <span>{ROW.updateDt}</span>
                            </td>
                        </tr>

                        <tr>
                            <td colspan="3">
                                {LANG.win_price_number}
                            </td>
                            <td colspan="5">
                                <span>{ROW.bidAwardPrice}</span>
                            </td>
                        </tr>

                        <tr>
                            <td colspan="3">
                                {LANG.content_detail}
                            </td>
                            <td colspan="5">
                                <span class="text-danger">{ROW.corDetail}</span>
                            </td>
                        </tr>

                        <tr>
                            <td colspan="3">
                                {LANG.document_kt}
                            </td>
                            <td colspan="5">
                                <a href="https://muasamcong.mpi.gov.vn/edoc-oldproxy-service/api/download/file/browser?filePath=/WAS/{ROW.filePath}" rel="nofollow"><i class="fa fa-download" aria-hidden="true"></i> {LANG.download_document}</a>
                            </td>
                        </tr>
                    <!-- END: loop -->

                <!-- END: corrections -->

                <!-- BEGIN: business_online_old -->
                    <tr>
                        <td class="text-center">1</td>
                        <td class="text-center">{DATA.no_business_licence}</td>
                        <td class="td__merge">
                            {BIDDER_NAME}
                        </td>
                        <td class="text-center"><a href="{ROW.link}" style="color: {ROW.color}">{ROW.show_vip}{ROW.bidder_name}</a></td>
                        <td class="text-center td__merge">{DATA.tender_price}</td>
                        <td class="text-center td__merge">{DATA.point}</td>
                        <td class="text-center td__merge">{DATA.win_price}</td>
                        <td class="text-center td__merge">{DATA.time_todo}</td>
                    </tr>
                <!-- END: business_online_old -->
            </tbody>
        </table>
        <!-- BEGIN: show_list_business -->
        <strong>{LANG.list_liendanh}</strong>
        <div class="table-responsive">
            <table class="bidding-table">
                <thead>
                    <tr>
                        <th class="text-center">#</th>
                        <th>{LANG.bidder_name}</th>
                        <th>{LANG.partnership}</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- BEGIN: loop_list_business -->
                    <tr>
                        <td class="text-center" data-column="#">{VALUE.stt}</td>
                        <td><a href="{VALUE.link}" data-column="{LANG.bidder_name}" style="color: {VALUE.color}">{VALUE.show_vip}{VALUE.bidder_name}</a></td>
                        <td data-column="{LANG.partnership}">{VALUE.title_partnership}</td>
                    </tr>
                    <!-- END: loop_list_business -->
                </tbody>
            </table>
        </div>
        <!-- END: show_list_business -->
    <!-- END: list_business_online_old -->

    <!-- BEGIN: list_business_online -->
    <h2 class="mb-2 text-uppercase">{LANG.list_solicitor_win}</h2>
    <table class="table table-bordered table-hover">
        <thead>
            <tr>
                <th>{LANG.number}</th>
                <th class="w100">{SODDKD}</th>
                <th class="w150">{LANG.joint_venture}</th>
                <th>{LANG.bidder_name}</th>
                <th class="w150">{LANG.tender_price}</th>
                <th class="w100">{LANG.point}</th>
                <th class="w100">{LANG.win_price_number}</th>
                <th class="w100">{TG_TRUNGTHAU}</th>
                <th class="w100">{LANG.contract_sign_date}</th>
            </tr>
        </thead>
        <tbody id="list_business_online">
            <!-- BEGIN: loop -->
                <tr>
                    <td class="text-center">{ROW.stt}</td>
                    <td class="text-center">{ROW.no_business_licence}</td>
                    <td class="td__merge">
                        {ROW.tenliendanh}
                    </td>
                    <td class="text-center"><h3><a href="{ROW.link}" style="color: {ROW.color}">{ROW.show_vip}{ROW.bidder_name}</a></h3></td>
                    <td class="text-center td__merge">{DATA.tender_price}</td>
                    <td class="text-center td__merge">{DATA.point}</td>
                    <td class="text-center td__merge">{ROW.bidwinningprice}</td>
                    <td class="text-center td__merge">{ROW.cperiod}</td>
                    <td class="text-center td__merge">{ROW.contract_sign_date}</td>
                </tr>
            <!-- END: loop -->
        </tbody>
    </table>
    <!-- END: list_business_online -->

    <!-- BEGIN: show_nt_success -->
    <h2 class="mb-2 text-uppercase">{LANG.list_solicitor_win}</h2>
    <table class="bidding-table" id="table_one">
        <thead>
            <tr>
                <th>{LANG.number}</th>
                <th class="w100">{SODDKD}</th>
                <th>{LANG.bidder_name}</th>
                <th class="w100">{LANG.win_price}</th>
                <th class="w100">{LANG.sum_price_sub}</th>
                <th class="w100">{LANG.num_win}</th>
                <th>{LANG.action_title}</th>
            </tr>
        </thead>
        <tbody>
            <!-- BEGIN: loop -->
                <tr>
                    <td class="text-center" data-column="{LANG.number}">{ROW.stt}</td>
                    <td class="text-center" data-column="{SODDKD}">{ROW.orgcode}</td>
                    <td><a href="{ROW.link}" data-column="{LANG.bidder_name}">{ROW.show_vip}{ROW.bid_title}</a></td>
                    <td data-column="{LANG.win_price}">{ROW.total_price_lotprice}</td>
                    <td data-column="{LANG.sum_price_sub}">{ROW.total_price}</td>
                    <td class="text-center" data-column="{LANG.num_win}">{ROW.num_goods}</td>
                    <td class="text-center" data-column="{LANG.action_title}">
                        <a href="javascript:void(0)" class="view__goods" data-toggle="modal" data-target="#show_goods_subdivision" data-name='{ROW.bid_title}'>{LANG.viewdetail} <i class="fa fa-eye" aria-hidden="true"></i></a>
                        <span class="data-sub hidden">{ROW.list}</span>
                    </td>
                </tr>
            <!-- END: loop -->
        </tbody>
        <tfoot>
            <tr>
                <td colspan="2"></td>
                <td>{STATIC.tong}</td>
                <td data-column="{LANG.win_price}"><strong>{STATIC.tongtien}</strong></td>
                <td data-column="{LANG.win_price}"><strong>{STATIC.tongtien_hh}</strong></td>
                <td class="text-center" data-column="{LANG.num_win}"><strong>{STATIC.num_win}</strong></td>
                <td></td>
            </tr>
        </tfoot>
    </table>
    <!-- END: show_nt_success -->
</div>

<!-- BEGIN: merge_joint_venture -->
<!-- Thực hiện merge các cột có tên liên danh, giá dự thầu, giá trúng thầu, thời gian thực hiện hợp đồng trùng nhau vào -->
<script type="text/javascript">
    $(document).ready(function($) {
        tr = $("#list_business_online > tr");
        for (i=0; i < tr.length; i++) {
            if (i > 0) {
                tr.eq(i).find('.td__merge').remove();
            } else {
                tr.eq(i).find('.td__merge').attr('rowspan', tr.length);
            }
        }
    });
</script>
<!-- END: merge_joint_venture -->

<!-- END: show_kqth -->

<!-- BEGIN: fails -->
<h2 class="mb-2 text-uppercase">{LANG.list_fail}: </h2>
<table class="bidding-table">
    <thead>
        <tr>
            <th>{LANG.number}</th>
            <th class="w100">{SODDKD}</th>
            <th class="w100">{LANG.joint_venture}</th>
            <th>{LANG.bidder_name}</th>
            <th class="w200">{LANG.reason_fail}</th>
        </tr>
    </thead>
    <tbody>
        <!-- BEGIN: loop -->
        <tr>
            <td class="text-center" data-column="{LANG.number}">{FAIL.number}</td>
            <td class="text-center" data-column="{SODDKD}">{FAIL.code}</td>
            <td class="text-center" data-column="{LANG.joint_venture}">{FAIL.joint_venture}</td>
            <td data-column="{LANG.bidder_name}"><a href="{FAIL.link}">{FAIL.show_vip}{FAIL.bid_title}</a></td>
            <td data-column="{LANG.reason_fail}">{FAIL.reason}</td>
        </tr>
        <!-- END: loop -->
    </tbody>
</table>
<!-- END: fails -->

<!-- BEGIN: goods -->
<div class="box__table">
    <div class="flex">
        <h2 class="text-uppercase">{LANG.title_goods}</h2>
        <!-- BEGIN: show_excel_hh -->
        <div class="text-right margin-bottom-sm">
            <button type="button" class="btn btn-success xuatexcel" onclick="confirm_export('')">{LANG.exporthh}</button>
        </div>
        <!-- END: show_excel_hh -->
    </div>
    <div class="scroll-wrapper">
        <div class="scrollbar-top">
            <div class="table-header scrollbar-content">
                <table class="table-container bidding-table table-sticky-head">
                    <thead>
                        <tr>
                            <th>{LANG.number}</th>
                            <th>{LANG.good_name}</th>
                            <th>{LANG.code_goods}</th>
                            <th>{LANG.mass}</th>
                            <th>{LANG.unit}</th>
                            <th class="w250">{LANG.desc}</th>
                            <th class="w100">{LANG.origin}</th>
                            <th>{LANG.gia_dongia}</th>
                            <th>{LANG.note}</th>
                        </tr>
                    </thead>
                </table>
            </div>
        </div>
        <div class="scroll-content">
            <table class="table-container bidding-table table-sticky-head">
                <tbody>
                    <!-- BEGIN: loop -->
                    <tr>
                        <td class="text-center" data-column="{LANG.number}"><div>{GOODS.number}</div></td>
                        <td class="text-center" data-column="{LANG.good_name}"><div>{GOODS.goods_name}</div></td>
                        <td class="text-center" data-column="{LANG.code_goods}">
                            <div class="wrap__text">
                                {GOODS.sign_product}
                            </div>
                        </td>
                        <td class="text-center" data-column="{LANG.mass}"><div>{GOODS.number_bid}</div></td>
                        <td class="text-center" data-column="{LANG.unit}"><div>{GOODS.unit_cal}</div></td>
                        <td class="w250" data-column="{LANG.desc}"><div>{GOODS.description}</div></td>
                        <td class="w100" data-column="{LANG.origin}"><span class="fix__title_origin wrap__text"><div>{GOODS.origin}</span>
                        </td>
                        <td data-column="{LANG.gia_dongia}"><div>{GOODS.bid_price}</div></td>
                        <td data-column="{LANG.note}">
                            <span class="span__buton">
                                <span class="span__buton">
                                    <button type="button" class="btn btn-primary btn-radius" data-toggle="modal"
                                        onclick="search_goods('{GOODS.goods_name}', {DATA.solicitor_id}, {DATA.id})">{LANG.reference}</button>
                                </span>
                            </span>
                            {GOODS.note}
                        </td>
                    </tr>
                    <!-- END: loop -->
                </tbody>
            </table>
        </div>
    </div>
</div>
<div class="text-center">
    <ul class="pagination pagination__main">
    </ul>
</div>
<!-- END: goods -->

<!-- BEGIN: goods_tg_tv -->
<div class="box_table">
    <h2 class="text-uppercase">{LANG.job_category}</h2>
    <table class="bidding-table table-sticky-head">
        <thead>
            <tr>
                <th class="w150">{LANG.number}</th>
                <th colspan= "5">{LANG.list_service}</th>
            </tr>
        </thead>
        <tbody>
            <!-- BEGIN: loop -->
            <tr>
                <td class="text-center" data-column="{LANG.number}">{GOODS.number}</td>
                <td data-column="{LANG.list_service}" colspan= "5">{GOODS.goods_name}</td>
            </tr>
            <!-- END: loop -->
        </tbody>
    </table>
</div>

<div class="text-center">
    <ul class="pagination pagination__main">
    </ul>
</div>
<!-- END: goods_tg_tv -->

<!-- BEGIN: goods_tg -->
<div class="box__table">
    <h2 class="text-uppercase">{LANG.job_category}</h2>
    <div class="scroll-wrapper">
        <div class="scrollbar-top">
            <div class="table-header scrollbar-content">
                <table class="table-container bidding-table table-sticky-head">
                    <thead>
                        <tr>
                            <th>{LANG.number}</th>
                            <th>{LANG.list_service}</th>
                            <th>{LANG.service_description}</th>
                            <th>{LANG.mass}</th>
                            <th>{LANG.place}</th>
                            <th>{LANG.unit}</th>
                            <th>{LANG.gia_dongia}</th>
                            <th>{LANG.thanhtien}</th>
                            <th>{LANG.action_title}</th>
                        </tr>
                    </thead>
                </table>
            </div>
        </div>
        <div class="scroll-content">
            <table class="table-container bidding-table table-sticky-head">
                <tbody>
                    <!-- BEGIN: loop -->
                    <tr>
                        <td class="text-center" data-column="{LANG.number}">{GOODS.number}</td>
                        <td class="text-center" data-column="{LANG.list_service}">{GOODS.goods_name}</td>
                        <td class="text-center" data-column="{LANG.service_description}">{GOODS.description}</td>
                        <td class="text-center" data-column="{LANG.mass}">{GOODS.number_bid}</td>
                        <td data-column="{LANG.place}">{GOODS.detail}</td>
                        <td data-column="{LANG.unit}">{GOODS.unit_cal}</td>
                        <td data-column="{LANG.gia_dongia}">{GOODS.bid_price}</td>
                        <td data-column="{LANG.thanhtien}">{GOODS.thanhtien}</td>
                        <td data-column="{LANG.action_title}">
                            <span class="span__buton">
                                <button type="button" class="btn btn-primary btn-radius" data-toggle="modal" onclick="search_goods('{GOODS.goods_name}', {DATA.solicitor_id}, {DATA.id})">{LANG.reference}</button>
                            </span>
                        </td>
                    </tr>
                    <!-- END: loop -->
                </tbody>
            </table>
        </div>
    </div>
</div>

<div class="text-center">
    <ul class="pagination pagination__main">
    </ul>
</div>
<!-- END: goods_tg -->

<!-- BEGIN: goods_medecine -->
<div class="box__table">
    <div class="flex">
        <h2 class="text-uppercase"><span>{LANG.title_goods}</span></h2>
        <!-- BEGIN: show_excel_hh -->
        <div class="text-right margin-bottom-sm">
            <button type="button" class="btn btn-success xuatexcel" onclick="confirm_export('')">{LANG.exporthh}</button>
        </div>
        <!-- END: show_excel_hh -->
    </div>
    <div class="scroll-wrapper">
        <div class="scrollbar-top">
            <div class="table-header scrollbar-content">
                <table class="table-container bidding-table table-sticky-head">
                    <thead>
                        <th>{LANG.medicineCode}</th>
                        <th>{LANG.tenThuoc}</th>
                        <th class="w250">{LANG.tenHoatChat}</th>
                        <th>{LANG.gdklh}</th>
                        <th>{LANG.nuocSanXuat}</th>
                        <th>{LANG.unit}</th>
                        <th>{LANG.good_num}</th>
                        <th>{LANG.thanhtien}</th>
                        <th>{LANG.action_title}</th>
                    </thead>
                </table>
            </div>
        </div>

        <div class="scroll-content">
            <table class="table-container bidding-table table-sticky-head">
                <tbody>
                    <!-- BEGIN: loop -->
                    <tr>
                        <td data-column="{LANG.medicineCode}" class="text-center"><div>{GOOD.medicineCode}</div></td>
                        <td data-column="{LANG.tenThuoc}" class="text-center"><div>{GOOD.tenThuoc}</div></td>
                        <td data-column="{LANG.tenHoatChat}" class="text-center w250"><div>{GOOD.tenHoatChat}</div></td>
                        <td data-column="{LANG.gdklh}" class="text-center"><div>{GOOD.gdklh}</div></td>
                        <td data-column="{LANG.nuocSanXuat}" class="text-center"><div>{GOOD.nuocSanXuat}</div></td>
                        <td data-column="{LANG.unit}" class="text-center"><div>{GOOD.uom}</div></td>
                        <td data-column="{LANG.good_num}" class="text-center"><div>{GOOD.quantity}</div></td>
                        <td data-column="{LANG.thanhtien}" class="text-center"><div>{GOOD.amount}</div></td>
                        <td data-column="{LANG.action_title}" class="text-center">
                            <span class="span__buton">
                                <span class="span__buton">
                                    <button type="button" class="btn btn-primary btn-radius" data-toggle="modal"
                                        onclick="search_goods('{GOOD.tenThuoc}', {DATA.solicitor_id}, {DATA.id})">{LANG.reference}</button>
                                </span>
                            </span>
                        </td>
                    </tr>
                    <!-- END: loop -->
                </tbody>
            </table>
        </div>
    </div>
</div>

<div class="text-center">
    <ul class="pagination pagination__main">
    </ul>
</div>

<!-- END: goods_medecine -->

<!-- BEGIN: show_goods_related -->
<div>
    <hr>
    <!-- BEGIN: loop -->
    <div class="flex">
        <h2 class="mb-2 text-uppercase">{goods_related.name_table}: <a href="javascript:void(0)" class="view_related_good" style="font-size: 17px;" data-formcode="{goods_related.formcode}"><i class="fa fa-eye" aria-hidden="true"></i> {LANG.see_detail}</a></h2>
        <!-- BEGIN: show_excel_hh -->
        <div class="text-right margin-bottom-sm">
            <button type="button" class="btn btn-success xuatexcel" onclick="confirm_export('{goods_related.formcode}')">Xuất dữ liệu</button>
        </div>
        <!-- END: show_excel_hh -->
    </div>
    <!-- END: loop -->
    <div class="box__table">
        <table class="bidding-table table-sticky-head">
            <thead>
                <tr>
                    <th>{LANG.number}</th>
                    <th>{LANG.good_name}</th>
                    <th>{LANG.mass}</th>
                    <th>{LANG.unit}</th>
                    <th>{LANG.origin}</th>
                    <th>{LANG.gia_dongia}</th>
                    <th>{LANG.tenchuonghh}</th>
                    <th>{LANG.action_title}</th>
                </tr>
            </thead>
            <tbody>
                <!-- BEGIN: loop_good -->
                <tr>
                    <td class="text-center" data-column="{LANG.number}">{GOODS.stt}</td>
                    <td data-column="{LANG.good_name}"><div class="text-ellip" data-toggle="tooltip" data-placement="right" title="{GOODS.goods_name}">{GOODS.goods_name}</div></td>
                    <td class="text-center" data-column="{LANG.mass}">{GOODS.number_bid}</td>
                    <td data-column="{LANG.unit}">{GOODS.unit_cal}</td>
                    <td data-column="{LANG.origin}">{GOODS.origin}</td>
                    <td data-column="{LANG.gia_dongia}">{GOODS.bid_price}</td>
                    <td data-column="{LANG.tenchuonghh}">{GOODS.name_table}</td>
                    <td data-column="{LANG.action_title}">
                        <span class="span__buton">
                            <button type="button" class="btn btn-primary btn-radius" data-toggle="modal" onclick="search_goods('{GOODS.goods_name}', {DATA.solicitor_id}, {DATA.id})">{LANG.reference}</button>
                        </span>
                    </td>
                </tr>
                <!-- END: loop_good -->
            </tbody>
        </table>
    </div>

    <div class="text-center">
        <ul class="pagination pagination__main">

        </ul>
    </div>

    <div class="list_chaogiahanghoa"></div>

    <script type="text/javascript">
        $(function () {
          $('[data-toggle="tooltip"]').tooltip()
        });

        load_bangchaogia();
        function load_bangchaogia() {
            $.ajax({
                url: location.href,
                type: 'POST',
                dataType: 'json',
                data: {
                    'view_related_good': 1,
                    'btn_export_excel' : 1
                },
            })
            .done(function(data) {
                $(".list_chaogiahanghoa").html(data['data']);
                $(".list_chaogiahanghoa").find('h3').remove();
                $(".list_chaogiahanghoa").find('p').remove();
                $(".list_chaogiahanghoa").find('h2').removeClass('text-center');
            })
        }

        $(function() {
            $(".view_related_good").click(function() {
                $(".bg_momo").addClass('momo bg_momo_show');
                $formcode = $(this).attr('data-formcode');
                $.ajax({
                    url: location.href,
                    type: 'POST',
                    dataType: 'json',
                    data: {
                        'view_related_good': 1,
                        'formcode': $formcode
                    },
                })
                .done(function(data) {
                    $(".box_hanghoa").removeClass("hidden");
                    $(".list_hanghoa").slideDown(500);
                    $(".list_hanghoa").html("");
                    $(".list_hanghoa").html(data['data']);
                    let table = $(".list_hanghoa").find('table');
                    if (!$.fn.DataTable.isDataTable(table)) {
                        table.DataTable({
                            destroy: true,  // Phá hủy và khởi tạo lại
                            "timeout": 300000,
                            "language": {
                                "lengthMenu": "{LANG.datatable_lengthMenu}",
                                "search": "{LANG.datatable_search}",
                                "info": "{LANG.datatable_info}",
                                "zeroRecords": "{LANG.datatable_paginate_zeroRecords}",
                                "infoFiltered": "{LANG.datatable_paginate_infoFiltered}",
                                "infoEmpty": "{LANG.datatable_paginate_infoEmpty}",
                                "paginate": {
                                    "first": "{LANG.datatable_paginate_first}",
                                    "last": "{LANG.datatable_paginate_last}",
                                    "next": "{LANG.datatable_paginate_next}",
                                    "previous": "{LANG.datatable_paginate_previous}",
                                },
                            }
                        });

                        $(".list_hanghoa").find("select").parent().hide();
                        $(".list_hanghoa").find("input[type='search']").addClass("form-control mt-2");
                    }
                })
            });

            $(".close_custom").click(function() {
                $(".box_hanghoa").addClass("hidden");
                $(".bg_momo").removeClass('momo bg_momo_show');
            });

            $(".bg_momo").click(function() {
                $(".bg_momo").removeClass('momo bg_momo_show');
                $(".box_hanghoa").addClass("hidden");
            });
        });
    </script>

    <div class="bg_momo"></div>
    <div class="box_hanghoa hidden">
        <div class="col-md-24 text-right">
            <p class="text-right close_custom">{LANG.close}</p>
        </div>

        <div class="list_hanghoa">

        </div>
    </div>
</div>
<!-- END: show_goods_related -->

<form name=attachForm>
    <input type=hidden name=bidNo value='{DATA.bidNo}'> <input type=hidden name=bidTurnNo value='{DATA.bidTurnNo}'> <input type=hidden name=fileName> <input type=hidden name=cmd value='download'> <input type=hidden name=evalType value='4'>
</form>
<!-- END: online -->

<!-- BEGIN: offline -->
<!-- BEGIN: recaptcha -->
<div id="captchaModal" class="modal fade auto-width auto-height" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <p class="modal-title">{LANG.recapcha_title}</p>
            </div>
            <div class="modal-body">
                <div>{LANG.recapcha_body}</div>
                <div data-toggle="recaptcha" data-callback="verify_captcha" id="{RECAPTCHA_ELEMENT}"></div>
            </div>
        </div>
    </div>
</div>
<script>
function verify_captcha(e) {
    click_update();
}
</script>
<!-- END: recaptcha -->
<div class="bidding-detail-wrapper bidding-detail-wrapper-result">
    <h1 class="tl wrap__text bidding-name bidding-title">{DATA.title}</h1>
    <div class="margin-bottom">
        <div class="prb_container">
            <div class="prb clearfix">
                <!-- BEGIN: mess_item -->
                <span class="prb-progressbar">{MESS}</span>
                <!-- END: mess_item -->
            </div>
            <div class="prb clearfix">
                <!-- BEGIN: prb_item -->
                <!-- BEGIN: if_a -->
                <a class="item" href="{PROCESS.url}"><span class="icn {PROCESS.classes}" title="{PROCESS.title}"></span><span class="tl">{PROCESS.title}</span></a>
                <!-- END: if_a -->
                <!-- BEGIN: if_span -->
                <span class="item"><span class="icn {PROCESS.classes}" title="{PROCESS.title}"></span><span class="tl">{PROCESS.title}</span></span>
                <!-- END: if_span -->
                <!-- END: prb_item -->
            </div>
        </div>
    </div>
    <!-- BEGIN: chance_note -->
    <div class="alert alert-warning">
        <p>{LANG.result_info_note}</p>
    </div>
    <!-- END: chance_note -->
    <div class="row">
        <div class="col-xs-24 btn-share-group">
            <span>{LANG.share} </span>
            <a href="javascript:void(0)" class="btn-share" rel="nofollow" onclick="nv_fb_share();" title="{LANG.fb_share}">
                <span class="icon-facebook"></span>
            </a>
            <a href="javascript:void(0)" class="btn-share" rel="nofollow" onclick="nv_tw_share('', '{DATA.title}');" title="{LANG.tweet}">
                <span class="icon-twitter"></span>
            </a>
            <a href="javascript:void(0)" class="btn-share btn-copy-link" title="{LANG.copy_link}">
                <em class="fa fa-link"></em>
                <span class="tip" style="display: none;">{LANG.link_copy_successfully}</span>
            </a>
        </div>
    </div>

    <div class="bidding-page-btn flex_end">
        <!-- BEGIN: link_msc -->
        <a href="{LINK_MSC}"> <button class="btn btn-primary{BLUR_CLASS}">
            {LANG.icon_vneps}
            Link MSC</button></a>
        <!-- END: link_msc -->

        <div class="text-right">
            <!-- BEGIN: update -->
            <div class="small">
                {LANG.crawl_time}: <strong>{DATA.fget_time}</strong>
            </div>
            <div class="margin-top-sm m-bottom">
                <span class="small">{DATA.update_info}</span> <a style="margin-left: auto" id="reupdate" class="btn btn-default btn-xs active" onclick="show_captcha()" href="javascript:void(0)" data-id="{DATA.id}" data-check="{CHECKSESS_UPDATE}">{LANG.reupdate}</a><img id="update_wait" style="display: none" src="{NV_BASE_SITEURL}{NV_ASSETS_DIR}/images/load_bar.gif" /><span id="show_error" class="text-danger margin-left" style="display: none"></span>
                <!-- BEGIN: crawl_request_history_button -->
                <a style="margin-left: auto" id="crawl_request_history" class="btn btn-default btn-xs active" href="javascript:void(0)">{LANG.crawl_request_history}</a>
                <!-- END: crawl_request_history_button -->
            </div>
            <!-- BEGIN: crawl_request_history_list -->
            <div style="display: none;" id="crawl_request_history_list">
                <table class="bidding-table">
                    <thead>
                        <tr>
                            <th>{LANG.number}</th>
                            <th>{LANG.username}</th>
                            <th>{LANG.request_time}</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- BEGIN: loop -->
                        <tr>
                            <td>{CR.stt}</td>
                            <td>{CR.username}</td>
                            <td>{CR.last_reload}</td>
                        </tr>
                        <!-- END: loop -->
                    </tbody>
                </table>
            </div>
            <!-- END: crawl_request_history_list -->
            <!-- END: update -->
        </div>
        {FILE "button_show_log.tpl"}
    </div>

    <!-- BEGIN: show_waring_kqlcnt -->
    <div class="alert alert-warning">
        <p><i class="fa fa-exclamation-triangle" aria-hidden="true"></i> {LINK_WARNING_KQLCNT}</p>
    </div>
    <!-- END: show_waring_kqlcnt -->

    <div class="bidding-detail">
        <div class="bidding-detail-item col-four">
            <div>
                <div class="c-tit">{LANG.so_tbmt}</div>
                <div class="c-val">
                    <a href="{DATA.link_tbmt}">{DATA.code}</a>
                </div>
            </div>
            <div>
                <div class="c-tit">{LANG.cat}</div>
                <div class="c-val"><span class="direct-code">{DATA.cat}</span></div>
            </div>
        </div>
        <!-- BEGIN: plan_code -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.so_khlcnt}</div>
            <div class="c-val">
                <a href="{DATA.link_plan}">{DATA.plan_code}</a>
            </div>
        </div>
        <!-- END: plan_code -->
        <!-- BEGIN: type -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.phan_loai}</div>
            <div class="c-val">{DATA.type}</div>
        </div>
        <!-- END: type -->
        <!-- BEGIN: type_inform -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.loai_thong_bao}</div>
            <div class="c-val">{DATA.type_inform}</div>
        </div>
        <!-- END: type_inform -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.goi_thau}</div>
            <div class="c-val">{DATA.title}</div>
        </div>

        <!-- BEGIN: project_name -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.ten_du_an}</div>
            <div class="c-val">{DATA.project_name}</div>
        </div>
        <!-- END: project_name -->

        <!-- BEGIN: investor -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.chu_dau_tu}</div>
            <div class="c-val title-strong">
                <!-- BEGIN: if_link -->
                <a href="{DATA.link_investor}" title="{DATA.investor}">{DATA.investor}</a>
                <!-- END: if_link -->
                <!-- BEGIN: if_no_link -->
                {DATA.investor}
                <!-- END: if_no_link -->
            </div>
        </div>
        <!-- END: investor -->
        <!-- BEGIN: ben_moi_thau -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.ben_moi_thau}</div>
            <div class="c-val title-strong">
                <!-- BEGIN: if_link -->
                <a href="{DATA.link_solicitor}" title="{DATA.solicitor_title}">{DATA.solicitor_title}</a>
                <!-- END: if_link -->
                <!-- BEGIN: if_unlink -->
                    <a href="{DATA.link_solicitor_unlink}">{DATA.solicitor_title}</a>
                <!-- END: if_unlink -->
                <!-- BEGIN: if_no_link -->
                {DATA.solicitor_title}
                <!-- END: if_no_link -->
            </div>
        </div>
        <!-- END: ben_moi_thau -->

        <!-- BEGIN: totalview -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.totalview}</div>
            <div class="c-val title-strong">{DATA.totalview}</div>
        </div>
        <!-- END: totalview -->

        <!-- BEGIN: type_choose -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.type_choose_invest}</div>
            <div class="c-val">{DATA.type_choose}</div>
        </div>
        <!-- END: type_choose -->

        <!-- BEGIN: price_estimate -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.price_estimate}</div>
            <div class="c-val">{DATA.price_estimate}</div>
        </div>
        <!-- END: price_estimate -->

        <div class="bidding-detail-item col-four">
            <!-- BEGIN: bid_price_number -->
            <div>
                <div class="c-tit">{LANG.price_contract}</div>
                <div class="c-val">{DATA.bid_price}</div>
            </div>

            <!-- END: bid_price_number -->

            <!-- BEGIN: date_caculate -->
            <div>
                <div class="c-tit">{LANG.date_caculate}</div>
                <div class="c-val">{DATA.date_caculate}</div>
            </div>
            <!-- END: date_caculate -->
        </div>

        <!-- BEGIN: other_current -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.other_current}</div>
            <div class="c-val title-strong">{DATA.other_current}</div>
        </div>
        <!-- END: other_current -->

        <!-- BEGIN: report_result -->
        <div class="bidding-detail-item wrap__text">
            <div class="c-tit">{LANG.result_attach}</div>
            <div class="c-val download__file">
                <div class="tab-content download">
                    <div class="tab-pane fade active in">
                        <div class="list-group-item display-flex">
                            <a href="{LINK}" class="disable-link" target="_blank" rel="noopener noreferrer nofollow"><span class="">{NAME_FILE}</span></a>
                            <div class="text-nowrap" style="margin-left:auto"><a class="btn btn-primary btn-xs" href="{LINK}" target="_blank" rel="noopener noreferrer nofollow"><em class="fa fa-snowflake-o"></em> {LANG.download_title}</a></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- END: report_result -->

        <!-- BEGIN: open_time -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.den_ngay}</div>
            <div class="c-val">{DATA.open_time}</div>
        </div>
        <!-- END: open_time -->

        <!-- BEGIN: type_contract -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.hinh_thuc_hop_dong}</div>
            <div class="c-val title-strong">{DATA.type_contract}</div>
        </div>
        <!-- END: type_contract -->
        <!-- BEGIN: time_todo -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.time_todo}</div>
            <div class="c-val">{DATA.time_todo}</div>
        </div>
        <!-- END: time_todo -->

        <!-- BEGIN: van_ban_phe_duyet -->
        <div class="bidding-detail-item col-four">
            <div>
                <div class="c-tit">{LANG.van_ban_phe_duyet}</div>
                <div class="c-val">{DATA.number_document}</div>
            </div>
            <div>
                <div class="c-tit">{LANG.approval_date}</div>
                <div class="c-val">{DATA.date_approval}</div>
            </div>
        </div>
        <!-- END: van_ban_phe_duyet -->

        <!-- BEGIN: reason -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.reason_choose}</div>
            <div class="c-val"><span class="text-danger">{DATA.reason}</span></div>
        </div>
        <!-- END: reason -->
        <!-- BEGIN: finish_time -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.finish_time}</div>
            <div class="c-val red">{DATA.finish_time}</div>
        </div>
        <!-- END: finish_time -->

        <!-- BEGIN: type_bid -->
        <div class="bidding-detail-item">
            <div class="c-tit">{LANG.type_bid}</div>
            <div class="c-val">{DATA.type_bid}</div>
        </div>
        <!-- END:  type_bid -->

        <!-- BEGIN: show_new_msc -->
            <div class="bidding-detail-item">
                <div class="c-tit">{LANG.loai_hd}</div>
                <div class="c-val">{DATA.ctype}</div>
            </div>

            <div class="bidding-detail-item">
                <div class="c-tit">{LANG.method_bidder}</div>
                <div class="c-val">{DATA.pt_lcnt}</div>
            </div>

            <div class="bidding-detail-item">
                <div class="c-tit">{LANG.phan_muc}</div>
                <div class="c-val">
                    {DATA.bidfieid}
                </div>
            </div>

            <div class="bidding-detail-item">
                <div class="c-tit">{LANG.is_domestic}</div>
                <div class="c-val">{DATA.name_domestic}</div>
            </div>

            <!-- BEGIN: report_filename -->
            <div class="bidding-detail-item">
                <div class="c-tit">{LANG.bcdghsdt}</div>
                <div class="c-val">{DATA.report_filename}</div>
            </div>
            <!-- END: report_filename -->

            <!-- BEGIN: quyet_dinh_phe_duyet_type1 -->
            <div class="bidding-detail-item flex-direction-column">
                <div class="c-tit">{LANG.quyet_dinh_phe_duyet}</div>
                <div class="c-val">
                    <div class="tab-content download {ICON_PLANE}">
                        <div class="tab-pane fade{HOME_ACTIVE} in" id="ho_so_nav_first" role="tabpanel" aria-labelledby="ho_so_nav_first_tab">
                            <div class="list-group download-link{IS_OTHER_BROWSER}">
                                {download_file_content}
                            </div>
                        </div>
                        <div id="myDiv" class="tab-pane fade{POINT_ACTIVE} in list-group download-link is_points{IS_OTHER_BROWSER}" id="ho_so_nav_second" role="tabpanel" aria-labelledby="ho_so_nav_second_tab">
                            {bao_cao}
                        </div>
                    </div>
                    <!-- BEGIN: if_ie_down -->
                    <small><i class="fa fa-paper-plane-o"></i> {note_ie_down}</small>
                    <!-- END: if_ie_down -->
                </div>
            </div>
            <!-- END: quyet_dinh_phe_duyet_type1 -->

            <!-- BEGIN: quyet_dinh_phe_duyet -->
            <div class="bidding-detail-item flex-direction-column">
                <div class="c-tit">{LANG.quyet_dinh_phe_duyet}</div>
                <div class="c-val">
                    <p id="tai_ho_so">{DOWNLOAD_MESS}</p>
                    <!-- BEGIN: point_or_t0 -->
                    <div class="container-download">
                        <div class="column-download">
                            <div class="button-container">
                                <div class="center-buttons">
                                    <button class="btn btn-primary" onclick="buy_fastlink(this)" data-id="{id}" data-confirm="{LANG_FILE.down_point_confirm}">{LANG.link_file_fast}</button>
                                </div>
                                <p>{info_T0}</p>
                            </div>
                        </div>
                        <div class="column-download">
                            <div class="button-container">
                                <div class="center-buttons">
                                    <button class="btn btn-primary" onclick="redirect_link('{link_T0}')">{LANG.buy_TO}</button>
                                </div>
                                <p>{LANG.show_info_down_t0_2227}</p>
                            </div>
                        </div>
                    </div>
                    <!-- END: point_or_t0 -->
                    <!-- BEGIN: vip_size_info -->
                    <p>
                        <em class="fa fa-bell"></em> {VIPSIZE_MESS}
                    </p>
                    <!-- END: vip_size_info -->
                    <div class="tab-content download {ICON_PLANE}">
                        <div class="tab-pane fade{HOME_ACTIVE} in" id="ho_so_nav_first" role="tabpanel" aria-labelledby="ho_so_nav_first_tab">
                            <div class="list-group download-link{IS_OTHER_BROWSER}">
                                {download_file_content}
                            </div>
                        </div>
                        <div id="myDiv" class="tab-pane fade{POINT_ACTIVE} in list-group download-link is_points{IS_OTHER_BROWSER}" id="ho_so_nav_second" role="tabpanel" aria-labelledby="ho_so_nav_second_tab">
                            {bao_cao}
                        </div>
                    </div>
                    <!-- BEGIN: if_ie_down -->
                    <small><i class="fa fa-paper-plane-o"></i> {note_ie_down}</small>
                    <br>
                    <small><i class="fa fa-exclamation-circle"></i> {LANG.note_ehsmt} </small>
                    <!-- END: if_ie_down -->
                </div>
            </div>
            <!-- END: quyet_dinh_phe_duyet -->

            <!-- BEGIN: number_document1 -->
            <div class="bidding-detail-item">
                <div class="c-tit">{LANG.so_qdpd}</div>
                <div class="c-val">{DATA.number_document1}</div>
            </div>
            <!-- END: number_document1 -->

            <!-- BEGIN: decision_agency -->
            <div class="bidding-detail-item">
                <div class="c-tit">{LANG.cqpd}</div>
                <div class="c-val">{DATA.decision_agency}</div>
            </div>
            <!-- END: decision_agency -->

            <!-- BEGIN: decision_date -->
            <div class="bidding-detail-item">
                <div class="c-tit">{LANG.ngay_phe_duyet}</div>
                <div class="c-val">{DATA.date_approval}</div>
            </div>
            <!-- END: decision_date -->
        <!-- END: show_new_msc -->

        <!-- BEGIN: ho_so_msc_cu -->
        <div class="bidding-detail-item wrap__text">
            <div class="c-tit">{LANG.document_approval}</div>
            <div class="c-val download__file">
                <a href="#" id="document_approval_id" onclick="javascript:getAttach('{DATA.document_approval_name}');"><i class="fa fa-cloud-download" aria-hidden="true"></i> {DATA.document_approval}</a>
                <p class="warning__file hidden" title="Cảnh báo tải file">
                    <em class="fa fa-bell"></em> {LANG.notify_chrome}
                </p>
                <!-- BEGIN: if_ie -->
                <small><i class="fa fa-internet-explorer"></i> {note_ie}</small>
                <!-- END: if_ie -->
            </div>
        </div>
        <!-- END: ho_so_msc_cu -->

        <!-- BEGIN: ho_so_msc_cu_crawl -->
        <div class="bidding-detail-item wrap__text">
            <div class="c-tit">{LANG.document_approval}</div>
            <div class="c-val download__file">
                <div class="tab-content download">
                    <div class="tab-pane fade active in">
                        <div class="list-group-item display-flex">
                            <a href="{LINK}" class="disable-link" target="_blank" rel="noopener noreferrer nofollow"><span class="">{NAME_FILE}</span></a>
                            <div class="text-nowrap" style="margin-left:auto"><a class="btn btn-primary btn-xs" href="{LINK}" target="_blank" rel="noopener noreferrer nofollow"><em class="fa fa-snowflake-o"></em> {LANG.download_title}</a></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- END: ho_so_msc_cu_crawl -->

        <!-- BEGIN: bidder_name_tt -->
            <div class="bidding-detail-item">
                <div class="c-tit">{LANG.tbkq_lcnt}</div>
                <div class="c-val">{TRUNGTHAU}</div>
            </div>
        <!-- END: bidder_name_tt -->
    </div>
</div>
<!-- BEGIN: show_kqth_off -->
<div class="table-responsive bidding_table">
    <!-- BEGIN: list_business_off -->
    <h2 class="mb-2 text-uppercase">{LANG.list_solicitor_win}</h2>
    <table class="table table-bordered table-hover">
        <thead>
            <tr>
                <th>{LANG.number}</th>
                <th class="w100">{SODDKD}</th>
                <th class="w150">{LANG.joint_venture}</th>
                <th>{LANG.bidder_name}</th>
                <th class="w150">{LANG.tender_price}</th>
                <th class="w100">{LANG.point}</th>
                <th class="w100">{LANG.win_price_number}</th>
                <th class="w100">{TG_TRUNGTHAU}</th>
                <th class="w100">{LANG.contract_sign_date}</th>
            </tr>
        </thead>
        <tbody>
            <!-- BEGIN: loop -->
                <tr>
                    <td class="text-center">{ROW.stt}</td>
                    <td class="text-center">{ROW.no_business_licence}</td>
                    <td class="td__merge">
                        {ROW.tenliendanh}
                    </td>
                    <td class="text-center"><h3><a href="{ROW.link}" style="color: {ROW.color}">{ROW.show_vip}{ROW.bidder_name}</a></h3></td>
                    <td class="text-center td__merge">{DATA.tender_price}</td>
                    <td class="text-center td__merge">{DATA.point}</td>
                    <td class="text-center td__merge">{ROW.bidwinningprice}</td>
                    <td class="text-center td__merge">{ROW.cperiod}</td>
                    <td class="text-center td__merge">{ROW.contract_sign_date}</td>
                </tr>
            <!-- END: loop -->
        </tbody>
    </table>
    <!-- END: list_business_off -->

    <!-- BEGIN: show_business_success -->
    <h2 class="mb-2 text-uppercase">{LANG.list_solicitor_win}</h2>
    <table class="table table-bordered table-hover">
        <thead>
            <tr>
                <th class="w100">{SODDKD}</th>
                <th>{LANG.bidder_name}</th>
                <th class="w150">{LANG.tender_price}</th>
                <th class="w100">{LANG.point}</th>
                <th class="w100">{LANG.win_price}</th>
                <th class="w100">{LANG.thoi_gian_hd}</th>
            </tr>
        </thead>
        <tbody>
                <tr>
                    <td class="text-center">{DATA.no_business_licence}</td>
                    <td class="text-center"><h3><a href="javascript:void(0)">{DATA.bidder_name}</a></h3></td>
                    <td class="text-center td__merge">{DATA.tender_price}</td>
                    <td class="text-center td__merge">{DATA.point}</td>
                    <td class="text-center td__merge">{DATA.win_price}</td>
                    <td class="text-center td__merge">{DATA.time_todo}</td>
                </tr>
        </tbody>
    </table>
    <!-- END: show_business_success -->

    <!-- BEGIN: show_list_business -->
    <strong>{LANG.list_liendanh}</strong>
    <div class="table-responsive">
        <table class="bidding-table">
            <thead>
                <tr>
                    <th class="text-center">#</th>
                    <th>{LANG.bidder_name}</th>
                    <th>{LANG.partnership}</th>
                </tr>
            </thead>
            <tbody>
                <!-- BEGIN: loop_list_business -->
                <tr>
                    <td class="text-center" data-column="#">{VALUE.stt}</td>
                    <td><a href="{VALUE.link}" data-column="{LANG.bidder_name}" style="color: {VALUE.color}">{VALUE.show_vip}{VALUE.bidder_name}</a></td>
                    <td data-column="{LANG.partnership}">{VALUE.title_partnership}</td>
                </tr>
                <!-- END: loop_list_business -->
            </tbody>
        </table>
    </div>
    <!-- END: show_list_business -->

    <!-- BEGIN: show_nt_success -->
    <h2 class="mb-2 text-uppercase">{LANG.title_subdivision}</h2>
    <table class="bidding-table" id="table_one">
        <thead>
            <tr>
                <th>{LANG.number}</th>
                <th class="w100">{SODDKD}</th>
                <th>{LANG.bidder_name}</th>
                <th class="w100">{LANG.win_price}</th>
                <th class="w100">{LANG.sum_price_sub}</th>
                <th class="w100">{LANG.num_win}</th>
                <th>{LANG.action_title}</th>
            </tr>
        </thead>
        <tbody>
            <!-- BEGIN: loop -->
                <tr>
                    <td class="text-center" data-column="{LANG.number}">{ROW.stt}</td>
                    <td class="text-center" data-column="{SODDKD}">{ROW.orgcode}</td>
                    <td><a href="{ROW.link}" data-column="{LANG.bidder_name}">{ROW.show_vip}{ROW.bid_title}</a></td>
                    <td data-column="{LANG.win_price}">{ROW.bidwiningprice}</td>
                    <td data-column="{LANG.total_win_price_goods}">{ROW.total_price}</td>
                    <td class="text-center" data-column="{LANG.num_win}">{ROW.num_goods}</td>
                    <td class="text-center" data-column="{LANG.action_title}">
                        <a href="javascript:void(0)" class="view__goods" data-toggle="modal" data-target="#show_goods_subdivision" data-name='{ROW.bid_title}'>{LANG.viewdetail} <i class="fa fa-eye" aria-hidden="true"></i>
                            <span class="data-sub hidden">{ROW.list}</span>
                        </a>
                    </td>
                </tr>
            <!-- END: loop -->
        </tbody>
        <tfoot>
            <tr>
                <td></td>
                <td colspan="2">{STATIC.tong}</td>
                <td data-column="{LANG.win_price}"><strong>{STATIC.tongtien}</strong></td>
                <td data-column="{LANG.win_price}"><strong>{STATIC.tongtien_hh}</strong></td>
                <td class="text-center" data-column="{LANG.num_win}"><strong>{STATIC.num_win}</strong></td>
                <td></td>
            </tr>
        </tfoot>
    </table>
    <!-- END: show_nt_success -->

    <!-- BEGIN: show_nt_success_ld -->
    <table class="bidding-table">
        <thead>
            <tr>
                <th>{LANG.number}</th>
                <th class="w100">{SODDKD}</th>
                <th>{LANG.bidder_name}</th>
                <th>{LANG.joint_venture}</th>
                <th class="w100">{LANG.win_price}</th>
                <th class="w100">{LANG.num_win}</th>
                <th>{LANG.action_title}</th>
            </tr>
        </thead>
        <tbody id="list_business_online">
            <!-- BEGIN: loop -->
                <tr>
                    <td class="text-center" data-column="{LANG.number}">{ROW.stt}</td>
                    <td class="text-center" data-column="{SODDKD}">{ROW.orgcode}</td>
                    <td><a href="{ROW.link}" data-column="{LANG.bidder_name}">{ROW.show_vip}{ROW.bidder_name}</a></td>
                    <td class="td__merge" data-column="{LANG.joint_venture}">{ROW.joint_venture}</td>
                    <td class="td__merge" data-column="{LANG.win_price}">{DATA.tongtien_subdiv}</td>
                    <td class="text-center td__merge" data-column="{LANG.num_win}">{DATA.num_subdiv}</td>
                    <td class="text-center td__merge" data-column="{LANG.action_title}">
                        <a href="javascript:void(0)" class="view__goods" data-toggle="modal" data-target="#show_goods_subdivision" data-sub='{DATA.get_subdivision_goods}' data-name='{ROW.joint_venture}'>{LANG.viewdetail} <i class="fa fa-eye" aria-hidden="true"></i></a>
                    </td>
                </tr>
            <!-- END: loop -->
        </tbody>
        <tfoot>
            <tr>
                <td></td>
                <td colspan="3">{DATA.win_subdiv}</td>
                <td><strong>{DATA.tongtien_subdiv}</strong></td>
                <td class="text-center"><strong>{DATA.num_subdiv}</strong></td>
            </tr>
        </tfoot>
    </table>
    <!-- END: show_nt_success_ld -->
</div>

<!-- BEGIN: merge_joint_venture -->
<!-- Thực hiện merge các cột có tên liên danh, giá dự thầu, giá trúng thầu, thời gian thực hiện hợp đồng trùng nhau vào -->
<script type="text/javascript">
    $(document).ready(function($) {
        tr = $("#list_business_online > tr");
        for (i=0; i < tr.length; i++) {
            if (i > 0) {
                tr.eq(i).find('.td__merge').remove();
            } else {
                tr.eq(i).find('.td__merge').attr('rowspan', tr.length);
            }
        }
    });
</script>
<!-- END: merge_joint_venture -->
<!-- END: show_kqth_off -->

<!-- BEGIN: fails -->
<h2 class="text-uppercase">{LANG.list_fail}: </h2>
<div class="table-responsive">
    <table class="bidding-table">
        <thead>
            <tr>
                <th>{LANG.number}</th>
                <th class="w100">{LANG.so_dkkd}</th>
                <th class="w100">{LANG.joint_venture}</th>
                <th>{LANG.bidder_name}</th>
                <th class="w200">{LANG.reason_fail}</th>
                <th class="w100">{LANG.step_fail}</th>
            </tr>
        </thead>
        <tbody>
            <!-- BEGIN: loop -->
            <tr>
                <td class="text-center" data-column="{LANG.number}">{FAIL.number}</td>
                <td class="text-center" data-column="{LANG.so_dkkd}">{FAIL.code}</td>
                <td class="text-center" data-column="{LANG.joint_venture}">{FAIL.joint_venture}</td>
                <td data-column="{LANG.bidder_name}"><a href="{FAIL.link}">{FAIL.show_vip}{FAIL.bid_title}</a></td>
                <td data-column="{LANG.reason_fail}">{FAIL.reason}</td>
                <td data-column="{LANG.step_fail}">{FAIL.step_fail}</td>
            </tr>
            <!-- END: loop -->
        </tbody>
    </table>
</div>
<!-- END: fails -->

<!-- BEGIN: goods -->
<div class="bidding-simple wrap__text">
    <div class="flex">
        <h2 class="text-uppercase">{LANG.title_goods}</h2>
        <!-- BEGIN: show_excel_hh -->
        <div class="text-right margin-bottom-sm">
            <button type="button" class="btn btn-success xuatexcel" onclick="confirm_export('')">{LANG.exporthh}</button>
        </div>
        <!-- END: show_excel_hh -->
    </div>
    <div class="box__table">
        <div class="scroll-wrapper">
            <div class="scrollbar-top">
                <div class="table-header scrollbar-content">
                    <table class="table-container bidding-table table-sticky-head">
                        <thead>
                            <tr>
                                <th class="w100">{LANG.number}</th>
                                <th>{LANG.good_name}</th>
                                <th>{LANG.code_goods}</th>
                                <th>{LANG.mass}</th>
                                <th>{LANG.unit}</th>
                                <th class="w250">{LANG.desc}</th>
                                <th>{LANG.origin}</th>
                                <th>{LANG.win_price}</th>
                                <th>{LANG.note}</th>
                            </tr>
                        </thead>
                    </table>
                </div>
            </div>
            <div class="scroll-content">
                <table class="table-container bidding-table table-sticky-head">
                    <tbody>
                        <!-- BEGIN: loop -->
                        <tr>
                            <td class="text-center w100" data-column="{LANG.number}">{GOODS.number}</td>
                            <td data-column="{LANG.good_name}">{GOODS.goods_name}</td>
                            <td class="text-center" data-column="{LANG.code_goods}">
                                <div class="wrap__text">
                                    {GOODS.sign_product}
                                </div>
                            </td>
                            <td class="text-center" data-column="{LANG.mass}">{GOODS.number_bid}</td>
                            <td class="text-center" data-column="{LANG.unit}">{GOODS.unit_cal}</td>
                            <td data-column="{LANG.desc}" class="w250">{GOODS.description}</td>
                            <td data-column="{LANG.origin}"><span class="fix__title_origin">{GOODS.origin}</span></td>
                            <td class="text-right" data-column="{LANG.gia_dongia}">{GOODS.bid_price}</td>
                            <td data-column="{LANG.note}">
                                <span class="span__buton">
                                    <button type="button" class="btn btn-primary btn-radius" data-toggle="modal" onclick="search_goods('{GOODS.goods_name}', {DATA.solicitor_id}, {DATA.id})">{LANG.reference}</button>
                                </span><br>
                                {GOODS.note}
                            </td>
                        </tr>
                        <!-- END: loop -->
                    </tbody>
                </table>
            </div>
        </div>

        <div class="text-center">
            <ul class="pagination pagination__main">

            </ul>
        </div>
    </div>
</div>
<!-- END: goods -->

<!-- BEGIN: goods_medecine -->
<div class="box__table">
    <div class="flex">
        <h2 class="text-uppercase"><span>{LANG.title_goods}</span></h2>
        <!-- BEGIN: show_excel_hh -->
        <div class="text-right margin-bottom-sm">
            <button type="button" class="btn btn-success xuatexcel" onclick="confirm_export('')">{LANG.exporthh}</button>
        </div>
        <!-- END: show_excel_hh -->
    </div>
    <div class="scroll-wrapper">
        <div class="scrollbar-top">
            <div class="table-header scrollbar-content">
                <table class="table-container bidding-table table-sticky-head">
                    <thead>
                        <th>{LANG.number}</th>
                        <th>{LANG.tenThuoc}</th>
                        <th class="w250">{LANG.tenHoatChat}</th>
                        <th>{LANG.gdklh}</th>
                        <th>{LANG.nuocSanXuat}</th>
                        <th>{LANG.unit}</th>
                        <th>{LANG.good_num}</th>
                        <th>{LANG.thanhtien}</th>
                        <th>{LANG.action_title}</th>
                    </thead>
                </table>
            </div>
        </div>
        <div class="scroll-content">
            <table class="table-container bidding-table table-sticky-head">
                <tbody>
                    <!-- BEGIN: loop -->
                    <tr>
                        <td data-column="{LANG.number}" class="text-center"><div>{GOOD.stt}</div></td>
                        <td data-column="{LANG.tenThuoc}" class="text-center"><div>{GOOD.tenThuoc}</div></td>
                        <td data-column="{LANG.tenHoatChat}" class="text-center w250"><div>{GOOD.tenHoatChat}</div></td>
                        <td data-column="{LANG.gdklh}" class="text-center"><div>{GOOD.gdklh}</div></td>
                        <td data-column="{LANG.nuocSanXuat}" class="text-center"><div>{GOOD.nuocSanXuat}</div></td>
                        <td data-column="{LANG.unit}" class="text-center"><div>{GOOD.uom}</div></td>
                        <td data-column="{LANG.good_num}" class="text-center"><div>{GOOD.quantity}</div></td>
                        <td data-column="{LANG.thanhtien}" class="text-center"><div>{GOOD.amount}</div></td>
                        <td data-column="{LANG.action_title}" class="text-center">
                            <span class="span__buton">
                                <span class="span__buton">
                                    <button type="button" class="btn btn-primary btn-radius" data-toggle="modal"
                                        onclick="search_goods('{GOOD.tenThuoc}', {DATA.solicitor_id}, {DATA.id})">{LANG.reference}</button>
                                </span>
                            </span>
                        </td>
                    </tr>
                    <!-- END: loop -->
                </tbody>
            </table>
        </div>
    </div>
</div>
<div class="text-center">
    <ul class="pagination pagination__main">
    </ul>
</div>
<!-- END: goods_medecine -->


<!-- BEGIN: bid_win -->
<span class="red title-strong">{LANG.bid_other}: </span>
<div class="table-responsive">
    <table class="bidding-table">
        <thead>
            <tr>
                <th class="w100">{LANG.number}</th>
                <th class="w250">{LANG.companyname}</th>
                <th class="w150">{LANG.price_bid}</th>
                <th class="w150">{LANG.part_win}</th>
            </tr>
        </thead>
        <tbody>
            <!-- BEGIN: loop -->
            <tr>
                <td class="text-center" data-column="{LANG.number}">{BWIN.b_number}</td>
                <td data-column="{LANG.companyname}">{BWIN.company_name}</td>
                <td data-column="{LANG.price_bid}">{BWIN.price_text}</td>
                <td data-column="{LANG.part_win}">{BWIN.part_text}</td>
            </tr>
            <!-- END: loop -->
        </tbody>
    </table>
</div>
<!-- END: bid_win -->

<!-- BEGIN: succ -->
<h2>{LANG.list_solicitor_win}: </h2>
<div class="table-responsive">
    <table class="bidding-table">
        <thead>
            <tr>
                <th>{LANG.number}</th>
                <th class="w100">{LANG.so_dkkd}</th>
                <th class="w150">{LANG.joint_venture}</th>
                <th>{LANG.bidder_name}</th>
                <th class="w150">{LANG.win_price}</th>
                <th class="w100">{LANG.type_contract_title}</th>
                <th class="w100">{LANG.time_todo}</th>
            </tr>
        </thead>
        <tbody>
            <!-- BEGIN: loop -->
            <tr>
                <td class="text-center" data-column="{LANG.number}">{SUCC.number}</td>
                <td class="text-center" data-column="{LANG.so_dkkd}">{SUCC.number_res}</td>
                <td class="text-center" data-column="{LANG.joint_venture}">{SUCC.joint_venture}</td>
                <td data-column="{LANG.bidder_name}">{SUCC.show_vip}{SUCC.bid_title}</td>
                <td data-column="{LANG.win_price}">{SUCC.bid_price}</td>
                <td data-column="{LANG.type_contract_title}">{SUCC.type_contract}</td>
                <td data-column="{LANG.time_todo}">{SUCC.time_todo}</td>
            </tr>
            <!-- END: loop -->
        </tbody>
    </table>
</div>
<!-- END: succ -->

<form id="formModel" name="formModel">
    <input type="hidden" name="bidNo" value="{DATA.bidNo}"> <input type="hidden" name="bidTurnNo" value="{DATA.bidTurnNo}"> <input type="hidden" name="bidType" value="1"> <input type="hidden" name="typeDown" value="1">
    <!-- <input type="hidden" name="bidNo" value="20181063439">
        <input type="hidden" name="bidTurnNo" value="00">
        <input type="hidden" name="bidType" value="1">
        <input type="hidden" name="typeDown" value="1">
-->
</form>
<!-- END: offline -->
<!-- BEGIN: cancel -->
<h1 class="tl wrap__text bidding-name bidding-title">{DATA.title}</h1>
<span class="red title-strong">{LANG.bid_info}: </span>
<div class="bidding-detail">
    <div class="bidding-detail-item">
        <div class="c-tit">{LANG.so_tbmt}</div>
        <div class="c-val">{DATA.code}</div>
    </div>
    <div class="bidding-detail-item">
        <div class="c-tit">{LANG.goi_thau}</div>
        <div class="c-val">{DATA.title}</div>
    </div>
    <div class="bidding-detail-item">
        <div class="c-tit">{LANG.close_time}</div>
        <div class="c-val">{DATA.open_time}</div>
    </div>
    <div class="bidding-detail-item">
        <div class="c-tit">{LANG.step_cancel}</div>
        <div class="c-val">{DATA.step_cancel}</div>
    </div>
</div>
<span class="red title-strong">{LANG.cancel_info}: </span>
<div class="bidding-detail">
    <div class="bidding-detail-item">
        <div class="c-tit">{LANG.reason_title}</div>
        <div class="c-val">{DATA.reason}</div>
    </div>
    <div class="bidding-detail-item">
        <div class="c-tit">{LANG.number_document}</div>
        <div class="c-val">{DATA.number_document}</div>
    </div>
    <div class="bidding-detail-item">
        <div class="c-tit">{LANG.approval_date}</div>
        <div class="c-val">{DATA.date_approval}</div>
    </div>
    <div class="bidding-detail-item">
        <div class="c-tit">{LANG.cancel_time}</div>
        <div class="c-val">{DATA.time_cancel}</div>
    </div>
    <div class="bidding-detail-item">
        <div class="c-tit">{LANG.document_approval}</div>
        <div class="c-val">{DATA.document_approval}</div>
    </div>
</div>
<!-- END: cancel -->
<!-- <div class="news_column panel panel-default">
    <div class="panel-body">[FACEBOOK_COMMENT]</div>
</div> -->
<div id="confirm" class="modal fade auto-height" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-body"></div>
            <div class="modal-footer">
                <span class="button"></span>
                <button type="button" class="ok btn btn-primary">{LANG.ok}</button>
                <button type="button" data-dismiss="modal" class="btn">{LANG.close}</button>
            </div>
        </div>
    </div>
</div>

<!-- BEGIN: show_waring -->
<script type="text/javascript">
    $(document).ready(function() {
        $(".download__file > .warning__file").removeClass('hidden');
    });
</script>
<!-- END: show_waring -->

<script>
<!-- BEGIN: download -->
$(document).ready(function(){
    $("#document_approval_id").click();
});
<!-- END: download -->
function getAttach(reportName) {
    document.attachForm.fileName.value=reportName;
    document.attachForm.method='post';
    document.attachForm.action='http://muasamcong.mpi.gov.vn:8082/servlet/GC/EP_COV_GCE202';
    document.attachForm.submit();
    return;
}
$("#downloadFile").click(function(){
    document.formModel.method = "post";
    document.formModel.action = "http://muasamcong.mpi.gov.vn:8082/webentry/cdt/downloadFileName";
    document.formModel.submit();
});
</script>
{FILE "modal_log.tpl"}

<script type="text/javascript">
    $(document).ready(function() {
        page = location.href.split("?page=")[1];
        if (parseInt(page) > 1) {
            $("html, body").animate({
                scrollTop: $(".text_title_hh").offset().top
            }, 500);
        }
        $(".notification_success").hide();
        $(".notification_danger").hide();
        $("#save_excel").click(function() {
            if ($("#is_x4").val() == 1) {
                $("#loading_data").html('{LANG.processing_data} <i class="fa fa-spinner fa-spin"></i>');
                $.ajax({
                    url: location.href,
                    type: 'POST',
                    data: {
                        xuatexcel: 1,
                        fcode: $("#save_excel").attr('data-fcode')
                    },
                })
                .done(function(res) {
                    if (res['status'] == 'success') {
                        $(".notification_success").hide();
                        $(".notification_danger").hide();
                        $(".notification_success").show(500);
                        $(".notification_success").html(res['messages']);
                    } else {
                        $(".notification_danger").hide();
                        $(".notification_danger").show(500);
                        $(".notification_danger").html(res['messages']);
                    }
                    $("#loading_data").html('');
                });
            } else {
                if (confirm("{LANG.confirm_download_hh}")) {
                    $("#loading_data").html('{LANG.processing_data} <i class="fa fa-spinner fa-spin"></i>');
                    $.ajax({
                        url: location.href,
                        type: 'POST',
                        data: {
                            xuatexcel: 1,
                            fcode: $("#save_excel").attr('data-fcode')
                        },
                    })
                    .done(function(res) {
                        if (res['status'] == 'success') {
                            $(".notification_success").hide();
                            $(".notification_danger").hide();
                            $(".notification_success").show(500);
                            $(".notification_success").html(res['messages']);
                        } else {
                            $(".notification_danger").hide();
                            $(".notification_danger").show(500);
                            $(".notification_danger").html(res['messages']);
                        }
                        $("#loading_data").html('');
                    });
                }
            }
        });
    });
    function confirm_export (fcode) {
        $("#myModal .alert-warning").html('');
        $(".notification_success").html('');
        $(".notification_danger").html('');
        $(this).attr('disabled', true);
        $("#save_excel").attr('disabled', false);
        $(".confirm-export-excel").addClass("hidden");
        $.ajax({
            url: location.href,
            type: 'POST',
            data: {
                confirm_export_excel: 1,
                fcode: fcode
            },
        })
        .done(function(res) {
            if (res['status'] == 'success') {
                $(this).attr('disabled', false);
                $(".notification_success").hide();
                $(".notification_danger").hide();
                $("#save_excel").attr('data-fcode', fcode);
                $("#is_x4").val(res.is_x4);
                if (res.is_x4 == 1) {
                    if (res.total == 0) {
                        $(".confirm-export-excel").html("{LANG.no_data_goods}");
                        $("#save_excel").attr('disabled', true);
                    }
                    $(".confirm-export-excel").removeClass("hidden");
                    $("#myModal .alert-warning").addClass("hidden");
                } else {
                    if (res.total == 0) {
                        $(".no-data-goods").removeClass("hidden");
                        $("#save_excel").hide();;
                    }
                    $(".no_point").html(res.no_point);
                    $("#save_excel").html(res.icon_download + "{LANG.link_file_normal}");
                    $("#myModal .alert-warning").removeClass("hidden");
                    $("#myModal .alert-warning").html(res.value + res.note__download_novip);
                    if (res.disable == 1) {
                        $("#save_excel").attr('disabled', true);
                    }
                }
                $('#myModal').modal('show');
            } else {
                $(".notification_danger").hide();
                $(".notification_danger").show(500);
                $(".notification_danger").html(res['messages']);
            }
            $("#loading_data").html('');
        });
    }
</script>

<div id="myModal" class="modal fade" role="dialog">
    <div class="modal-dialog text-left">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header text-left">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">{LANG.notice}</h4>
            </div>
            <div class="modal-body">
                <div class="alert alert-warning"></div>
                <p class="confirm-export-excel hidden">{LANG.confirm_download_hh}</p>
                <div id="loading_data"></div>
                <div class="alert alert-success notification_success"></div>
                <div class="alert alert-danger notification_danger"></div>
            </div>
            <div class="modal-footer">
                <div>
                    <div class="no_point"></div>
                    <input type="hidden" id="is_x4" value=""/>
                    <p class="alert alert-danger no-data-goods hidden">{LANG.no_data_goods}</p>
                    <button type="button" class="btn btn-primary" data-fcode="" id="save_excel" name="xuatexcel" value="xuatexcel">{LANG.link_file_normal}</button>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="show_goods_subdivision" class="modal fade auto-height" role="dialog">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <div class="modal-title text-bold"><span id="name_nt"></span></div>
            </div>
            <div class="modal-body">
                <strong>{LANG.title_subdivision}: </strong>
                <div class="responsive_tb_custom responsive_tb_phlo">
                    <div class="table-responsive bidding_table">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>{LANG.number}</th>
                                    <th>{LANG.subdivision_code}</th>
                                    <th>{LANG.subdivision_name}</th>
                                    <th>{LANG.price_sub}</th>
                                    <th>{LANG.total_win_price_goods}</th>
                                    <th>{TG_TRUNGTHAU}</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody id="list_sub">

                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="table-responsive bidding_table" id="table__list_fails">
                    <strong>{LANG.list_fail}:</strong>
                    <table class="table table-bordered table-hover">
                        <thead>
                            <th>{LANG.number}</th>
                            <th>{SODDKD}</th>
                            <th>{LANG.bidder_name}</th>
                            <th>{LANG.reason_fail}</th>
                            <th>{TG_TRUNGTHAU}</th>
                        </thead>
                        <tbody id="subdivision_list_fails">

                        </tbody>
                    </table>
                </div>

                <div class="responsive_tb_custom">
                    <!-- BEGIN: not_medicine1 -->
                    <strong>{LANG.title_goods}:</strong>
                    <!-- END: not_medicine1 -->

                    <!-- BEGIN: yes_medicine1 -->
                    <strong>{LANG.list_medecine}:</strong>
                    <!-- END: yes_medicine1 -->
                    <table class="table">
                        <thead>
                            <tr>
                                <!-- BEGIN: not_medicine -->
                                <th>{LANG.number}</th>
                                <th class="w150">{LANG.good_name}</th>
                                <!-- BEGIN: is_old -->
                                <th class="w150">{LANG.code_goods_new}</th>
                                <!-- END: is_old -->
                                <!-- BEGIN: is_not_old -->
                                <th class="w150">{LANG.code_goods}</th>
                                <th>{LANG.label_good}</th>
                                <th>{LANG.ma_hh}</th>
                                <th>{LANG.title_manufacturer}</th>
                                <!-- END: is_not_old -->
                                <th>{LANG.mass}</th>
                                <th>{LANG.unit}</th>
                                <th>{LANG.desc}</th>
                                <th>{LANG.origin}</th>
                                <th>{LANG.gia_dongia}</th>
                                <th>{LANG.thanhtien}</th>
                                <th>{LANG.note}</th>
                                <!-- END: not_medicine -->

                                <!-- BEGIN: yes_medicine -->
                                <th>{LANG.number}</th>
                                <th>{LANG.subdivision_code}</th>
                                <th>{LANG.medicineCode}</th>
                                <th>{LANG.tenThuoc}</th>
                                <th>{LANG.tenHoatChat}</th>
                                <th>{LANG.nongDo}</th>
                                <th>{LANG.gdklh}</th>
                                <th>{LANG.duongDung}</th>
                                <th>{LANG.dangBaoChe}</th>
                                <th>{LANG.csSanXuat}</th>
                                <th>{LANG.nuocSanXuat}</th>
                                <th>{LANG.quyCach}</th>
                                <th>{LANG.unit}</th>
                                <th>{LANG.good_num}</th>
                                <th>{LANG.gia_dongia}</th>
                                <th>{LANG.thanhtien}</th>
                                <th>{LANG.groupMedicine}</th>
                                <!-- END: yes_medicine -->
                            </tr>

                        </thead>
                        <tbody id="tbody__subdivision">

                        </tbody>
                    </table>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" data-dismiss="modal" class="btn">{LANG.close}</button>
            </div>
        </div>
    </div>
</div>

<input type="hidden" value="{DATA.is_medicine}" id="is_medicine">
<!-- Modal -->
<div id="modal-product-reference" class="modal fade" role="dialog">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <p class="modal-title">{LANG.title_product_reference}</p>
            </div>
            <div class="modal-body" id="modal-product-reference-body">
                <p><i class='fa fa-spinner fa-spin fa-fw' aria-hidden='true'></i> {LANG.loading}</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">{LANG.close}</button>
            </div>
        </div>
    </div>
</div>
<div id="trudiem"></div>
<script type="text/javascript">
    <!-- BEGIN: countdown -->startTimer(600, $(".countdown"));<!-- END: countdown -->
    $("#table__list_fails").hide();

    function search_goods(name = '', solicitor_id = 0, resultid = 0) {
        // Hiển thị modal sau khi xử lý xong
        $('#modal-product-reference').modal({
            show: true
        });

        $("#modal-product-reference-table-1-body").html(`<tr id="1">
            <td colspan="8">
                <i class='fa fa-spinner fa-spin fa-fw' aria-hidden='true'></i> {LANG.loading}
            </td>
        </tr>`);

        $("#modal-product-reference-table-2-body").html(`<tr id="1">
            <td colspan="8">
                <i class='fa fa-spinner fa-spin fa-fw' aria-hidden='true'></i> {LANG.loading}
            </td>
        </tr>`);

        $("#modal-product-reference-table-3-body").html(`<tr id="1">
            <td colspan="5">
                <i class='fa fa-spinner fa-spin fa-fw' aria-hidden='true'></i> {LANG.loading}
            </td>
        </tr>`);
        $.ajax({
            url: location.href,
            type: 'POST',
            data: {
                'load_product_reference': 1,
                'name' : name,
                'solicitor_id' : solicitor_id,
                'resultid' : resultid,
            },
            cache: false,  // Tắt cache
            success: function(response) {
                $("#modal-product-reference-body").html(response);
            }
        });
    }

    function view_price(id, result_id) {
        $(".view__price" + id).append("<i class='fa fa-spinner fa-spin fa-fw' aria-hidden='true'></i> {LANG.loading}");
        $.ajax({
            url: window.location.href,
            type: 'POST',
            data: {
                'view_price': 1,
                'id': id,
                'result_id': result_id,
            },
            success: function (response) {
                if (response['status'] == 'success') {
                    result = JSON.parse(response.mess);
                    if (result['khongdudiem'] == 1) {
                        alert("{LANG.point_miss_goods}");
                    } else {
                        $html = '';
                        $html += '<td data-label="{LANG.so_tbmt}"> <span class="so_tbmt_' + id +'">' + result['data']['bid_price'] + '</span></td>';
                        $html += '<td data-label="{LANG.win_price}"><span class="win_price_' + id +'"></span><a href=' + result['linkgoithau'] + '>' + result['tbmt'] + '</a></td>';
                        $(".view__price" + id).closest('tr').append($html);
                        $(".view__price" + id).parent().remove();
                        $("#trudiem").html(result['notifi']);
                        $("#trudiem").slideDown(500);
                        setTimeout(function() {
                            $("#trudiem").slideUp(500);
                        }, 2000);
                    }
                } else {
                    if (response['res'] == 'empty_data_result') {
                        alert('{LANG.empty_data_result}');
                    }

                    if (response['res'] == 'empty_data_good') {
                        alert('{LANG.empty_data_good}');
                    }

                    if (response['res'] == 'err_update_data') {
                        alert('{LANG.error_download_good}');
                    }
                    $(".view__price" + id).find('.fa-spinner').remove();
                }
            }
        })
    }

    $(document).ready(function($) {
        $(".view__goods").click(function() {
            list = $(this).closest("td").find(".data-sub").text().trim();
            name = $(this).attr('data-name');

            list = JSON.parse(list);
            $("#name_nt").text(name);
            $html = '';
            $("#tbody__subdivision").html('');
            let arrLotNo = [];
            list.map(function(val, index) {
                arrLotNo.push(val['lotno']);
            });

            list.map(function(val, index) {
                let listGd;
                if (val['goodslist'] != '') {
                    goodslist = JSON.parse(val['goodslist']);
                    if (goodslist['dsHhKq'] != undefined) {
                        listGd = [];
                        Object.keys(goodslist['dsHhKq']).forEach(function(key) {
                            if (arrLotNo.includes(goodslist['dsHhKq'][key]['lotNo'])) {
                                listGd[goodslist['dsHhKq'][key]['lotNo']] = goodslist['dsHhKq'][key]['dsHH'];
                            }
                        });

                        listGd = JSON.stringify(listGd[val['lotno']]);
                    } else {
                        listGd = val['goodslist'];
                    }
                }

                $html += `<tr>
                    <td class="font-weight text-center">${val['number']}</td>
                    <td>
                        <p>
                            ${val['lotno']}
                        </p>
                    </td>
                    <td>${val['lotname']}</td>
                    <td class="text-center">${val['lotprice']}</td>
                    <td class="text-center">${val['lot_finalprice']}</td>
                    <td class="text-center">${val['cperiodunit']}</td>
                    <td>
                        <a href="javascript:void(0)" class="view__list_goods" lotno="${val['lotno']}"  data-fails='${val['list_fail']}'>{LANG.view_goods}<span class="data-goods hidden">${listGd ?? ""}</span> <i class="fa fa-eye" aria-hidden="true"></i></a>
                    </td>
                </tr>`;
            });

            $("#list_sub").html($html);

            // Click vào phân lô dòng đầu tiên
            viewDetail($(".view__list_goods").eq(0), $(".view__list_goods").eq(0).find(".data-goods").text().trim(), $(".view__list_goods").eq(0).attr("data-fails"));

            $(".view__list_goods").click(function() {
                goods_list = $(this).find('.data-goods').text().trim();
                list_fails = $(this).attr('data-fails');
                viewDetail($(this), goods_list, list_fails);
            });;
        });
    });

    function viewDetail($_this, goods_list, list_fails) {
        $('.is_active_table--bg').removeClass('is_active_table--bg');
        $_this.closest('tr').addClass('is_active_table--bg');
        $html = '';
        if (goods_list != '') {
            goods_list = JSON.parse(goods_list);
            if ($("#is_medicine").val() == "1") {
                goods_list.map(function(val, index) {
                    $html += `<tr class='bg__good'>
                    <td class="text-center">${index + 1}</td>
                    <td class="text-center">${val['lotNo']}</td>
                    <td class="text-center">${val['medicineCode']}</td>
                    <td class="text-center">${val['tenThuoc']}</td>
                    <td class="text-center">${val['tenHoatChat']}</td>
                    <td class="text-center">${val['nongDo']}</td>
                    <td class="text-center">${val['gdklh']}</td>
                    <td class="text-center">${val['duongDung']}</td>
                    <td class="text-center">${val['dangBaoChe']}</td>
                    <td class="text-center">${val['csSanXuat']}</td>
                    <td class="text-center">${val['nuocSanXuat']}</td>
                    <td class="text-center">${val['quyCach']}</td>
                    <td class="text-center">${val['uom']}</td>
                    <td class="text-center">${val['quantity']}</td>
                    <td class="text-center">${val['donGia']}</td>
                    <td class="text-center">${val['amount']}</td>
                    <td class="text-center">${val['groupMedicine']}</td></tr>`;
                });
            } else {
                goods_list.map(function(val, index) {
                $html += `<tr class='bg__good'>
                        <td class="text-center">${index + 1}</td>
                        <td>
                            <div class="wrap__text">
                               ${val['name']}
                            </div>
                        </td>
                        <!-- BEGIN: hh_js_is_old -->
                        <td class="text-center">
                           ${val['code'] ?? ''}
                        </td>
                        <!-- END: hh_js_is_old -->
                        <!-- BEGIN: hh_js_is_not_old -->
                        <td class="text-center">
                            <div class="wrap__text">
                                ${val['codeGood'] ?? val['code']}
                            </div>
                        </td>
                        <td>
                            <div class="wrap__text">
                                ${val['lableGood'] ?? ''}
                            </div>
                            </td>
                        <td>
                            <div class="wrap__text">
                                ${val['code'] ?? ''}
                            </div>
                        </td>
                        <td>
                            <div class="wrap__text">
                                ${val['manufacturer'] ?? ''}
                            </div>
                        </td>
                        <!-- END: hh_js_is_not_old -->
                        <td class="text-center">${val['quantity'] ?? val['originQty']}</td>
                        <td class="text-center">${val['unit'] ?? val['uom']}</td>
                        <td>${val['description']}</td>
                        <td>${val['origin'] ?? val['origin']}</td>
                        <td>${val['priceUnit'] ?? val['bidPrice'].toLocaleString('vi-VN')}</td>
                        <td>${val['amount'].toLocaleString('vi-VN')}</td>
                        <td>
                            <div class="wrap__text">
                               ${val['note'] ?? ''}
                            </div>
                        </td>
                    </tr>`;
                });
            }
            $("#tbody__subdivision").html($html);
        } else {
            $("#tbody__subdivision").html(`<tr>
                <td colspan="10">
                    <p class="alert alert-warning">` + "{LANG.no_data_goods}" + `</p>
                </td>
            </tr>`);
        }

        if (list_fails != '') {
            $("#table__list_fails").fadeIn(500);;
            list_fails = JSON.parse(list_fails);
            html = '';
            for (i = 0; i < list_fails.length; i++) {
                val = list_fails[i]['info_old'];
                if (val['link'] == '') {
                    $link = val['orgFullname'];
                } else {
                    $link = '<a href="' + val['link'] + '">' + val['orgFullname'] + '</a>';
                }

                val['cperiodText'] = (val['cperiodText'] == null) ? '' : val['cperiodText'];

                html += `
                    <tr class='bg__good'>
                        <td class="text-center">${i+1}</td>
                        <td class="text-center">${val['orgCode']}</td>
                        <td>
                            ${$link}
                        </td>
                        <td>${val['reason']}</td>
                        <td class="text-center">${val['cperiodText']}</td>
                    </tr>
                `;
            }
            $("#subdivision_list_fails").html(html);
        } else {
            $("#subdivision_list_fails").html("");
            $("#table__list_fails").hide(100);;
        }
    }
</script>
<script type="text/javascript">
    var checkess='{NV_CHECK_SESSION}';
    link_reformat();
    function link_reformat() {
        $(".is_points span").not(".is_ie").each(function() {
            var a = $(this).parent(),
                c = void 0 !== a.attr("href") ? a.attr("href") : "",
                f = void 0 !== a.attr("onclick") ? a.attr("onclick") : "",
                e = void 0 !== a.attr("target") ? a.attr("target") : "_self",
                d = $(this).text(),
                b = a.next(),
                g = '{LANG.viplink}',
                cl = 'primary',
                m = 'fa-snowflake-o';
            a.addClass("disable-link");
            $(this).is(".is_fast") ? b.prepend(addA(cl, c, e, g, m)) : b.prepend(addA("default", c, e, '{LANG.origlink}', m));
        })
    }
    function addA(cl, url, target, name, m) {
        return '<a class="btn btn-' + cl + ' btn-xs" href="' + url + '" target="' + target + '"><em class="fa ' + m + '"></em> ' + name + "</a>"
    }

    /*Phân trang*/
    var table ='#mytable';

    loadPagination();

    function loadPagination(num_default = 100) {
        $(".pagination__main").html('');
        var trnum = 0;
        var maxRows = parseInt(num_default);
        var totalRows = $(table+' tbody tr').length;
        $(table +' tr:gt(0)').each(function() {
            trnum++
            if(trnum > maxRows){
                $(this).hide();
            }else{
                $(this).show();
            }
        });

        if(totalRows > maxRows){
            var pagenum = Math.ceil(totalRows/maxRows);
            for (var i = 1; i <= pagenum;) {
                $(".pagination__main").append('<li data-page="'+i+'">\<a href="javascript:void(0)" class="pagination__link">'+ i++ +'<span class="sr-only">(current)</span></span>\</li>').show();
            }
        }
        $('.pagination__main li:first-child').addClass('active');
        $('.pagination__main li').on('click', function(){
            var pageNum = $(this).attr('data-page');
            var trIndex = 0;
            $('.pagination__main li').removeClass('active');
            $(this).addClass('active');
            $(table+' tr:gt(0)').each(function() {
                trIndex++;
                if(trIndex > (maxRows*pageNum) || trIndex <= ((maxRows*pageNum) - maxRows)){
                    $(this).hide();
                }else{
                    $(this).show();
                }
            });
        });

        $(".pagination__link").click(function() {
            $("html, body").animate({ scrollTop: $("#mytable").offset().top - 30}, 200);
        });
    }
</script>
<script type="text/javascript">
    $(document).ready(function () {
        var otable = $('#table_one').DataTable({
            // "ordering": false,
            "timeout": 300000,
            "language": {
                "lengthMenu": "{LANG.datatable_lengthMenu}",
                "search": "{LANG.datatable_search}",
                "info": "{LANG.datatable_info}",
                "zeroRecords": "{LANG.datatable_paginate_zeroRecords}",
                "infoFiltered": "{LANG.datatable_paginate_infoFiltered}",
                "infoEmpty": "{LANG.datatable_paginate_infoEmpty}",
                "paginate": {
                    "first": "{LANG.datatable_paginate_first}",
                    "last": "{LANG.datatable_paginate_last}",
                    "next": "{LANG.datatable_paginate_next}",
                    "previous": "{LANG.datatable_paginate_previous}",
                },
            }
        });

        $("select[name='table_one_length']").addClass("form-control");
        $("input[aria-controls='table_one']").addClass("form-control");
    });
</script>
<script type="text/javascript">
const scrollWrapper = document.querySelector('.scroll-wrapper');
const scrollContent = document.querySelector('.scroll-content');
const scrollbarTop = document.querySelector('.scrollbar-top');
const scrollbarContent = document.querySelector('.scrollbar-content');

// Hàm kiểm tra kích thước màn hình và khởi tạo sự kiện cuộn
function initScrollSync() {
    if (window.matchMedia('(min-width: 768px)').matches) {
        // Đặt chiều rộng cho thanh cuộn trên
        scrollbarContent.style.width = scrollContent.scrollWidth + 'px';

        // Đồng bộ thanh cuộn
        scrollbarTop.addEventListener('scroll', syncScroll);
        scrollContent.addEventListener('scroll', syncScroll);
    } else {
        // Gỡ bỏ sự kiện khi màn hình nhỏ hơn 768px
        scrollbarTop.removeEventListener('scroll', syncScroll);
        scrollContent.removeEventListener('scroll', syncScroll);
    }
}

// Hàm đồng bộ cuộn ngang giữa thanh cuộn trên và nội dung bảng
function syncScroll(e) {
    if (e.target === scrollbarTop) {
        scrollContent.scrollLeft = scrollbarTop.scrollLeft;
    } else if (e.target === scrollContent) {
        scrollbarTop.scrollLeft = scrollContent.scrollLeft;
    }
}

// Gọi hàm khởi tạo khi tải trang
initScrollSync();

// Kiểm tra lại khi thay đổi kích thước màn hình
window.addEventListener('resize', initScrollSync);
</script>
<style type="text/css">
    .modal-lg {
        width: 93% !important;
    }

    #table_one_filter {
        display: inline-block;
        float: right;
    }

    #table_one_length {
        display: inline-block;
    }
</style>
<!-- END: main -->

<!-- BEGIN: show_good_reference -->
    <div class="box1">
        <p><strong>{SOLICTOR_TITLE} <span class="num_data_1 text-warning">({NUM_DATA_1})</span>:</strong></p>

        <div class="responsivetb">
            <table class="table table-bordered" id="modal-product-reference-table-1">
                <thead>
                    <tr>
                        <th class="text-center">{LANG.number}</th>
                        <th class="text-center">{LANG.good_name}</th>
                        <th class="text-center">{LANG.code_goods_new}</th>
                        <th class="text-center">{LANG.unit}</th>
                        <th class="text-center">{LANG.desc}</th>
                        <th class="text-center">{LANG.producing_country}</th>
                        <th class="text-center">{LANG.win_price}</th>
                        <th class="text-center" width="10%">{LANG.so_tbmt}</th>
                    </tr>
                </thead>
                <tbody id="modal-product-reference-table-1-body">
                    <!-- BEGIN: good1 -->
                        <!-- BEGIN: loop -->
                        <tr>
                            <td class="text-center" data-label="{LANG.number}"><span class="stt">{ROW1.stt}</span></td>
                            <td data-label="{LANG.good_name}">{ROW1.goods_name}</td>
                            <td data-label="{LANG.code_goods_new}">{ROW1.sign_product}</td>
                            <td data-label="{LANG.unit}">{ROW1.unit_cal}</td>
                            <td data-label="{LANG.desc}">{ROW1.description}</td>
                            <td data-label="{LANG.producing_country}">{ROW1.origin}</td>
                            <!-- BEGIN: show_col1 -->
                            <td data-label="{LANG.win_price}">{ROW1.bid_price}</td>
                            <td data-label="{LANG.so_tbmt}"><a href="{ROW1.link_tbmt}" title="{ROW1.goods_name}">{ROW1.so_tbmt}</a></td>
                            <!-- END: show_col1 -->

                            <!-- BEGIN: show_col2 -->
                            <td colspan="2" class="td__reg" data-label="{LANG.win_price}"><a href="javascript:void(0);" class="view__price{ROW1.id}" title="{ROW1.goods_name}" onclick="view_price({ROW1.id}, {ROW1.result_id})">{TB_POINT}</a><p>{REG}</p></td>
                            <!-- END: show_col2 -->
                        </tr>
                        <!-- END: loop -->
                    <!-- END: good1 -->

                    <!-- BEGIN: no_good1 -->
                    <tr>
                        <td colspan="8"><strong class="red">{LANG.quote1}</strong>
                        </td>
                    </tr>
                    <!-- END: no_good1 -->
                </tbody>
            </table>

            <!-- BEGIN: show_link_1 -->
            <div class="text-center">
                <a target="_blank" id="link1" href="{LINK_HH_1}">{LANG.see_more}...</a>
            </div>
            <!-- END: show_link_1 -->
        </div>
    </div>

    <div class="box2">
        <p><strong>{SOLICTOR_TITLE_2} <span class="num_data_2 text-warning">({NUM_DATA_2})</span>:</strong></p>
        <div class="responsivetb">
            <table class="table table-bordered" id="modal-product-reference-table-2">
                <thead>
                    <tr>
                        <th class="text-center">{LANG.number}</th>
                        <th class="text-center">{LANG.good_name}</th>
                        <th class="text-center">{LANG.code_goods_new}</th>
                        <th class="text-center">{LANG.unit}</th>
                        <th class="text-center">{LANG.desc}</th>
                        <th class="text-center">{LANG.producing_country}</th>
                        <th class="text-center">{LANG.win_price_number}</th>
                        <th class="text-center" width="10%">{LANG.so_tbmt}</th>
                    </tr>
                </thead>
                <tbody id="modal-product-reference-table-2-body">
                    <!-- BEGIN: good2 -->
                        <!-- BEGIN: loop -->
                        <tr>
                            <td class="text-center" data-label="{LANG.number}"><span class="stt">{ROW2.stt}</span></td>
                            <td data-label="{LANG.good_name}">{ROW2.goods_name}</td>
                            <td data-label="{LANG.code_goods_new}">{ROW2.sign_product}</td>
                            <td data-label="{LANG.unit}">{ROW2.unit_cal}</td>
                            <td data-label="{LANG.desc}">{ROW2.description}</td>
                            <td data-label="{LANG.producing_country}">{ROW2.origin}</td>
                            <!-- BEGIN: show_col1 -->
                            <td data-label="{LANG.win_price_number}">{ROW2.bid_price}</td>
                            <td data-label="{LANG.so_tbmt}"><a href="{ROW2.link_tbmt}" title="{ROW2.goods_name}">{ROW2.so_tbmt}</a></td>
                            <!-- END: show_col1 -->

                            <!-- BEGIN: show_col2 -->
                            <td colspan="2" class="td__reg" data-label="{LANG.win_price}"><a href="javascript:void(0);" class="view__price{ROW2.id}" title="{ROW2.goods_name}" onclick="view_price({ROW2.id}, {ROW2.result_id})">{TB_POINT}</a><p>{REG}</p></td>
                            <!-- END: show_col2 -->
                        </tr>
                        <!-- END: loop -->
                    <!-- END: good2 -->

                    <!-- BEGIN: no_good2 -->
                    <tr>
                        <td colspan="8"><strong class="red">{LANG.quote2}</strong>
                        </td>
                    </tr>
                    <!-- END: no_good2 -->
                </tbody>
            </table>

            <!-- BEGIN: show_link_2 -->
            <div class="text-center">
                <a target="_blank" id="link2" href="{LINK_HH_2}">{LANG.see_more}...</a>
            </div>
            <!-- END: show_link_2 -->
        </div>
    </div>

    <div class="box3">
        <p><strong>{SOLICTOR_TITLE_3} <span class="num_data_3 text-warning">({NUM_DATA_3})</span>:</strong></p>
        <div class="responsivetb">
            <table class="table table-bordered" id="modal-product-reference-table-3">
                <thead>
                    <tr>
                        <th class="text-center">{LANG.number}</th>
                        <th class="text-center">{LANG.good_name}</th>
                        <th class="text-center">{LANG.generic}</th>
                        <th class="text-center">{LANG.producing_country}</th>
                        <th class="text-center">{LANG.win_price}</th>
                    </tr>
                </thead>
                <tbody id="modal-product-reference-table-3-body">
                    <!-- BEGIN: good3 -->
                        <!-- BEGIN: loop -->
                        <tr>
                            <td class="text-center" data-label="{LANG.number}"><span class="stt">{ROW3.stt}</span></td>
                            <td data-label="{LANG.good_name}">{ROW3.name}</td>
                            <td data-label="{LANG.generic}">{ROW3.generic}</td>
                            <td data-label="{LANG.producing_country}">{ROW3.producing_country}</td>

                            <!-- BEGIN: show_col1 -->
                            <td data-label="{LANG.win_price}">{ROW3.price_bid}</td>
                            <!-- END: show_col1 -->

                            <!-- BEGIN: show_col2 -->
                            <td class="td__reg" data-label="{LANG.win_price}">{REG}</td>
                            <!-- END: show_col2 -->
                        </tr>
                        <!-- END: loop -->
                    <!-- END: good3 -->

                    <!-- BEGIN: no_good3 -->
                    <tr>
                        <td colspan="5"><strong class="red">{LANG.quote3}</strong>
                        </td>
                    </tr>
                    <!-- END: no_good3 -->
                </tbody>
            </table>
        </div>
    </div>
<!-- END: show_good_reference -->
