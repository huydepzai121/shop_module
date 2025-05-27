<div class="card border-primary border-3 border-bottom-0 border-start-0 border-end-0">
    <div class="card-header fs-5 fw-medium">{$LANG->getModule('tabs')}</div>
    <div class="card-body pt-4">
        {if !empty($ERROR)}
        <div class="alert alert-warning">
            {$ERROR}
        </div>
        {/if}

        {if $SHOW_VIEW}
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <colgroup>
                    <col class="w100" />
                    <col />
                    <col class="w200" />
                    <col class="w100" />
                    <col class="w150" />
                </colgroup>
                <thead>
                    <tr>
                        <th>{$LANG->getModule('weight')}</th>
                        <th>{$LANG->getModule('title')}</th>
                        <th>{$LANG->getModule('tabs_content')}</th>
                        <th class="text-center">{$LANG->getModule('active')}</th>
                        <th>&nbsp;</th>
                    </tr>
                </thead>
                {if !empty($GENERATE_PAGE)}
                <tfoot>
                    <tr>
                        <td colspan="6">{$GENERATE_PAGE}</td>
                    </tr>
                </tfoot>
                {/if}
                <tbody>
                    {foreach from=$ROWS item=VIEW}
                    <tr>
                        <td>
                            <select class="form-select" id="id_weight_{$VIEW.id}"
                                onchange="nvChangeWeight('{$VIEW.id}');">
                                {foreach from=$VIEW.weight_options item=WEIGHT}
                                <option value="{$WEIGHT.key}" {$WEIGHT.selected}>{$WEIGHT.title}</option>
                                {/foreach}
                            </select>
                        </td>
                        <td>{$VIEW.title}</td>
                        <td>{$VIEW.content}</td>
                        <td class="text-center">
                            <input type="checkbox" name="active" id="change_status_{$VIEW.id}" value="{$VIEW.id}"
                                {$VIEW.active} onclick="nvChangeStatus('{$VIEW.id}');" />
                        </td>
                        <td class="text-center">
                            <a href="{$VIEW.link_edit}#edit" class="btn btn-primary btn-xs">
                                <i class="fa-solid fa-edit"></i>
                            </a>
                            <a href="{$VIEW.link_delete}" class="btn btn-danger btn-xs"
                                onclick="return nvConfirm('{$LANG->getModule('delete_confirm')}');">
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
            <input type="hidden" name="id" value="{$ROW.id}" />
            <div class="row mb-3">
                <label class="col-sm-3 col-xxl-4 col-form-label text-sm-end">
                    {$LANG->getModule('title')} <span class="text-danger">*</span>
                </label>
                <div class="col-sm-8 col-lg-6 col-xxl-8">
                    <input class="form-control" type="text" name="title" value="{$ROW.title}" required
                        oninvalid="setCustomValidity('{$LANG->getModule('error_required')}')"
                        oninput="setCustomValidity('')" />
                </div>
            </div>

            <div class="row mb-3">
                <label class="col-sm-3 col-xxl-4 col-form-label text-sm-end">
                    {$LANG->getModule('tabs_icon')}
                </label>
                <div class="col-sm-8 col-lg-6 col-xxl-8">
                    <div class="input-group">
                        <input class="form-control" type="text" name="icon" value="{$ROW.icon}" id="id_icon" />
                        <button type="button" class="btn btn-primary" onclick="nvSelectImage('id_icon')">
                            <i class="fa fa-folder-open-o"></i> {$LANG->getModule('browse_image')}
                        </button>
                    </div>
                </div>
            </div>

            <div class="row mb-3">
                <label class="col-sm-3 col-xxl-4 col-form-label text-sm-end">
                    {$LANG->getModule('tabs_content')}
                </label>
                <div class="col-sm-8 col-lg-6 col-xxl-8">
                    <select class="form-select" name="content">
                        {foreach from=$CONTENT_OPTIONS item=OPTION}
                        <option value="{$OPTION.key}" {$OPTION.selected}>{$OPTION.title}</option>
                        {/foreach}
                    </select>
                </div>
            </div>

            <div class="row">
                <div class="col-sm-8 offset-sm-3 offset-xxl-4">
                    <button type="submit" class="btn btn-primary" name="submit">
                        <i class="fa-solid fa-save"></i> {$LANG->getModule('save')}
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>