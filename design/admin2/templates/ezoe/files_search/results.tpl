<div class="ai-search-results">

	{if gt( $search['SearchResult']|count, 0 )}
	<h3>{'Results:'|i18n( 'design/admin/search' )}</h3>
		{foreach $search['SearchResult'] as $node}
		<div class="ai-search-element">
			<a href="javascript:console.log( eZOEPopupUtils );eZOEPopupUtils.selectByEmbedId( {$node.contentobject_id}, {$node.node_id}, '{$node.name|wash}' );">
				<span>{$node.name|wash}</span>
			</a>
			file
			<div class="ai-sear ch-element-file-info">
				{$node.data_map.file.content.mime_type} {$node.data_map.file.content.filesize|si( byte )}
			</div>
			<div class="ai-sear ch-element-description">
				{attribute_view_gui attribute=$node.data_map.description}
			</div>
		</div>
		{/foreach}

		{include
			uri='design:ezoe/files_search/navigator.tpl'
			parent_node_id=$parent_node_id
			facet_node_id=$facet_node_id
			search_word=$search_word
			offset=$offset
			limit=$limit
			count=$search['SearchCount']
		}
	{else}
		<h3>{'No results were found'|i18n( 'design/admin/search' )}</h3>
	{/if}
</div>

{if gt( $search['SearchResult']|count, 0 )}
	{def $folder_node = false()}
	<div class="ai-search-facets">
		<h3>{'Filters:'|i18n( 'design/admin/search' )}</h3>
		<ul class="ai-search-facets-list" id="ai-search-facets-list">
			{foreach $facet['SearchExtras'].facet_fields[0]['countList'] as $node_id => $count}
				{set $folder_node = fetch( 'content', 'node', hash( 'node_id', $node_id ) )}
				<li><a href="{concat( 'nxc_files/search/', $node_id, '/', $facet_node_id, '?q=', $search_word )|ezurl( 'no' )}">{$folder_node.name|wash} ({$count})</a></li>
			{/foreach}
		</ul>
	</div>
	{undef $folder_node}
{/if}