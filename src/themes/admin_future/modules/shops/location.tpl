{if $main}
{include file="shipping_menu.tpl"}

<div id="module_show_list">
    {$LOCATION_LIST}
</div>

<div class="card">
    <div class="card-header">
        <h3 class="card-title">{$CAPTION}</h3>
    </div>
    <div class="card-body">
        {if !empty($error)}
        <div class="alert alert-warning">{$error}</div>
        {/if}

        <form class="form-horizontal" action="{$FORM_ACTION}" method="post">
            <input type="hidden" name="id" value="{$DATA.id}" />
            <input type="hidden" name="parentid_old" value="{$DATA.parentid}" />
            <input name="savelocation" type="hidden" value="1" />
            <table class="table table-bordered table-striped">
                <tbody>
                    <tr>
                        <td style="width: 10%;">
                            <strong>{$LANG->getModule('location_name')}</strong>
                            <span class="text-danger">(*)</span>
                        </td>
                        <td>
                            <input style="width: 30%;" class="form-control" type="text" name="title" value="{$DATA.title}" maxlength="255"required="required"/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <strong>{$LANG->getModule('location_in')}</strong>
                        </td>
                        <td>
                            <select style="width: 30%;" class="form-select" name="parentid">
                                {foreach from=$parent_list item=parent}
                                <option value="{$parent.id}" {$parent.selected}>{$parent.title}</option>
                                {/foreach}
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" class="text-left">
                            <input class="btn btn-primary" name="submit1" type="submit" value="{$LANG->getModule('save')}" />
                        </td>
                    </tr>
                </tbody>
            </table>
        </form>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        // Xử lý thay đổi thứ tự
        $('[id^="change_weight_"]').change(function () {
            var id = $(this).attr('id').replace('change_weight_', '');
            nv_chang_location(id, 'weight');
        });

        // Xử lý xóa
        $('[id^="delete_location_"]').click(function () {
            var id = $(this).attr('id').replace('delete_location_', '');
            if (confirm(nv_is_del_confirm[0])) {
                nv_del_location(id);
            }
        });
    });
</script>
{/if}