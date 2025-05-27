<div class="card border-primary border-3 border-bottom-0 border-start-0 border-end-0">
    <div class="card-header fs-5 fw-medium">{$LANG->getModule('review')}</div>
    <div class="card-body pt-4">
        <div class="well">
            <form action="{$smarty.const.NV_BASE_ADMINURL}index.php" method="get">
                <input type="hidden" name="{$smarty.const.NV_LANG_VARIABLE}" value="{$smarty.const.NV_LANG_DATA}" />
                <input type="hidden" name="{$smarty.const.NV_NAME_VARIABLE}" value="{$MODULE_NAME}" />
                <input type="hidden" name="{$smarty.const.NV_OP_VARIABLE}" value="{$OP}" />
                <div class="row">
                    <div class="col-sm-6 col-md-4 mb-3">
                        <input type="text" class="form-control" value="{$SEARCH.keywords}" name="keywords"
                            placeholder="{$LANG->getModule('search_key')}" />
                    </div>
                    <div class="col-sm-6 col-md-4 mb-3">
                        <select class="form-select" name="status">
                            <option value="-1">{$LANG->getModule('status')}</option>
                            {foreach from=$STATUS_OPTIONS item=STATUS}
                            <option value="{$STATUS.key}" {if $STATUS.selected}selected="selected" {/if}>{$STATUS.value}
                            </option>
                            {/foreach}
                        </select>
                    </div>
                    <div class="col-sm-6 col-md-4 mb-3">
                        <button type="submit" class="btn btn-primary">
                            <i class="fa fa-search"></i> {$LANG->getModule('search')}
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <form id="review-form">
            <div class="table-responsive">
                <table class="table table-striped table-bordered table-hover">
                    <thead>
                        <tr>
                            <th class="w50 text-center">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="check-all" />
                                </div>
                            </th>
                            <th>{$LANG->getModule('name')}</th>
                            <th>{$LANG->getModule('review_sender')}</th>
                            <th class="text-center w100">{$LANG->getModule('review_rating')}</th>
                            <th>{$LANG->getModule('search_bodytext')}</th>
                            <th class="w150">{$LANG->getModule('review_add_time')}</th>
                            <th class="w150">{$LANG->getModule('status')}</th>
                            <th class="w100 text-center">{$LANG->getModule('function')}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach from=$REVIEWS item=REVIEW}
                        <tr id="row_{$REVIEW.review_id}">
                            <td class="text-center">
                                <div class="form-check">
                                    <input class="form-check-input review-checkbox" type="checkbox" name="idcheck[]"
                                        value="{$REVIEW.review_id}" />
                                </div>
                            </td>
                            <td>
                                <a href="{$REVIEW.link_product}" target="_blank">{$REVIEW.title}</a>
                            </td>
                            <td>{$REVIEW.sender}</td>
                            <td class="text-center">{$REVIEW.rating}</td>
                            <td>{$REVIEW.content}</td>
                            <td>{$REVIEW.add_time}</td>
                            <td>{$REVIEW.status}</td>
                            <td class="text-center">
                                <button type="button" class="btn btn-danger btn-xs"
                                    onclick="nvDelReview({$REVIEW.review_id}, '{$LANG->getModule('delete_confirm')}')">
                                    <i class="fa fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                        {/foreach}
                    </tbody>
                    {if !empty($PAGES)}
                    <tfoot>
                        <tr>
                            <td colspan="8" class="text-center">
                                {$PAGES}
                            </td>
                        </tr>
                    </tfoot>
                    {/if}
                </table>
            </div>
            <div class="row mt-3">
                <div class="col-sm-6">
                    <div class="d-flex align-items-center">
                        <select class="form-select" id="action" name="action" style="width: 200px;">
                            <option value="delete">{$LANG->getModule('prounit_del_select')}</option>
                            <option value="review_status_1">{$LANG->getModule('review_status_1')}</option>
                            <option value="review_status_0">{$LANG->getModule('review_status_0')}</option>
                        </select>
                        <button type="button" class="btn btn-primary ms-2" onclick="nvReviewAction()">
                            {$LANG->getModule('action')}
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<script>
    $(document).ready(function () {
        // Xử lý check all
        $('#check-all').change(function () {
            $('.review-checkbox').prop('checked', $(this).prop('checked'));
        });

        // Khi click vào các checkbox con, kiểm tra nếu tất cả đều được check thì check luôn checkbox cha
        $('.review-checkbox').change(function () {
            if ($('.review-checkbox:checked').length == $('.review-checkbox').length) {
                $('#check-all').prop('checked', true);
            } else {
                $('#check-all').prop('checked', false);
            }
        });
    });

    // Hàm xóa một review
    function nvDelReview(review_id, msg) {
        if (confirm(msg)) {
            $.ajax({
                type: 'POST',
                url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=review&nocache=' + new Date().getTime(),
                data: 'delete=1&review_id=' + review_id,
                success: function (data) {
                    if (data['status'] == 'OK') {
                        $('#row_' + review_id).fadeOut();
                        location.reload();
                    } else {
                        alert(data['message']);
                    }
                }
            });
        }
    }

    // Hàm xử lý các action (xóa nhiều, thay đổi trạng thái)
    function nvReviewAction() {
        var action = $('#action').val();
        var listid = [];
        $('input[name="idcheck[]"]:checked').each(function () {
            listid.push($(this).val());
        });

        if (listid.length < 1) {
            alert('{$LANG->getModule('please_select_one')}');
            return;
        }

        if (action == 'delete') {
            if (confirm('{$LANG->getModule('delete_confirm')}')) {
                $.ajax({
                    type: 'POST',
                    url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=review&nocache=' + new Date().getTime(),
                    data: 'delete_multiple=1&listid=' + listid,
                    success: function (data) {
                        if (data['status'] == 'OK') {
                            location.reload();
                        } else {
                            alert(data['message']);
                        }
                    }
                });
            }
        } else if (action == 'review_status_0' || action == 'review_status_1') {
            var status = action.split('_')[2];
            $.ajax({
                type: 'POST',
                url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=review&nocache=' + new Date().getTime(),
                data: 'change_status_review=1&status=' + status + '&listid=' + listid,
                success: function (data) {
                    if (data['status'] == 'OK') {
                        location.reload();
                    } else {
                        alert(data['message']);
                    }
                }
            });
        }
    }
</script>