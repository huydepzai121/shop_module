<!-- BEGIN: main -->
{if $main}
<div class="card">
    <div class="card-header">
        <h3 class="card-title">{$LANG->getModule('point')}</h3>
        <div class="card-tools">
            <form action="{$smarty.const.NV_BASE_ADMINURL}index.php" method="get">
                <input type="hidden" name="{$smarty.const.NV_LANG_VARIABLE}" value="{$smarty.const.NV_LANG_DATA}" />
                <input type="hidden" name="{$smarty.const.NV_NAME_VARIABLE}" value="{$MODULE_NAME}" />
                <input type="hidden" name="{$smarty.const.NV_OP_VARIABLE}" value="{$OP}" />
                <div class="w-50">
                    <div class="input-group">
                        <input class="form-control" type="text" value="{$Q}" name="q" maxlength="255"
                            placeholder="{$LANG->getModule('search_key')}" />
                        <button class="btn btn-primary" type="submit">
                            <i class="fa fa-search"></i> {$LANG->getModule('search')}
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-striped table-bordered table-hover">
                <thead>
                    <tr>
                        <th>{$LANG->getModule('username')}</th>
                        <th>{$LANG->getModule('full_name_user')}</th>
                        <th>{$LANG->getModule('email')}</th>
                        <th class="text-center">{$LANG->getModule('point_total')}</th>
                        <th class="text-center">{$LANG->getModule('money')} ({$money_unit})</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$DATA item=VIEW}
                    <tr>
                        <td>{$VIEW.username}</td>
                        <td>{$VIEW.full_name}</td>
                        <td>{$VIEW.email}</td>
                        <td class="text-center">{$VIEW.point_total}</td>
                        <td class="text-center">{$VIEW.money}</td>
                    </tr>
                    {/foreach}
                </tbody>
                {if !empty($GENERATE_PAGE)}
                <tfoot>
                    <tr>
                        <td colspan="6" class="text-center">
                            {$GENERATE_PAGE}
                        </td>
                    </tr>
                </tfoot>
                {/if}
            </table>
        </div>
    </div>
</div>
{/if}
<!-- END: main -->