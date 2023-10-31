{**
 * plugins/generic/epubViewer/templates/issueGalley.tpl
 *
 * Copyright (c) 2010-2023 Lepidus Tecnologia
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * Embedded viewing of a EPUB galley.
 *}
{capture assign="epubUrl"}{url op="download" path=$issue->getBestIssueId($currentJournal)|to_array:$galley->getBestGalleyId($currentJournal) escape=false}{/capture}
{capture assign="parentUrl"}{url page="issue" op="view" path=$issue->getBestIssueId($currentJournal)}{/capture}
{capture assign="galleyTitle"}{translate key="submission.representationOfTitle" representation=$galley->getLabel() title=$issue->getIssueIdentification()|escape}{/capture}
{capture assign="datePublished"}{translate key="submission.outdatedVersion" datePublished=$issue->getData('datePublished')|date_format:$dateFormatLong urlRecentVersion=$parentUrl}{/capture}
{include file=$displayTemplateResource title=$issue->getIssueIdentification() parentUrl=$parentUrl epubUrl=$epubUrl galleyTitle=$galleyTitle datePublished=$datePublished}
