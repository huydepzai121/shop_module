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
			<ul class="list-inline pull-left" style="margin: 0">
				<li><h2><a title="{CAT.title}" href="{CAT.link}"><span>{CAT.title}</span></a></h2></li>

			</ul>
			<!-- BEGIN: subcat -->
			<div class="btn-group pull-right">
				<button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
					<span class="caret"></span>
					<span class="sr-only">Toggle Dropdown</span>
				</button>
				<ul class="dropdown-menu" role="menu">
					<!-- BEGIN: loop -->
					<li><a title="{SUBCAT.title}" href="{SUBCAT.link}">{SUBCAT.title}</a></li>
					<!-- END: loop -->
				</ul>
			</div>
			<!-- END: subcat -->
			<div class="clearfix"></div>
		</div>

		<div class="panel-body">
			<div class="row">
				<div class="{WCT}">
					<!-- BEGIN: image -->
					<a title="{CONTENT.title}" href="{CONTENT.link}"><img src="{HOMEIMG}" alt="{HOMEIMGALT}" width="60" class="img-thumbnail pull-left imghome" /></a>
					<!-- END: image -->
					<h3>
						<a title="{CONTENT.title}" href="{CONTENT.link}">{CONTENT.title}</a>
						<!-- BEGIN: newday -->
						<span class="icon_new">&nbsp;</span>
						<!-- END: newday -->
					</h3>
					<div class="text-muted">
						<ul class="list-unstyled list-inline">
							<li><em class="fa fa-clock-o">&nbsp;</em> {CONTENT.publtime}</li>
							<li><em class="fa fa-eye">&nbsp;</em> {CONTENT.hitstotal}</li>
							<li><em class="fa fa-comment-o">&nbsp;</em> {CONTENT.hitscm}</li>
						</ul>
					</div>
					{CONTENT.hometext}
				</div>

				<!-- BEGIN: related -->
				<div class="col-md-8">
					<ul class="related">
						<!-- BEGIN: loop -->
						<li class="{CLASS}">
							<a class="show" href="{OTHER.link}" title="{OTHER.title}">{OTHER.title}</a>
						</li>
						<!-- END: loop -->
					</ul>
				</div>
				<!-- END: related -->
			</div>
		</div>
	</div>
</div>
<!-- END: listcat -->
<!-- END: main -->
