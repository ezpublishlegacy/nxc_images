<?php
/**
 * File containing the copy of ezjscServerFunctionsAjaxUploader class with some extras.
 * Added posibility to add alt text during uploading
 */

/**
 * @modifier  Serhey Dolgushev <serhey.dolgushev@nxc.no>
 * @date      13 Feb 2013
*/
class ezjscServerFunctionsAjaxUploaderNXCImages extends ezjscServerFunctions
{

    /**
     * Returns an ajaxuploader handler instance from the ezjscore function
     * arguments.
     *
     * @param array $args the arguments of the ezjscore ajax function
     * @return ezpAjaxUploaderHandlerInterface
     *
     * @throws InvalidArgumentException if the handler cannot be instanciated
     */
    private static function getHandler( array $args )
    {
        if ( !isset( $args[0] ) )
        {
            throw new InvalidArgumentException(
                ezpI18n::tr(
                    'extension/ezjscore/ajaxuploader',
                    'Unable to find the identifier of ajax upload handler'
                )
            );
        }

        $http = eZHTTPTool::instance();
        $handlerData = $http->postVariable( 'AjaxUploadHandlerData', array() );

        $handlerOptions = new ezpExtensionOptions();
        $handlerOptions->iniFile = 'ezjscore.ini';
        $handlerOptions->iniSection = 'AjaxUploader';
        $handlerOptions->iniVariable = 'AjaxUploadHandler';
        $handlerOptions->handlerIndex = $args[0];
        $handlerOptions->handlerParams = $handlerData;

        $handler = eZExtension::getHandlerClass( $handlerOptions );

        if ( !$handler instanceof ezpAjaxUploaderHandlerInterface )
        {
            throw new InvalidArgumentException(
                ezpI18n::tr(
                    'extension/ezjscore/ajaxuploader',
                    'Unable to load the ajax upload handler'
                )
            );
        }
        return $handler;
    }

    /**
     * Returns the upload form
     *
     * @param array $args ezjscore function arguments, the first element is the AJAX
     *                      upload handler identifier ({@link
     *                      ezjscServerFunctionsAjaxUploader::getHandler})
     * @return array( 'meta_data' => false, 'html' => string)
     *
     * @throw RuntimeException if the user is not allowed to upload a file
     */
    static function uploadForm( $args )
    {
        $handler = self::getHandler( $args );
        if ( !$handler->canUpload() )
        {
            throw new RuntimeException(
                ezpI18n::tr(
                    'extension/ezjscore/ajaxuploader',
                    'You are not allowed to upload a file.'
                )
            );
        }
        $tpl = eZTemplate::factory();
        return array(
            'meta_data' => false,
            'html'      => $tpl->fetch( 'design:ajaxuploader/upload.tpl' )
        );
    }

