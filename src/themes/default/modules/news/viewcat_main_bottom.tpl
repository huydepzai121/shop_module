<!-- BEGIN: main -->
<!-- BEGIN: h1 -->
<h1 class="hidden d-none">{PAGE_TITLE}</h1>
<!-- END: h1 -->
<!-- BEGIN: catcontent -->
{CATCONTENT_HTML}
<!-- END: catcontent -->
<!-- BEGIN: listcat -->
<div class="news_column">
    <div class="panel panel-default clearfix">
        <div class="panel-heading">
            <!-- BEGIN: subcatmore -->
            <a class="dimgray pull-right hidden-xs" title="{MORE.title}" href="{MORE.link}"><em class="fa fa-sign-out">&nbsp;</em></a>
            <!-- END: subcatmore -->
            <ul class="list-inline sub-list-icon" style="margin: 0">
                <li><h2 class="h4"><a title="{CAT.title}" href="{CAT.link}"><strong>{CAT.title}</strong></a></h2></li>
                <!-- BEGIN: subcatloop -->
                <li class="hidden-xs"><div class="h4"><a class="dimgray" title="{SUBCAT.title}" href="{SUBCAT.link}"><strong>{SUBCAT.title}</strong></a></div></li>
                <!-- END: subcatloop -->
            </ul>
        </div>
        <!-- BEGIN: block_topcat -->
        <div class="block-top clear">
            {BLOCK_TOPCAT}
        </div>
        <!-- END: block_topcat -->
        <div class="panel-body">
            <!-- BEGIN: image -->
            <a href="{CONTENT.link}" title="{CONTENT.title}" {CONTENT.target_blank}><img alt="{HOMEIMGALT}" src="{HOMEIMG}" width="{IMGWIDTH}" class="img-thumbnail pull-left imghome" /></a>
            <!-- END: image -->
            <h3>
                <a href="{CONTENT.link}" title="{CONTENT.title}" {CONTENT.target_blank}>{CONTENT.title}</a>
                <!-- BEGIN: newday -->
                <span class="icon_new">&nbsp;</span>
                <!-- END: newday -->
            </h3>
            <div class="text-muted">
                <ul class="list-unstyled list-inline">
                    <li><em class="fa fa-clock-o">&nbsp;</em> {CONTENT.publtime}</li>
                    <li><em class="fa fa-eye">&nbsp;</em> {LANG.view}: {CONTENT.hitstotal}</li>
                    <!-- BEGIN: comment -->
                    <li><em class="fa fa-comment-o">&nbsp;</em> {LANG.total_comment}: {CONTENT.hitscm}</li>
                    <!-- END: comment -->
                </ul>
            </div>
            {CONTENT.hometext}
            <!-- BEGIN: adminlink -->
            <p class="text-right">
                {ADMINLINK}
            </p>
            <!-- END: adminlink -->

            <!-- BEGIN: related -->
            <ul class="related list-items">
                <!-- BEGIN: loop -->
                <li class="{CLASS}">
                    <a class="show h4" href="{OTHER.link}" {OTHER.target_blank} <!-- BEGIN: tooltip -->data-content="{OTHER.hometext_clean}" data-img="{OTHER.imghome}" data-rel="tooltip" data-placement="{TOOLTIP_POSITION}"<!-- END: tooltip --> title="{OTHER.title}">{OTHER.title}</a>
                </li>
                <!-- END: loop -->
            </ul>
            <!-- END: related -->
        </div>
    </div>
    <!-- BEGIN: block_bottomcat -->
    <div class="bottom-cat clear">
        {BLOCK_BOTTOMCAT}
    </div>
    <!-- END: block_bottomcat -->
</div>
<!-- END: listcat -->
<!-- END: main -->
