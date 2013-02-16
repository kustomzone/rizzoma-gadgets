# TODO: 
# push branch resize to github!!
# on stop save new size to wave
# on wave state changed
# check if iamge size changed, if yes:
# set image size and ui wrapper size
# call window.redrawAnnotationsForNewSize :)
jQuery(document).ready(($) ->
  window.setImageSizeFromWave = (newImageSize) ->
    if (imageSizeHasChanged(newImageSize))
      setImageSize(newImageSize)
      window.redrawAnnotationsForNewSize(newImageSize)
  
  imageSizeHasChanged = (newImageSize) ->
    image = $('#imageToAnnotate')
    return image.width() != newImageSize.width or image.height() != newImageSize.height
  
  setImageSize = (imageSize) ->
    imageAndResizableWrapper = $('#imageToAnnotate, .ui-wrapper')
    setElementsToSize(imageAndResizableWrapper, imageSize)
  
  makeImageResizableOnLoad = ->
    $('#imageToAnnotate').load(makeImageResizable)
  
  makeImageResizable = ->
    $('#imageToAnnotate').resizable(
      {
        resize: (event, ui) ->
          window.redrawAnnotationsForNewSize(ui.size)
        stop: (event, ui) ->
          saveNewImageSizeToWave(ui.size)
      }
    )
    makeEditorVisibleOnBoundariesOfImage()
 
  window.redrawAnnotationsForNewSize = (size) ->
    resizeAnnotoriousLayers(size)
    redrawAnnotations()
 
  resizeAnnotoriousLayers = (newSize) ->
    annotoriousElementsToResize = $('.annotorious-annotationlayer, 
    canvas.annotorious-opacity-fade')
    setElementsToSize(annotoriousElementsToResize, newSize)
 
  setElementsToSize = (elements, size) ->
    # set css properties with jquery
    elements.width(size.width)
    elements.height(size.height)
    # also set width/ height html-properties, they might override css properties
    for element in elements
      if element.width?
        element.width = size.width
      if element.height?
        element.height = size.height
 
  redrawAnnotations = ->
    oldAnnotations = anno.getAnnotations()
    removeAnnotationTextDivs()
    for annotation in oldAnnotations
      if annotation? # ignore one undefined annotation
        anno.removeAnnotation(annotation)
        window.addAnnotationWithText(annotation)

  removeAnnotationTextDivs = ->
    $('.annotationTextDiv').remove()

  makeEditorVisibleOnBoundariesOfImage = ->
    $('.ui-wrapper').css('overflow', '')
 
  saveNewImageSizeToWave = (newSize) ->
    console.log("newsize is", newSize)
    wave.getState().submitValue("imageSize", JSON.stringify(newSize))
 
  makeImageResizableOnLoad()
)