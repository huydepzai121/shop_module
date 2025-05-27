{if $main}
<div class="row">
    {foreach from=$ARRAY_INFO item=info}
    <div class="col-sm-6 col-md-4 col-lg-3 mb-4">
        <div class="card h-100">
            <div class="card-body">
                <h5 class="card-title text-truncate" title="{$info.title}">{$info.title}</h5>
                <div class="d-flex justify-content-between align-items-center mt-3">
                    <div class="h3 mb-0 text-primary">{$info.value}</div>
                    <small class="text-muted">{$info.unit}</small>
                </div>
                <a href="{$info.link}" class="stretched-link"></a>
            </div>
        </div>
    </div>
    {/foreach}
</div>

<style>
    .card {
        transition: transform 0.2s ease-in-out;
        border: 1px solid rgba(0, 0, 0, .125);
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12);
    }

    .card:hover {
        transform: translateY(-5px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    }

    .card-title {
        font-size: 0.9rem;
        color: #6c757d;
        margin-bottom: 0;
    }

    .text-primary {
        color: #007bff !important;
    }

    .stretched-link::after {
        position: absolute;
        top: 0;
        right: 0;
        bottom: 0;
        left: 0;
        z-index: 1;
        content: "";
    }
</style>
{/if}