{set scope=global persistent_variable=hash('title', 'Upload new Object'|i18n('design/standard/ezoe'),
                                           'scripts', array('ezoe/ez_core.js',
                                                            'ezoe/ez_core_animation.js',
                                                            'ezoe/ez_core_accordion.js',
                                                            'ezoe/popup_utils.js'),
                                           'css', array()
                                           )}
<script type="text/javascript" src={"javascript/lib/ezjslibimagepreloader.js"|ezdesign}></script>
<script type="text/javascript" src={"javascript/contentstructuremenu_dynamic.js"|ezdesign}></script>
<script type="text/javascript" src={"javascript/contentstructuremenu_dynamic_nxcimages_browse.js"|ezdesign}></script>
<link rel="stylesheet" type="text/css" href={"stylesheets/pagelayout.css"|ezdesign} />
<link rel="stylesheet" type="text/css" href={"stylesheets/ezajax_autocomplete.css"|ezdesign} />
<link rel="stylesheet" type="text/css" href={"stylesheets/browse_tree.css"|ezdesign} />

<style>
{literal}
ul, ol {
	padding: 0;
}
a img {
	border: none;
}
{/literal}
</style>

<script type="text/javascript">
<!--
var contentType = '{$content_type}', classFilter = ez.$c();

{foreach $class_filter_array as $class_filter}
    classFilter.push('{$class_filter}');
{/foreach}

{literal}

tinyMCEPopup.onInit.add( function(){
    var slides = ez.$$('div.panel'), navigation = ez.$$('#tabs li.tab');
    slides.accordion( navigation, {duration: 100, transition: ez.fx.sinoidal, accordionAutoFocusTag: 'input[type=text]'}, {opacity: 0, display: 'none'} );
    // custom link generator, to redirect links to browse view if not in browse view
    eZOEPopupUtils.settings.browseLinkGenerator = function( n, mode, ed )
    {
        if ( n.children_count )
        {
           var tag = document.createElement("a");
           tag.setAttribute('href', 'JavaScript:eZOEPopupUtils.browse(' + n.node_id + ');');
           tag.setAttribute('title', ed.getLang('browse') + ': ' + n.url_alias );
           if ( mode !== 'browse' ) ez.$( tag ).addEvent('click', function(){ slides.accordionGoto( 2 ); });
           return tag;
        }
        var tag = document.createElement("span");
        tag.setAttribute('title', n.url_alias );
        return tag;
    };
});

