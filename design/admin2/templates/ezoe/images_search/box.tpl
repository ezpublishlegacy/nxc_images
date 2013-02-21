{def $box_has_access = fetch(
	'user', 'has_access_to',
	hash(
		'module', 'ezoe',
		'function', 'search'
	)
)}
<div class="panel" id="search_box" style="display: none; position: relative;">
	{if $box_has_access}
		<div id="search_progress" class="progress-indicator" style="display: none;"></div>
		{def $mediaNodeID = ezini( 'NodeSettings', 'MediaRootNode', 'content.ini' )}
		<form action="{concat( 'nxc_images/search/', $mediaNodeID, '/', $mediaNodeID )|ezurl( 'no' )}" method="get">
			<input id="SearchText" name="SearchText" type="text" value="" title="{'Enter the word you want to search for here, for instance the name of the content you are looking for.'|i18n('design/standard/ezoe/wai')}" />
			<input type="submit" name="SearchButton" id="SearchButton" value="{'Search'|i18n('design/admin/content/search')}" />
		</form>

		<div id="search-results">
		</div>
	{else}
		<p>{"Your current user does not have the proper privileges to access this page."|i18n('design/standard/error/kernel')}</p>
	{/if}
</div>