<div class="card border-primary border-3 border-bottom-0 border-start-0 border-end-0">
    <div class="card-header fs-5 fw-medium">{$LANG->getModule('block')}</div>
    <div class="card-body pt-4">
        <!-- Danh sách block -->
        {include file="block_cat_list.tpl"}

        <!-- Form thêm/sửa -->
        {if !empty($ERROR)}
        <div class="alert alert-warning">{$ERROR}</div>
        {/if}

        <form class="form-horizontal mt-4" action="{$smarty.const.NV_BASE_ADMINURL}index.php" method="post">
            <input type="hidden" name="{$smarty.const.NV_NAME_VARIABLE}" value="{$MODULE_NAME}" />
            <input type="hidden" name="{$smarty.const.NV_OP_VARIABLE}" value="{$OP}" />
            <input type="hidden" name="bid" value="{$DATA.bid}" />
            <input type="hidden" name="savecat" value="1" />

            <div class="card">
                <div class="card-header">
                    {$LANG->getModule('add_block_cat')}
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <label class="col-sm-3 col-xxl-4 col-form-label text-sm-end">
                            {$LANG->getModule('block_name')}:
                        </label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <input class="form-control" name="title" type="text" value="{$DATA.title}" maxlength="255" />
                        </div>
                    </div>

                    {if $SHOW_ALIAS}
                    <div class="row mb-3">
                        <label class="col-sm-3 col-xxl-4 col-form-label text-sm-end">
                            {$LANG->getModule('alias')}:
                        </label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <input class="form-control" name="alias" type="text" value="{$DATA.alias}" maxlength="255" />
                        </div>
                    </div>
                    {/if}

                    <div class="row mb-3">
                        <label class="col-sm-3 col-xxl-4 col-form-label text-sm-end">
                            {$LANG->getModule('keywords')}:
                        </label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <input class="form-control" name="keywords" type="text" value="{$DATA.keywords}" maxlength="255" />
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label class="col-sm-3 col-xxl-4 col-form-label text-sm-end">
                            {$LANG->getModule('description')}:
                        </label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <textarea class="form-control" name="description" rows="5">{$DATA.description}</textarea>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label class="col-sm-3 col-xxl-4 col-form-label text-sm-end">
                            {$LANG->getModule('bodytext')}:
                        </label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            {$DATA.bodytext}
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label class="col-sm-3 col-xxl-4 col-form-label text-sm-end">
                            {$LANG->getModule('content_homeimg')}:
                        </label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <div class="input-group">
                                <input class="form-control" type="text" name="image" id="image" value="{$DATA.image}" />
                                <button type="button" class="btn btn-primary" onclick="nvSelectImage('image')">
                                    <i class="fa fa-folder-open-o"></i> {$LANG->getModule('file_selectfile')}
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card mt-4">
                <div class="card-header">SEO</div>
                <div class="card-body">
                    <div class="row mb-3">
                        <label class="col-sm-3 col-xxl-4 col-form-label text-sm-end">
                            Title tag:
                        </label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <input class="form-control" name="tag_title" type="text" value="{$DATA.tag_title}" />
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label class="col-sm-3 col-xxl-4 col-form-label text-sm-end">
                            Description tag:
                        </label>
                        <div class="col-sm-8 col-lg-6 col-xxl-8">
                            <textarea class="form-control" name="tag_description">{$DATA.tag_description}</textarea>
                        </div>
                    </div>
                </div>
            </div>

            <div class="text-center mt-4">
                <button type="submit" class="btn btn-primary" name="submit1">
                    <i class="fa-solid fa-save"></i> {$LANG->getModule('save')}
                </button>
            </div>
        </form>
    </div>
</div>