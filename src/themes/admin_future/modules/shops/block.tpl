{* <!-- BEGIN: main --> *}
<div class="card">
    <div class="card-header">
        <h3 class="card-title">{$LANG->getModule('block')}</h3>
    </div>
    <div class="card-body">
        <div id="module_show_list">
            {$BLOCK_LIST}
        </div>
        <div id="add" class="mt-4">
            <form action="{$smarty.const.NV_BASE_ADMINURL}index.php" method="post" class="form-horizontal">
                <input type="hidden" name="{$smarty.const.NV_NAME_VARIABLE}" value="{$MODULE_NAME}" />
                <input type="hidden" name="{$smarty.const.NV_OP_VARIABLE}" value="{$OP}" />
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <caption>
                            {$LANG->getModule('addtoblock')}
                        </caption>
                        <thead>
                            <tr>
                                <th class="text-center" style="width: 2%;">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" name="check_all[]" value="yes" onclick="nv_checkAll(this.form, 'idcheck[]', 'check_all[]',this.checked);">
                                    </div>
                                </th>
                                <th>{$LANG->getModule('name')}</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach $DATA as $ROW}
                            <tr>
                                <td class="text-center">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" value="{$ROW.id}" name="idcheck[]" onclick="nv_UncheckAll(this.form, 'idcheck[]', 'check_all[]', this.checked);"{$ROW.checked}/>
                                    </div>
                                </td>
                                <td>{$ROW.title}</td>
                            </tr>
                            {/foreach}
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="2">
                                    <div class="row g-2">
                                        <div class="col-auto">
                                            <select class="form-select" name="bid">
                                                {foreach $BID as $bid}
                                                <option value="{$bid.key}" {$bid.selected}>{$bid.title}</option>
                                                {/foreach}
                                            </select>
                                        </div>
                                        <div class="col-auto">
                                            <input type="hidden" name="checkss" value="{$CHECKSESS}" />
                                            <input type="submit" class="btn btn-primary" name="submit1" value="{$LANG->getModule('save')}" />
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    $(function () {
        $('select[name="bid"]').on('change', function () {
            var bid = $(this).val();
            nv_show_list_block(bid);
        });
    });
</script>
