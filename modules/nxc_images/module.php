<?php
/**
 * @package nxcImages
 * @author  Serhey Dolgushev <serhey.dolgushev@nxc.no>
 * @date    21 Feb 2013
 **/

$Module = array(
	'name'      => 'NXC Images',
	'functions' => array()
);

$ViewList = array(
	'search' => array(
		'script'    => 'search.php',
		'functions' => array( 'search' ),
		'params' 	=> array( 'ParentNodeID', 'FacetNodeID', 'Offset', 'Limit' )
	),
	'content_treemenu' => array(
		'script'    => 'content_treemenu.php',
		'functions' => array( 'search' ),
		'params' 	=> array( 'NodeID', 'Modified', 'Expiry', 'Perm' )
	)
);

$FunctionList = array(
	'search' => array()
);
