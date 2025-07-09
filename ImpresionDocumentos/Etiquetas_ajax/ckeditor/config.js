/**
 * @license Copyright (c) 2003-2013, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.html or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
	config.enterMode = CKEDITOR.ENTER_BR;
	CKEDITOR.config.toolbar = [['Format','Font','FontSize','-','Bold','Italic','Underline','-','Print']];
	config.removePlugins ='resize, enterkey, entities, panelbutton, templates, about, bidi, colorbutton, htmlwriter, image, flash, tabletools, smiley, forms, find, selectall, link, horizontalrule, specialchar, preview, newpage, save, elementspath, pastefromword, pastetext, undo, clipboard, scayt, iframe, maximize, pagebreak';
};
