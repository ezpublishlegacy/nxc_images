{run-once}
{if ezmodule( 'ezjscore' )}{* Make sure ezjscore is installed before we try to enable the search code *}
{literal}
<style>
	.m-search-results a {
		display: inline-block;
		position: relative;
		width: 160px;
		background-color: #DFDFDF;
		padding: 135px 10px 10px 10px;
		text-align: center;
		margin-bottom: 10px;
		margin-right: 10px;
		overflow: hidden;
		*zoom: 1;
		*display: inline;
	}
	.m-search-results a img {
		position: absolute;
		top: 10px;
		left: 10px;
	}
</style>
{/literal}
<input type="hidden" id="ezobjectrelation-search-published-text" value="{'Yes'|i18n( 'design/standard/content/datatype' )}" />
<p id="ezobjectrelation-search-empty-result-text" class="hide ezobjectrelation-search-empty-result">{'No results were found when searching for "%1"'|i18n("design/standard/content/search",,array( '--search-string--' ))}</p>
{ezscript_require( array( 'ezjsc::jquery', 'ezjsc::jqueryio', 'ezajaxrelations_jquery_nxcimages.js' ) )}
{/if}
{/run-once}