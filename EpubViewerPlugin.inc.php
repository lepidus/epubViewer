<?php

/**
 * @file plugins/generic/epubViewer/EpubViewerPlugin.inc.php
 *
 * Copyright (c) 2010-2021 Lepidus Tecnologia
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class EpubViewerPlugin
 *
 * @brief This plugin enables embedding of ePUB viewer for epub display
 */
namespace APP\plugins\generic\epubViewer;

use PKP\plugins\Hook;
use PKP\plugins\GenericPlugin;
use APP\core\Application;
use APP\template\TemplateManager;

class EpubViewerPlugin extends GenericPlugin {
	/**
	 * @copydoc Plugin::register()
	 */
	function register($category, $path, $mainContextId = null) {
		if (parent::register($category, $path, $mainContextId)) {
			if ($this->getEnabled($mainContextId)) {
				Hook::add('ArticleHandler::view::galley', array($this, 'submissionCallback'), HOOK_SEQUENCE_LAST);
				Hook::add('IssueHandler::view::galley', array($this, 'issueCallback'), HOOK_SEQUENCE_LAST);
				Hook::add('CatalogBookHandler::view', [$this, 'viewCallback'], Hook::SEQUENCE_LATE);
                Hook::add('CatalogBookHandler::download', [$this, 'downloadCallback'], Hook::SEQUENCE_LATE);
			}
			return true;
		}
		return false;
	}

	/**
	 * Install default settings on context creation.
	 * @return string
	 */
	function getContextSpecificPluginSettingsFile() {
		return $this->getPluginPath() . '/settings.xml';
	}

	/**
	 * @copydoc Plugin::getDisplayName
	 */
	function getDisplayName() {
		return __('plugins.generic.epubViewer.name');
	}

	/**
	 * @copydoc Plugin::getDescription
	 */
	function getDescription() {
		return __('plugins.generic.epubViewer.description');
	}

	/**
	 * Callback that renders the submission galley.
	 * @param $hookName string
	 * @param $args array
	 * @return boolean
	 */
	function submissionCallback($hookName, $args) {
		$request =& $args[0];
		$application = Application::get();
		switch ($application->getName()) {
			case 'ojs2':
				$issue =& $args[1];
				$galley =& $args[2];
				$submission =& $args[3];
				$submissionNoun = 'article';
				break;
			default: throw new Exception('Unknown application!');
		}

		if (!$galley) {
			return false;
		}

		$submissionFile = $galley->getFile();
		if ($submissionFile->getData('mimetype') === 'application/epub+zip') {
			$galleyPublication = null;
			foreach ($submission->getData('publications') as $publication) {
				if ($publication->getId() === $galley->getData('publicationId')) {
					$galleyPublication = $publication;
					break;
				}
			}
			$templateMgr = TemplateManager::getManager($request);
			$templateMgr->assign(array(
				'displayTemplateResource' => $this->getTemplateResource('display.tpl'),
				'pluginUrl' => $request->getBaseUrl() . '/' . $this->getPluginPath(),
				'galleyFile' => $submissionFile,
				'issue' => $issue,
				'submission' => $submission,
				'submissionNoun' => $submissionNoun,
				'bestId' => $submission->getBestId(),
				'galley' => $galley,
				'currentVersionString' => $application->getCurrentVersion()->getVersionString(false),
				'isLatestPublication' => $submission->getData('currentPublicationId') === $galley->getData('publicationId'),
				'galleyPublication' => $galleyPublication,
			));
			$templateMgr->display($this->getTemplateResource('submissionGalley.tpl'));
			return true;
		}

		return false;
	}

	function viewCallback($hookName, $args) {
		$submission =& $args[1];
		$publicationFormat =& $args[2];
		$submissionFile =& $args[3];

		if ($submissionFile->getData('mimetype') == 'application/epub+zip') {
			foreach ($submission->getData('publications') as $publication) {
				if ($publication->getId() === $publicationFormat->getData('publicationId')) {
					$filePublication = $publication;
					break;
				}
			}
			$request = Application::get()->getRequest();
			$router = $request->getRouter();
			$dispatcher = $request->getDispatcher();
			$templateMgr = TemplateManager::getManager($request);
			$templateMgr->assign(array(
				'pluginUrl' => $request->getBaseUrl() . '/' . $this->getPluginPath(),
				'isLatestPublication' => $submission->getData('currentPublicationId') === $publicationFormat->getData('publicationId'),
				'filePublication' => $filePublication,
			));

			$templateMgr->display($this->getTemplateResource('display.tpl'));
			return true;
		}

		return false;
	}

	function downloadCallback($hookName, $params) {
		$submission =& $params[1];
		$publicationFormat =& $params[2];
		$submissionFile =& $params[3];
		$inline =& $params[4];

		$request = Application::get()->getRequest();
		$mimetype = $submissionFile->getData('mimetype');
		if ($mimetype == 'application/epub+zip' && $request->getUserVar('inline')) {
			$inline = true;
		}
		
		return false;
	}

	/**
	 * Callback that renders the issue galley.
	 * @param $hookName string
	 * @param $args array
	 * @return boolean
	 */
	function issueCallback($hookName, $args) {
		$request =& $args[0];
		$issue =& $args[1];
		$galley =& $args[2];

		$templateMgr = TemplateManager::getManager($request);
		if ($galley && $galley->getFileType() == 'application/epub+zip') {
			$application = Application::get();
			$templateMgr->assign(array(
				'displayTemplateResource' => $this->getTemplateResource('display.tpl'),
				'pluginUrl' => $request->getBaseUrl() . '/' . $this->getPluginPath(),
				'galleyFile' => $galley->getFile(),
				'issue' => $issue,
				'galley' => $galley,
				'currentVersionString' => $application->getCurrentVersion()->getVersionString(false),
				'isLatestPublication' => true,
			));
			$templateMgr->display($this->getTemplateResource('issueGalley.tpl'));
			return true;
		}

		return false;
	}
}