jQuery( function() {
	var allowedNodePathes = [];
{/literal}
	{def $allowedParentNode = false()}
	{foreach ezini( 'General', 'AllowedParentNodeIDs', 'fileuploader.ini' ) as $allowedParentNodeID}
		{set $allowedParentNode = fetch( 'content', 'node', hash( 'node_id', $allowedParentNodeID ) )}
		allowedNodePathes.push( '{$allowedParentNode.url_alias|ezurl( 'no' )}' );
	{/foreach}
	{undef $allowedParentNode}
{literal}
	jQuery( 'li a.image-text' ).live( 'click', 'div#contentstructure', function( e ) {
		var el = jQuery( this );
		if( el.attr( 'href' ).indexOf( 'javascript' ) !== -1 ) {
			return true;
		}

		e.preventDefault();
		var depth = el.parents( 'ul' ).length;
		var isAllowed = false;
		jQuery.each( allowedNodePathes, function( i, path ) {
			if( el.attr( 'href' ).indexOf( path ) !== -1 ) {
				isAllowed = true;
				return false;
			}
		} );
		if( isAllowed ) {
			var nodeID = el.parent( 'li' ).attr( 'id' ).replace( 'n', '' );
			jQuery( 'form#EmbedForm a.parent-node' ).show().attr( 'href', el.attr( 'href' ) ).html( el.html() );
			jQuery( 'form#EmbedForm input#location' ).val( nodeID );
		}
	} );

	var loadSearchResults = function( url ) {
		var wrapper = jQuery( 'div#search-results' );
		var loader  = jQuery( 'div#search_progress' );
		loader.show();
		wrapper.empty();
		jQuery.ajax( url ).done( function( html ) {
			var popup = $( 'div.mceWrapper', window.parent.document ).parent();
			popup.css( 'width', 845 );
			jQuery( 'iframe', popup ).css( 'width', 835 );

			wrapper.append( html );
			loader.hide();
		} );
	};

	jQuery( 'div#search_box form' ).bind( 'submit', function( e ) {
		e.preventDefault();
		var form = jQuery( this );
		var url  = form.attr( 'action' ) + '?q=' + encodeURIComponent( jQuery( '#SearchText', form ).val() );
		loadSearchResults( url );
	} );
	jQuery( 'div#search_box' ).delegate( 'div.ai-search-facets a, div.pagenavigator a', 'click', function( e ) {
		e.preventDefault();
		loadSearchResults( jQuery( this ).attr( 'href' ) );
	} );
} );
-->
</script>
{/literal}
<div class="upload-view">
    {def $cmis_url = concat( 'cmis_client/upload/', $object_id, '/', $object_version, '/auto/1' )|ezurl( no )
         $ezoe_url = concat( 'ezoe/upload/', $object_id, '/', $object_version, '/auto/1' )|ezurl( no )}

    <form action={$ezoe_url} method="post" target="embed_upload" name="EmbedForm" id="EmbedForm" enctype="multipart/form-data" onsubmit="document.getElementById('upload_in_progress').style.display = '';">

        <div id="tabs" class="tabs">
        <ul>
            <li class="tab" title="{'Upload file from your local machine.'|i18n('design/standard/ezoe/wai')}"><span><a href="JavaScript:void(0);">{'Upload'|i18n('design/admin/content/upload')}</a></span></li>
            <li class="tab" title="{'Search for content already in eZ Publish.'|i18n('design/standard/ezoe/wai')}"><span><a href="JavaScript:void(0);">{'Search'|i18n('design/admin/content/search')}</a></span></li>
            <li class="tab" title="{'Browse the content tree in eZ Publish.'|i18n('design/standard/ezoe/wai')}"><span><a href="JavaScript:void(0);">{'Browse'|i18n('design/standard/ezoe')}</a></span></li>
            <li class="tab" title="{'Select or browse content among your personal eZ Publish bookmarks.'|i18n('design/standard/ezoe/wai')}"><span><a href="JavaScript:void(0);">{'Bookmarks'|i18n( 'design/admin/content/browse' )}</a></span></li>
        </ul>
        </div>

