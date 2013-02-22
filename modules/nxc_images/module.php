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
	)
);

$FunctionList = array(
	'search' => array()
);
