<form class="form-horizontal"
    action="{$smarty.const.NV_BASE_ADMINURL}index.php?{$smarty.const.NV_LANG_VARIABLE}={$smarty.const.NV_LANG_DATA}&amp;{$smarty.const.NV_NAME_VARIABLE}={$MODULE_NAME}&amp;{$smarty.const.NV_OP_VARIABLE}={$OP}"
    method="post">
    <input type="hidden" name="id" value="{$ROW.id}" />
    <div class="card border-primary border-3 border-bottom-0 border-start-0 border-end-0">
        <div class="card-header fs-5 fw-medium">{$LANG->getModule('updateprice')}</div>
        <div class="card-body pt-4">
            {if !empty($ERROR)}
            <div class="alert alert-warning">
                {$ERROR}
            </div>
            {/if}

            <div class="row mb-3">
                <label class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('cateid')}</label>
                <div class="col-sm-8 col-lg-6 col-xxl-8">
                    <select class="form-select" name="catid">
                        {foreach from=$CATEGORIES item=cat}
                        <option value="{$cat.key}" {if $cat.selected}selected{/if}>{$cat.title}</option>
                        {/foreach}
                    </select>
                </div>
            </div>

            <div class="row mb-3">
                <label class="col-sm-3 col-xxl-4 col-form-label text-sm-end">{$LANG->getModule('newprice')}</label>
                <div class="col-sm-8 col-lg-6 col-xxl-8">
                    <input class="form-control" type="text" name="newprice" value="{$ROW.newprice}" pattern="^[0-9]*$"
                        oninvalid="setCustomValidity(nv_digits)" oninput="setCustomValidity('')" />
                </div>
            </div>
        </div>
        <div class="card-footer text-center">
            <button type="submit" class="btn btn-primary" name="submit">
                <i class="fa-solid fa-save"></i> {$LANG->getModule('save')}
            </button>
        </div>
    </div>
</form>