{default box_embed_mode         = true()
         box_has_access         = fetch( 'user', 'has_access_to', hash( 'module', 'ezoe',
                                                                    'function', 'browse' ) )}
    <div class="panel" id="browse_box" style="display: none; position: relative;">
        <div style="background-color: #eee; text-align: center">
        {if $box_embed_mode}
            <a id="embed_browse_go_back_link" title="Go back" href="JavaScript:void(0);" style="float: right;"><img width="16" height="16" border="0" src={"tango/emblem-unreadable.png"|ezimage} /></a>
        {/if}

		<div id="contentstructure-browse">
			{include
				uri='design:contentstructuremenu/content_structure_menu_dynamic_nxc_images_browse.tpl'
				custom_root_node_id=ezini( 'NodeSettings', 'MediaRootNode', 'content.ini' )
				tree_wrapper_id='contentstructure-browse'
				index='browse'
			}
		</div>

        </div>
        <p>{"Your current user does not have the proper privileges to access this page."|i18n('design/standard/error/kernel')}</p>
    {/if}
    </div>
{/default}
