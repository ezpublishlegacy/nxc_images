{def $box_has_access = fetch(
	'user', 'has_access_to',
	hash(
		'module', 'ezoe',
		'function', 'search'
	)
)}
<div class="panel" id="search_box" style="display: none; position: relative;">
	{literal}
	<style>
	.ai-search-form {
		margin-top: 15px;
	}
	.ai-search-form input[type=text] {
		width: 200px;
	}
	.ai-search-wrapper {
		margin-top: 15px;
		white-space: nowrap;
	}
	.ai-search-facets,
	.ai-search-results {
		display: inline-block;
		vertical-align: top;
		*zoom: 1;
		*display: inline;
		white-space: normal;
	}
	.ai-search-results {
		width: 70%;
		min-width: 170px;
	}
	.ai-search-facets {
		width: 30%;
		min-width: 90px;
		overflow: hidden;
	}
	.ai-search-results>h3 {
		margin-bottom: 5px;
	}
	.ai-search-results>.pagenavigator {
		border-top: 1px solid #ccc;
		border-bottom: 1px solid #ccc;
		padding: 5px 10px;
		margin-right: 15px;
	}
	.ai-search-results>.pagenavigator>p {
		margin: 0;
	}
	.ai-search-element {
		display: inline-block;
		width: 45%;
		max-width: 160px;
		min-width: 50px;
		margin: 0 5px 15px 0;
		vertical-align: top;
		*zoom: 1;
		*display: inline;
	}
	.ai-search-element-img {
		min-height: 100px;
		background-color: #ccc;
	}
	.ai-search-element-img>img {
		width: 100%;
		height: auto;
		-webkit-box-shadow: 1px 1px 3px #000;
		-moz-box-shadow:: 1px 1px 3px #000;
		box-shadow: 1px 1px 3px #000;
	}
	.ai-search-element>span {
		display: block;
		width: 100%;
		overflow: hidden;
		text-overflow: ellipsis;
		margin-top: 10px;
		line-height: 1.3em;
		background-color: #f3f3f3;
	}
	.ai-search-facets-list {
		list-style-type: none;
		margin-top: 5px;
	}
	.ai-search-facets-list>li {
		margin-bottom: 5px;
	}
	</style>
	{/literal}
	{ezscript_require( array('ezjsc::jquery', 'ezjsc::yui2', 'ezajax_autocomplete.js') )}
	<script type="text/javascript">
		jQuery( function() {ldelim}
			jQuery( '#mainarea-autocomplete-rs' ).css( 'width', jQuery( 'input#SearchText' ).width() );
			var autocomplete = new eZAJAXAutoComplete( {ldelim}
				url:            '{'ezjscore/call/ezajaxuploadersearch::autocomplete'|ezurl( 'no' )}',
				inputid:        'SearchText',
				containerid:    'mainarea-autocomplete-rs',
				minquerylength: {ezini( 'AutoCompleteSettings', 'MinQueryLength', 'ezfind.ini' )},
				resultlimit:    {ezini( 'AutoCompleteSettings', 'Limit', 'ezfind.ini' )}
			{rdelim} );
		{rdelim} );
	</script>

	{if $box_has_access}
		<div id="search_progress" class="progress-indicator" style="display: none;"></div>
		{def $mediaNodeID = ezini( 'NodeSettings', 'MediaRootNode', 'content.ini' )}
		<div class="ai-search-form">
			<form action="{concat( 'nxc_images/search/', $mediaNodeID, '/', $mediaNodeID )|ezurl( 'no' )}" method="get">
				<div id="ezautocomplete">
					<input id="SearchText" name="SearchText" type="text" value="" title="{'Enter the word you want to search for here, for instance the name of the content you are looking for.'|i18n('design/standard/ezoe/wai')}" />
					<input type="submit" name="SearchButton" id="SearchButton" value="{'Search'|i18n('design/admin/content/search')}" />
					<div id="mainarea-autocomplete-rs"></div>
				</div>
			</form>
		</div>

		<div id="search-results" class="ai-search-wrapper">
		</div>
	{else}
		<p>{"Your current user does not have the proper privileges to access this page."|i18n('design/standard/error/kernel')}</p>
	{/if}
</div>