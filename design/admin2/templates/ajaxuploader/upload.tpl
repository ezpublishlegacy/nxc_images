<form action={'ezjscore/call'|ezurl} method="post" class="ajaxuploader-upload">
	<fieldset>
		<legend>{'Step 1/2: Upload a file'|i18n( 'design/admin2/ajaxuploader' )}</legend>
		<p>
			<label for="ajaxuploader-file">{'File'|i18n( 'design/admin2/ajaxuploader' )} ({'Required'|i18n( 'design/admin2/ajaxuploader' )})</label>
			<input type="file" name="UploadFile" id="ajaxuploader-file" class="input-required" />
		</p>
		<p>
			<label for="ajaxuploader-name">{'Name'|i18n( 'design/admin2/ajaxuploader' )}</label>
			<input type="text" name="name" id="ajaxuploader-name" class="box input-required" value="" />
		</p>
		<p>
			<label for="ajaxuploader-alt">{'Alternative Text'|i18n( 'design/admin2/ajaxuploader' )}</label>
			<input type="text" name="altText" id="ajaxuploader-alt" class="box input-required" value="" />
		</p>
		<p>
			<label for="parent-node-id">{'Parent Node:'|i18n( 'design/admin2/ajaxuploader' )}</label>
			<input type="hidden" id="parent-node-id" name="parentNodeID" class="input-required" value="" />
			<a class="parent-node" href="" style="display: none;"></a>
		</p>
		<div id="contentstructure">
			{include
				uri='design:contentstructuremenu/content_structure_menu_dynamic_nxc_images.tpl'
				custom_root_node_id=ezini( 'NodeSettings', 'MediaRootNode', 'content.ini' )
			}
		</div>
		<p class="ajaxuploader-button-bar">
			<input type="submit" class="button" value="{'Upload the file'|i18n( 'design/admin2/ajaxuploader' )}" />
			<a href="#" class="window-cancel">{'Close'|i18n( 'design/admin2/ajaxuploader' )}</a>
			<span class="ajaxuploader-error"></span>
		</p>
	</fieldset>
</form>
