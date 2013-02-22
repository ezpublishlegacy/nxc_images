{def
	$current_page = sum( $offset|div( $limit ), 1 )
	$pages_count  = $count|div( $limit )|ceil()
	$viewable_pages_diff = 5
}

{if gt( $pages_count, 1 )}
<div class="pagenavigator">
	<p>

		{if gt( $current_page, 1 )}
			<span class="previous"><a href="{concat( 'nxc_images/search/', $parent_node_id, '/', $facet_node_id, '/', sub( $current_page, 2 )|mul( $limit ), '/', $limit, '?q=', $search_word )|ezurl( 'no' )}"><span class="text">&laquo;&nbsp;{'Previous'|i18n( 'design/admin/navigator' )}</span></a></span>
		{else}
			<span class="previous"><span class="text disabled">&laquo;&nbsp;{'Previous'|i18n( 'design/admin/navigator' )}</span></span>
		{/if}
		<span class="pages">
		{set $pages_count         = $pages_count|dec()}
		{set $viewable_pages_diff = $viewable_pages_diff|sub( 1 )}
		{def
			$left  = false()
			$right = false()
		}
		{for 0 to $pages_count as $page}
			{if or(
				le( $page, $viewable_pages_diff ),
				le( $pages_count|sub( $page ), $viewable_pages_diff ),
				eq( $current_page|sub( $page ), 0 ),
				and(
					le( $current_page|sub( $page ), 0 ),
					le( $current_page|sub( $page )|abs, $viewable_pages_diff )
				),
				and(
					gt( $current_page|sub( $page ), 0 ),
					le( $current_page|sub( $page ), $viewable_pages_diff|sum( 2 ) )
				)
			)}
				{if $page|mul( $limit )|eq( $offset )}
					<span class="current">{sum( $page, 1 )}</span>
				{else}
					<span class="other"><a href="{concat( 'nxc_images/search/', $parent_node_id, '/', $facet_node_id, '/', $page|mul( $limit ), '/', $limit, '?q=', $search_word )|ezurl( 'no' )}">{sum( $page, 1 )}</a></span>
				{/if}
			{else}
				{if and(
					eq( $left, false() ),
					lt( $page, $current_page )
				)}
					{set $left = 1}
					...
				{elseif and(
					eq( $right, false() ),
					gt( $page, $current_page )
				)}
					{set $right = 1}
					...
				{/if}
			{/if}
		{/for}
		</span>
	    {if lt( $current_page, $pages_count )}
			<span class="next"><a href="{concat( 'nxc_images/search/', $parent_node_id, '/', $facet_node_id, '/', $current_page|mul( $limit ), '/', $limit, '?q=', $search_word )|ezurl( 'no' )}"><span class="text">{'Next'|i18n( 'design/admin/navigator' )}&nbsp;&raquo;</span></a></span>
		{else}
			<span class="next"><span class="text disabled">{'Next'|i18n( 'design/admin/navigator' )}&nbsp;&raquo;</span></span>
		{/if}
	</p>
	<div class="break"></div>
</div>
{/if}
