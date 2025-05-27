<div class="card border-primary border-3 border-bottom-0 border-start-0 border-end-0">
    <div class="card-header fs-5 fw-medium">{$DATA.caption}</div>
    <div class="card-body pt-4">
        {if !empty($ERROR)}
        <div class="alert alert-warning">
            {$ERROR}
        </div>
        {/if}

        {if $HAS_DATA}
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead>
                    <tr>
                        <th width="10px" class="text-center">&nbsp;</th>
                        <th>{$LANG->getModule('weight_sign')}</th>
                        <th>{$LANG->getModule('currency')}</th>
                        <th>{$LANG->getModule('weight_convention')} <em class="fa fa-info-circle text-info"
                                data-toggle="tooltip" title=""
                                data-original-title="{$LANG->getModule('weight_convention_note')}">&nbsp;</em></th>
                        <th>{$LANG->getModule('round')}</th>
                        <th class="text-center">{$LANG->getModule('function')}</th>
                    </tr>
                </thead>
                <tfoot>
                    <tr>
                        <td colspan="6">
                            <div class="d-flex gap-3">
                                <a href="#" id="checkall" class="text-decoration-none">
                                    <i class="fa fa-check-square-o"></i> {$LANG->getModule('prounit_select')}
                                </a>
                                <a href="#" id="uncheckall" class="text-decoration-none">
                                    <i class="fa fa-square-o"></i> {$LANG->getModule('prounit_unselect')}
                                </a>
                                <a href="#" id="delall" class="text-decoration-none">
                                    <i class="fa fa-trash-o"></i> {$LANG->getModule('prounit_del_select')}
                                </a>
                            </div>
                        </td>
                    </tr>
                </tfoot>
                <tbody>
                    {foreach from=$ROWS item=row}
                    <tr>
                        <td><input type="checkbox" class="ck" value="{$row.id}" /></td>
                        <td>{$row.code}</td>
                        <td>{$row.title}</td>
                        <td>1 {$row.code} = {$row.exchange} {$WEIGHT_UNIT}</td>
                        <td>{$row.round}</td>
                        <td class="text-center">
                            <a href="{$row.link_edit}" class="btn btn-primary btn-xs">
                                <i class="fa-solid fa-edit"></i>
                            </a>
                            <a href="{$row.link_del}" class="btn btn-danger btn-xs delete">
                                <i class="fa-solid fa-trash"></i>
                            </a>
                        </td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>
        {/if}

        <form class="form-horizontal mt-4" action="" method="post">
            <input type="hidden" name="savecat" value="1" />
            <div class="row mb-3">
                <label class="col-sm-3 col-xxl-4 col-form-label text-sm-end">
                    {$LANG->getModule('weight_sign')} <span class="text-danger">*</span>
                </label>
                <div class="col-sm-8 col-lg-6 col-xxl-8">
                    <input class="form-control" name="code" type="text" value="{$DATA.code}" maxlength="255" required
                        oninvalid="setCustomValidity('{$LANG->getModule('error_required')}')"
                        oninput="setCustomValidity('')" />
                </div>
            </div>

            <div class="row mb-3">
                <label class="col-sm-3 col-xxl-4 col-form-label text-sm-end">
                    {$LANG->getModule('currency')} <span class="text-danger">*</span>
                </label>
                <div class="col-sm-8 col-lg-6 col-xxl-8">
                    <input class="form-control" name="title" type="text" value="{$DATA.title}" maxlength="255" required
                        oninvalid="setCustomValidity('{$LANG->getModule('error_required')}')"
                        oninput="setCustomValidity('')" />
                </div>
            </div>

            <div class="row mb-3">
                <label class="col-sm-3 col-xxl-4 col-form-label text-sm-end">
                    {$LANG->getModule('weight_convention')} <span class="text-danger">*</span>
                </label>
                <div class="col-sm-8 col-lg-6 col-xxl-8">
                    <div class="input-group">
                        <input class="form-control" name="exchange" type="text" value="{$DATA.exchange}" maxlength="255"
                            required oninvalid="setCustomValidity('{$LANG->getModule('error_required')}')"
                            oninput="setCustomValidity('')" />
                        <span class="input-group-text">
                            <em class="fa fa-info-circle text-info" data-toggle="tooltip" title=""
                                data-original-title="{$LANG->getModule('weight_convention_note')}">&nbsp;</em>
                        </span>
                    </div>
                </div>
            </div>

            <div class="row mb-3">
                <label class="col-sm-3 col-xxl-4 col-form-label text-sm-end">
                    {$LANG->getModule('round')}
                </label>
                <div class="col-sm-8 col-lg-6 col-xxl-8">
                    <select class="form-select" name="round">
                        {foreach from=$ROUND_OPTIONS item=round}
                        <option value="{$round.round1}" {if $round.selected}selected{/if}>{$round.round2}</option>
                        {/foreach}
                    </select>
                </div>
            </div>

            <div class="row">
                <div class="col-sm-8 offset-sm-3 offset-xxl-4">
                    <button type="submit" class="btn btn-primary">
                        <i class="fa-solid fa-save"></i> {$LANG->getModule('prounit_save')}
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<script type="text/javascript">
    $(function () {
        $('#checkall').click(function () {
            $('input:checkbox').each(function () {
                $(this).prop('checked', true);
            });
        });

        $('#uncheckall').click(function () {
            $('input:checkbox').each(function () {
                $(this).prop('checked', false);
            });
        });

        $('#delall').click(function () {
            nvConfirm('{$LANG->getModule('prounit_del_confirm')}', () => {
                var listall = [];
                $('input.ck:checked').each(function () {
                    listall.push($(this).val());
                });
                if (listall.length < 1) {
                    nvAlert('{$LANG->getModule('prounit_del_no_items')}', 'error');
                    return false;
                }
                $.ajax({
                    type: 'POST',
                    url: '{$URL_DEL}',
                    data: 'listall=' + listall,
                    success: function (data) {
                        window.location = '{$URL_DEL_BACK}';
                    }
                });
            });
        });

        $('a.delete').click(function (event) {
            event.preventDefault();
            nvConfirm('{$LANG->getModule('prounit_del_confirm')}', () => {
                var href = $(this).attr('href');
                $.ajax({
                    type: 'POST',
                    url: href,
                    data: '',
                    success: function (data) {
                        window.location = '{$URL_DEL_BACK}';
                    }
                });
            });
        });
    });
</script>