    /**
     * Stores the uploaded file and returns the location form. The result of
     * this method is always json encoded.
     *
     * @param array $args
     * @return string a json encoded array
     */
    static function upload( $args )
    {
    	$http   = eZHTTPTool::instance();
		$fields = array(
			'name'         => 'Name',
			'altText'      => 'Alternative Text',
			'parentNodeID' => 'Parent node'
		);

		// Validate user input
		$errors = array();
		foreach( $fields as $field => $name ) {
			if(
				$http->hasPostVariable( $field )
				&& strlen( $http->postVariable( $field ) ) > 0
			) {
				$fields[ $field ] = $http->postVariable( $field );
			} else {
				$errors[] = $name . ' requires valid input';
			}
		}

		// Upload image
		if( count( $errors ) === 0 ) {
	        try
	        {
	            $handler = self::getHandler( $args );
	            $fileInfo = $handler->getFileinfo();
	            $mimeData = $fileInfo['mime'];
	            $file = $fileInfo['file'];
	            $class = $handler->getContentClass( $mimeData );

	            if ( $file->store( false, $mimeData['suffix'] ) === false )
	            {
	                throw new RuntimeException(
	                    ezpI18n::tr(
	                        'extension/ezjscore/ajaxuploader',
	                        'Unable to store the uploaded file.'
	                    )
	                );
	            }
	            else
	            {
	                $fileHandler = eZClusterFileHandler::instance();
	                $fileHandler->fileStore( $file->attribute( 'filename' ), 'tmp', true, $file->attribute( 'mime_type' ) );
	            }

	            $start = $handler->getDefaultParentNodeId( $class );
	        }
	        catch( Exception $e )
	        {
	            // manually catch exception to force json encode
	            // because most browsers cannot upload
	            // wit a json HTTP Accept header...
	            // see JavaScript code in eZAjaxUploader::delegateWindowEvents();
	            $errors[] = $e->getMessage();
	        }
        }

		// Check parent node
		if( count( $errors ) === 0 ) {
			$parentNode = eZContentObjectTreeNode::fetch( $fields['parentNodeID'] );
			if( $parentNode instanceof eZContentObjectTreeNode === false ) {
				$errors[] = 'Not valid node is selected';
			} else {
				// Check allowed parent nodes
				$allowedParentNodeIDs = (array) eZINI::instance( 'imageuploader.ini.apped.php' )->variable( 'General', 'AllowedParentNodeIDs' );
				$pathNodeIDs          = explode( '/', $parentNode->attribute( 'path_string' ) );
				if( count( array_intersect( $allowedParentNodeIDs, $pathNodeIDs ) ) === 0 ) {
					$errors[] = 'You are not able to uploade to selected node. Allowed node IDs are: ' . implode( ', ', $allowedParentNodeIDs );
				} else {
					// Check permissions
					$canCreateClassist = $parentNode->canCreateClassList();
					$canUpload         = false;
					foreach( $canCreateClassist as $c ) {
						if ( $c['id'] == $class->attribute( 'id' ) ) {
						    $canUpload = true;
						    break;
						}
					}
					if( $canUpload === false ) {
						$errors[] = 'You are not permitted to upload the file in the selected node';
					}
				}
			}
		}

		if( count( $errors ) > 0 ) {
	        return json_encode(
	            array(
	                'error_text' => 'Errors: ' . implode( ', ', $errors ),
	                'content' => ''
	            )
	        );
		}

        $fileSRC     = $file->attribute( 'filename' );
        $fileHandler = eZClusterFileHandler::instance();
        if ( $fileSRC === false
                || !$fileHandler->fileExists( $fileSRC )
                || !$fileHandler->fileFetch( $fileSRC ) )
        {
            throw new RuntimeException(
                ezpI18n::tr(
                    'extension/ezjscore/ajaxuploader', 'Unable to retrieve the uploaded file.'
                )
            );
        }
        else
        {
            $tmpFile = eZSys::cacheDirectory() . '/' .
                        eZINI::instance()->variable( 'FileSettings', 'TemporaryDir' ) . '/' .
                        $file->attribute( 'original_filename' );
            eZFile::rename( $fileSRC, $tmpFile, true );
            $fileHandler->fileDelete( $fileSRC );
            $fileHandler->fileDeleteLocal( $fileSRC );
        }

        $contentObject = $handler->createObject(
            $tmpFile,
            $parentNode->attribute( 'node_id' ),
            $fields['name']
        );
        unlink( $tmpFile );

        //for add alt text
        if( $contentObject->ClassIdentifier == 'image' ){
            $imageDataMap = $contentObject->DataMap();
            $imageContent = $imageDataMap['image']->attribute( 'content' );
            if( $imageContent ){
                $imageContent->setAttribute( 'alternative_text', $fields['altText'] );
                $imageDataMap['image']->store();
            }
        }

        $tpl = eZTemplate::factory();
        $tpl->setVariable( 'object', $contentObject );
        return json_encode(
            array(
                'meta_data' => $handler->serializeObject( $contentObject ),
                'html'      => rawurlencode(
                    $tpl->fetch( 'design:ajaxuploader/preview.tpl' )
                )
            )
        );
    }
}
?>
