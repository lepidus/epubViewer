{**
 * plugins/generic/epubViewer/templates/display.tpl
 *
 * Copyright (c) 2010-2021 Lepidus Tecnologia
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
	{$application = Application::get()}

	{if $application->getName() == 'omp'}
		{* Header wrapper *}
		<header class="header_viewable_file">

			{capture assign="submissionUrl"}{url op="book" path=$publishedSubmission->getBestId()}{/capture}

			<a href="{$submissionUrl}" class="return">
				<span class="pkp_screen_reader">
					{translate key="catalog.viewableFile.return" monographTitle=$publishedSubmission->getLocalizedTitle()|escape}
				</span>
			</a>

			<span class="title">
				{$submissionFile->getLocalizedData('name')|escape}
			</span>

			<a href="{$downloadUrl|escape}" class="download" download>
				<span class="label">
					{translate key="common.download"}
				</span>
				<span class="pkp_screen_reader">
					{translate key="common.downloadPdf"}
				</span>
			</a>

		</header>
	{else}
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
	{/if}

	<script src="{$pluginUrl}/epubjs-reader/reader/js/epub.min.js"></script>

	<script type="text/javascript">
		$(document).ready(function() {ldelim} 
			var urlBase = "{$pluginUrl}/epubjs-reader/reader/index.html?bookPath=";
			
			{if $application->getName() === "omp"}
				OMPEpubObject = new ePub({$downloadUrl|json_encode});
				OMPEpubPath = OMPEpubObject.url.Path.path;
				$("#epubCanvasContainer > iframe").attr("src", urlBase + encodeURIComponent(OMPEpubPath) + ".epub");
			{else} 
				var epubUrl = {$epubUrl|json_encode};
				$("#epubCanvasContainer > iframe").attr("src", urlBase + encodeURIComponent(epubUrl) + ".epub");
			{/if}
		{rdelim});
	</script>

	<div id="epubCanvasContainer" class="galley_view{if !$isLatestPublication} galley_view_with_notice{/if}">
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
