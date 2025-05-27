<div class="row mb-3">
    <div class="col-sm-24 col-md-16 ms-auto">
        <div class="dropdown d-flex justify-content-end">
            <button type="button" class="btn btn-primary me-2" id="shipping">
                {$LANG->getModule('shipping')}
            </button>
            <button type="button" class="btn btn-primary dropdown-toggle" data-bs-toggle="dropdown"
                aria-expanded="false">
                <i class="fa fa-caret-down"></i>
            </button>
            <ul class="dropdown-menu">
                <li>
                    <a class="dropdown-item" href="{$LOCALTION_URL}">
                        <i class="fa fa-map-marker fa-fw"></i> {$LANG->getModule('location')}
                    </a>
                </li>
                <li>
                    <a class="dropdown-item" href="{$CARRIER_URL}">
                        <i class="fa fa-truck fa-fw"></i> {$LANG->getModule('carrier')}
                    </a>
                </li>
                <li>
                    <a class="dropdown-item" href="{$CONFIG_URL}">
                        <i class="fa fa-cog fa-fw"></i> {$LANG->getModule('carrier_config_config')}
                    </a>
                </li>
                <li>
                    <a class="dropdown-item" href="{$SHOPS_URL}">
                        <i class="fa fa-store fa-fw"></i> {$LANG->getModule('shops')}
                    </a>
                </li>
            </ul>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(function () {
        $('#shipping').on('click', function () {
            window.location.href = script_name + '?' + nv_lang_variable + '=' + nv_lang_data + '&' + nv_name_variable + '=' + nv_module_name + '&' + nv_fc_variable + '=shipping';
        });
    });
</script>