<div class="card border-primary border-3 border-bottom-0 border-start-0 border-end-0">
    <div class="card-header fs-5 fw-medium">{if
        !empty($DATA.id)}{$LANG->getModule('money_edit')}{else}{$LANG->getModule('money_add')}{/if}</div>
    <div class="card-body pt-4">
        {if !empty($ERROR)}
        <div class="alert alert-warning">
            {$ERROR}
        </div>
        {/if}

        {if !empty($ROWS)}
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead>
                    <tr>
                        <th width="10px" class="text-center">&nbsp;</th>
                        <th>{$LANG->getModule('money_name')}</th>
                        <th>{$LANG->getModule('currency')}</th>
                        <th>{$LANG->getModule('weight_sign')}</th>
                        <th>{$LANG->getModule('exchange')}</th>
                        <th>{$LANG->getModule('round')}</th>
                        <th width="120px" class="text-center">{$LANG->getModule('function')}</th>
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
                        <td>{$row.currency}</td>
                        <td>{$row.symbol}</td>
                        <td>1 {$row.code} = {$row.exchange} {$MONEY_UNIT}</td>
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
            <input type="hidden" name="id" value="{$DATA.id}" />

            <div class="row mb-3">
                <label class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('money_name')}</label>
                <div class="col-sm-8 col-lg-6 col-xxl-8">
                    <select class="form-select w200" name="code">
                        {foreach from=$MONEY_OPTIONS item=money}
                        <option value="{$money.value}" {if $money.selected}selected{/if}>{$money.title}</option>
                        {/foreach}
                    </select>
                </div>
            </div>

            <div class="row mb-3">
                <label class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('currency')}</label>
                <div class="col-sm-8 col-lg-6 col-xxl-8">
                    <input class="form-control w400" name="currency" type="text" value="{$DATA.currency}"
                        maxlength="255" />
                </div>
            </div>

            <div class="row mb-3">
                <label class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('weight_sign')}</label>
                <div class="col-sm-8 col-lg-6 col-xxl-8">
                    <input class="form-control w400" name="symbol" type="text" value="{$DATA.symbol|default:''}"
                        maxlength="255" />
                </div>
            </div>

            <div class="row mb-3">
                <label class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('exchange')}</label>
                <div class="col-sm-8 col-lg-6 col-xxl-8">
                    <input class="form-control w400" name="exchange" type="text" value="{$DATA.exchange}"
                        maxlength="255" />
                </div>
            </div>

            <div class="row mb-3">
                <label class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('round')}</label>
                <div class="col-sm-8 col-lg-6 col-xxl-8">
                    <select class="form-select w400" name="round">
                        {foreach from=$ROUND_OPTIONS item=round}
                        <option value="{$round.round1}" {if $round.selected}selected{/if}>{$round.round2}</option>
                        {/foreach}
                    </select>
                </div>
            </div>

            <div class="row mb-3">
                <label
                    class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('money_number_format')}</label>
                <div class="col-sm-8 col-lg-6 col-xxl-8">
                    <div class="d-flex align-items-center gap-2">
                        <span>{$LANG->getModule('money_number_format_dec_point')}</span>
                        <input class="form-control" style="width: 50px" name="dec_point" type="text"
                            value="{$DATA.dec_point|default:','}" maxlength="1" />
                        <span>{$LANG->getModule('money_number_format_thousands_sep')}</span>
                        <input class="form-control" style="width: 50px" name="thousands_sep" type="text"
                            value="{$DATA.thousands_sep|default:'.'}" maxlength="1" />
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-sm-8 offset-sm-3 offset-xxl-4">
                    <button type="submit" class="btn btn-primary">
                        <i class="fa-solid fa-save"></i> {$LANG->getModule('save')}
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
            if (confirm("{$LANG->getModule('prounit_del_confirm')}")) {
                var listall = [];
                $('input.ck:checked').each(function () {
                    listall.push($(this).val());
                });
                if (listall.length < 1) {
                    alert("{$LANG->getModule('prounit_del_no_items')}");
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
            }
        });

        $('a.delete').click(function (event) {
            event.preventDefault();
            if (confirm("{$LANG->getModule('prounit_del_confirm')}")) {
                var href = $(this).attr('href');
                $.ajax({
                    type: 'POST',
                    url: href,
                    data: '',
                    success: function (data) {
                        window.location = '{$URL_DEL_BACK}';
                    }
                });
            }
        });
    });
</script>