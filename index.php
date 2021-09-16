<?php

/**
 * @defgroup plugins_viewableFile_epubViewer
 */

/**
 * @file plugins/viewableFile/epubViewer/index.php
 *
 * Copyright (c) 2010-2021 Lepidus Tecnologia
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @ingroup plugins_viewableFile_epubViewer
 * @brief Wrapper for epub.js-based viewer.
 *
 */

require_once('EpubViewerPlugin.inc.php');
return new EpubViewerPlugin();

