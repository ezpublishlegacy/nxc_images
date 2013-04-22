<?php
/**
 * @package nxcImages
 * @class   nxcImagesServerCallFunctions
 * @author  Serhey Dolgushev <serhey.dolgushev@nxc.no>
 * @date    27 Jan 2013
 **/

class nxcImagesServerCallFunctions
{
	/**
	* Returns autocomplete suggestions for given params
	*
	* @param mixed $args
	* @return array
	*/
	public static function autocomplete( $args ) {
		$result  = array();
		$findINI = eZINI::instance( 'ezfind.ini' );
		$solrINI = eZINI::instance( 'solr.ini' );
		$siteINI = eZINI::instance();
		$currentLanguage = $siteINI->variable( 'RegionalSettings', 'ContentObjectLocale' );

		$input = isset( $args[0] ) ? mb_strtolower( $args[0], 'UTF-8' ) : null;
		$limit = isset( $args[1] ) ? (int) $args[1] : (int) $findINI->variable( 'AutoCompleteSettings', 'Limit' );

		$imageClass = eZContentClass::fetchByIdentifier( 'image', false );
		$facetField = $findINI->variable( 'AutoCompleteSettings', 'FacetField' );
		$params     = array(
			'q'              => '*:*',
			'json.nl'        => 'arrarr',
			'facet'          => 'true',
			'facet.field'    => $facetField,
			'facet.prefix'   => $input,
			'facet.limit'    => $limit,
			'facet.mincount' => 1,
			'fq'             => 'meta_contentclass_id_si:' . $imageClass['id']
		);

		if( $findINI->variable( 'LanguageSearch', 'MultiCore' ) == 'enabled' ) {
			$languageMapping = $findINI->variable( 'LanguageSearch','LanguagesCoresMap' );
			$shardMapping    = $solrINI->variable( 'SolrBase', 'Shards' );
			$fullSolrURI     = $shardMapping[ $languageMapping[ $currentLanguage ] ];
		} else {
			$fullSolrURI = $solrINI->variable( 'SolrBase', 'SearchServerURI' );
			// Autocomplete search should be done in current language and fallback languages
			$validLanguages = array_unique(
				array_merge(
					$siteINI->variable( 'RegionalSettings', 'SiteLanguageList' ),
					array( $currentLanguage )
				)
			);
			$params['fq'] .= ' AND meta_language_code_ms:(' . implode( ' OR ', $validLanguages ) . ')';
		}

		$solrBase = new eZSolrBase( $fullSolrURI );
		$result   = $solrBase->rawSolrRequest( '/select', $params, 'json' );

		return $result['facet_counts']['facet_fields'][ $facetField ];
	}

	public static function search( $args ) {
		// Hack to search only by images class
		$_POST['SearchContentClassID'] = eZContentClass::classIDByIdentifier( 'image' );
		// Hack to increase the limit
		$args[2] = 50;

		$results = ezjscServerFunctionsJs::search( $args );
		foreach( $results['SearchResult'] as $key => $item ) {
			$object   = eZContentObject::fetch( $item['contentobject_id'] );
			$dataMap  = $object->attribute( 'data_map' );
			$imageURL = null;

			if(
				isset( $dataMap['image'] )
				&& $dataMap['image']->attribute( 'has_content' )
				&& $dataMap['image']->attribute( 'data_type_string' ) === 'ezimage'
			) {
				$image    = $dataMap['image']->attribute( 'content' );
				$alias    = $image->attribute( 'image_search_preview' );
				$imageURL = $alias['url'];
			}

			$results['SearchResult'][ $key ]['image_url'] = $imageURL;
		}
		return $results;
	}
}
