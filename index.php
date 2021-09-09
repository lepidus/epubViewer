<?php

/**
 * @defgroup plugins_viewableFile_epubViewer
 */

/**
 * @file plugins/viewableFile/epubViewer/index.php
 *
 * Copyright (c) 2013-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @ingroup plugins_viewableFile_epubViewer
 * @brief Wrapper for pdf.js-based viewer.
 *
 */

require_once('EpubViewerPlugin.inc.php');
return new EpubViewerPlugin();

