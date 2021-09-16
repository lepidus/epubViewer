{**
 * plugins/generic/epubViewer/templates/display.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * Embedded viewing of a EPUB galley.
 *}
<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset={$defaultCharset|escape}" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>{translate key="article.pageTitle" title=$title|escape}</title>

	{load_header context="frontend" headers=$headers}
	{load_stylesheet context="frontend" stylesheets=$stylesheets}
	{load_script context="frontend" scripts=$scripts}
</head>

<body class="pkp_page_{$requestedPage|escape} pkp_op_{$requestedOp|escape}">

	{* Header wrapper *}
	<header class="header_view">
		<a href="{$parentUrl}" class="return">
			<span class="pkp_screen_reader">
				{if $parent instanceOf Issue}
					{translate key="issue.return"}
				{else}
					{translate key="article.return"}
				{/if}
			</span>
		</a>

		<a href="{$parentUrl}" class="title">
			{$title|escape}
		</a>

		<a href="{$epubUrl}" class="download" download>
			<span class="label">
				{translate key="common.download"}
			</span>
			<span class="pkp_screen_reader">
				{translate key="common.downloadPdf"}
			</span>
		</a>

	</header>

	<script src="{$pluginUrl}/epubjs-reader/reader/js/epub.min.js"></script>

	<script type="text/javascript">
		$(document).ready(function() {ldelim} 
			var urlBase = "{$pluginUrl}/epubjs-reader/reader/index.html?bookPath=";
			
			{$application = Application::get()}
			{if $application->getName() === "omp"}
				OMPEpubObject = new ePub({$downloadUrl|json_encode});
				OMPEpubPath = OMPEpubObject.url.Path.path;
				$("#pdfCanvasContainer > iframe").attr("src", urlBase + encodeURIComponent(OMPEpubPath) + ".epub");
			{else} 
				var epubUrl = {$epubUrl|json_encode};
				$("#pdfCanvasContainer > iframe").attr("src", urlBase + encodeURIComponent(epubUrl) + ".epub");
			{/if}
		{rdelim});
	</script>

	<div id="pdfCanvasContainer" class="galley_view{if !$isLatestPublication} galley_view_with_notice{/if}">
		{if !$isLatestPublication}
			<div class="galley_view_notice">
				<div class="galley_view_notice_message" role="alert">
					{$datePublished}
				</div>
			</div>
		{/if}
		<iframe src="" width="100%" height="100%" style="min-height: 500px;" title="{$galleyTitle}" allowfullscreen webkitallowfullscreen></iframe>
	</div>
	{call_hook name="Templates::Common::Footer::PageFooter"}
</body>
</html>
