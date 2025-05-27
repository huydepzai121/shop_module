{if $main}
<div class="modal-content">
    <div class="modal-header">
        <h5 class="modal-title">{$LANG->getModule('cat_delete')}</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
    </div>
    <div class="modal-body">
        <p class="text-center">{$INFO}</p>

        <div class="form-group">
            <div class="row">
                <div class="col-sm-24 col-md-12">
                    <select name="catidnews" id="catidnews" class="form-select">
                        <option value="0">{$LANG->getModule('cat_move_select')}</option>
                        {foreach from=$CATS item=cat}
                        <option value="{$cat.catid}">{$cat.title}</option>
                        {/foreach}
                    </select>
                </div>
            </div>
        </div>
    </div>
    <div class="modal-footer">
        <input type="hidden" name="catid" value="{$CATID}" />
        <input type="hidden" name="delallcheckss" value="{$DELALLCHECKSS}" />
        <button class="btn btn-primary"
            onclick="nv_del_cat_submit(1);">{$LANG->getModule('cat_delete_and_move')}</button>
        <button class="btn btn-danger" onclick="nv_del_cat_submit(2);">{$LANG->getModule('cat_delete_and_del')}</button>
        <button class="btn btn-default" data-bs-dismiss="modal">{$LANG->getModule('cancel')}</button>
    </div>
</div>

<script type="text/javascript">
    function nv_del_cat_submit(action) {
        var catid = $('input[name="catid"]').val();
        var delallcheckss = $('input[name="delallcheckss"]').val();
        var catidnews = $('#catidnews').val();

        if (action == 2 || (action == 1 && catidnews > 0)) {
            $.ajax({
                type: 'POST',
                url: script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=cat',
                data: {
                    'catid': catid,
                    'delallcheckss': delallcheckss,
                    'action': action,
                    'catidnews': catidnews
                },
                success: function (res) {
                    if (res == 'OK') {
                        window.location.href = window.location.href;
                    } else {
                        alert(res);
                    }
                }
            });
        } else if (action == 1) {
            alert('{$LANG->getModule('cat_move_select_empty')}');
        }
    }
</script>
{/if}