<div class="panel_wrapper" style="min-height: 360px;">
        <div class="panel">
            <table class="properties">
                <tr>
                    <td class="column1"><label id="titlelabel" for="objectName">{'Name'|i18n('design/standard/ezoe')}</label></td>
                    <td colspan="2"><input id="objectName" name="objectName" size="40" type="text" value="" title="{'Name for the uploaded object, filename is used if none is specified.'|i18n('design/standard/ezoe/wai')}" /></td>
                </tr>
                <tr>
                    <td class="column1"><label id="srclabel" for="fileName">{'File'|i18n('design/standard/ezoe')}</label></td>
                    <td colspan="2"><input name="fileName" type="file" id="fileName" size="50" value="" title="{'Choose file to upload from your local machine.'|i18n('design/standard/ezoe/wai')}" /></td>
                </tr>
                {if $content_type|eq('images')}
                <tr>
                    <td class="column1"><label id="alttextlabel" for="objectAltText">{'Alternative text'|i18n('design/standard/ezoe')}</label></td>
                    <td colspan="2"><input id="objectAltText" name="ContentObjectAttribute_image" size="53" type="text" value="" title="{'Alternative text for the image, lets internet clients know what kind of image this is without dowloading it or actually seeing it.'|i18n('design/standard/ezoe/wai')}" /></td>
                </tr>
                <tr>
                    <td class="column1"><label id="captionlabel" for="objectCaption">{'Caption'|i18n('design/standard/ezoe')}</label></td>
                    <td colspan="2"><input id="objectCaption" name="ContentObjectAttribute_caption" size="53" type="text" value="" title="{'Caption for a image is usually shown bellow it as a description to the image.'|i18n('design/standard/ezoe/wai')}" /></td>
                </tr>
                {else}
                <tr>
                    <td class="column1"><label id="descriptionlabel" for="objectDescription">{'Description'|i18n('design/standard/ezoe')}</label></td>
                    <td colspan="2"><input id="objectDescription" name="ContentObjectAttribute_description" size="53" type="text" value="" title="{'Description to the file your uploading, so internet clients can read more about it before they decide to download it.'|i18n('design/standard/ezoe/wai')}" /></td>
                </tr>
                {/if}
                <tr id="embedlistsrcrow">
				    <td class="column1" valign="top"><label for="location">{'Location'|i18n('design/standard/ezoe')} (<a href="#" class="parent-node" target="_blank">not selected</a>)</label></td>
				    <td colspan="2" id="embedlistsrccontainer">
				        <input type="hidden" name="location" id="location" value="" />
						<div id="contentstructure">
							{include
								uri='design:contentstructuremenu/content_structure_menu_dynamic_nxc_images.tpl'
								custom_root_node_id=ezini( 'NodeSettings', 'MediaRootNode', 'content.ini' )
							}
						</div>
				    </td>
                </tr>
                <tr>
                    <td colspan="3">
                    <input id="uploadButton" name="uploadButton" type="submit" value="{'Upload local file'|i18n('design/standard/ezoe')}" />
                    <span id="upload_in_progress" style="display: none; color: #666; background: #fff url({"stylesheets/skins/default/img/progress.gif"|ezdesign('single')}) no-repeat top left scroll; padding-left: 32px;">{'Upload is in progress, it may take a few seconds...'|i18n('design/standard/ezoe')}</span>
                    </td>
                </tr>
            </table>

            <iframe id="embed_upload" name="embed_upload" frameborder="0" scrolling="no" style="border: 0; width: 99%; height: 30px; margin: 0; overflow: auto; overflow-x: hidden;"></iframe>

            {* Related objects *}
            {if and( $related_contentobjects|count|gt( 0 ), $grouped_related_contentobjects.objects|count|gt( 0 ) )}
            <div class="block contenttype_object">
            <h2>{'Related content'|i18n('design/standard/ezoe')}</h2>
                    <table class="list" cellspacing="0">
                    <tr>
                        <th class="name">{'Name'|i18n( 'design/admin/content/edit' )}</th>
                        <th class="class">{'Type'|i18n( 'design/admin/content/edit' )}</th>
                    </tr>
                    {foreach $grouped_related_contentobjects.objects as $relation sequence array( bglight, bgdark ) as $sequence}
                        <tr class="{$sequence}">
                            <td class="name">{$relation.object.class_name|class_icon( small, $relation.object.class_name )}&nbsp;<a href="JavaScript:eZOEPopupUtils.selectByEmbedId( {$relation.object.id} )">{$relation.object.name|wash|shorten( 35 )}</a></td>
                            <td class="class">{$relation.object.class_name|wash}</td>
                        </tr>
                    {/foreach}
                    </table>
            </div>
            {else}
            <div class="block">
                <p>{"There are no related objects."|i18n("design/standard/ezoe")}</p>
            </div>
            {/if}
        </div>
     </form>
{include uri="design:ezoe/files_search/box.tpl" embed_mode=false() class_filter_array=$class_filter_array}

{include uri="design:ezoe/files_search/box_browse.tpl" box_embed_mode=false() box_class_filter_array=$class_filter_array}

{include uri="design:ezoe/box_bookmarks.tpl" embed_mode=false()}

</div>

</div>
