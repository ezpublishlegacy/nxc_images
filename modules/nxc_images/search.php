<?php
/**
 * @package nxcImages
 * @author  Serhey Dolgushev <serhey.dolgushev@nxc.no>
 * @date    21 Feb 2013
 **/

$http   = eZHTTPTool::instance();
$q      = $http->hasVariable( 'q' ) ? $http->variable( 'q' ) : false;
$offset = $Params['Offset'] !== null ? $Params['Offset'] : 0;
$limit  = $Params['Limit'] !== null ? $Params['Limit'] : 12;

$parentNodeID = (int) $Params['ParentNodeID'] > 0 ? $Params['ParentNodeID'] : 1;
$facetNodeID  = (int) $Params['FacetNodeID'] > 0 ? $Params['FacetNodeID'] : 1;
$searchResult = false;

if( $q !== false ) {
	$params       = array(
		'SearchContentClassID' => array( eZContentClass::classIDByIdentifier( 'image' ) ),
		'SearchOffset'         => $offset,
		'SearchLimit'          => $limit,
		'SearchSubTreeArray'   => array( $parentNodeID ),
		'SortBy'               => array(
			array( 'relevance', 'desc' )
		),
		'QueryHandler'         => 'standard'
	);
	$searchResult = eZSearch::search( $q . ' or *' . $q . '*', $params );

	$params['SearchSubTreeArray'] = array( $facetNodeID );
	$params['Facet']              = array(
		array(
			'field' => 'main_parent_node_id',
			'limit' => 100
		)
	);
	$facetResult = eZSearch::search( $q . ' or *' . $q . '*', $params );
}

$tpl = eZTemplate::factory();
$tpl->setVariable( 'search_word', $q );
$tpl->setVariable( 'parent_node_id', $parentNodeID );
$tpl->setVariable( 'facet_node_id', $facetNodeID );
$tpl->setVariable( 'offset', $offset );
$tpl->setVariable( 'limit', $limit );
$tpl->setVariable( 'search', $searchResult );
$tpl->setVariable( 'facet', $facetResult );
echo $tpl->fetch( 'design:ezoe/images_search/results.tpl' );

eZExecution::cleanExit();
