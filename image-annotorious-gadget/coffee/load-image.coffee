imageAnnotationGadget = window.imageAnnotationGadget || {}
window.imageAnnotationGadget = imageAnnotationGadget

jQuery(document).ready(($) ->
  loadAndStoreImageOnButtonClick = ->
    $('#loadImageButton').click(loadAndStoreImageFromUrlText)
  
  loadAndStoreImageFromUrlText = ->
    urlText = $('#imageUrlText').val()
    loadAndStoreImage(urlText)
  
  loadAndStoreImage = (imageSource) ->
    imageAnnotationGadget.wave.storeImageSource(imageSource)
    imageAnnotationGadget.loadImage(imageSource)
  
  # also used by sync-with-wave.coffee
  imageAnnotationGadget.loadImage = (imageSource, callback) ->
    removeURLTextAndButton()
    setDefaultMaxImageWidth()
    setImageSource(imageSource)
    whenImageLoadedMakeAnnotatableAndAdjustGadgetHeight(callback)
  
  removeURLTextAndButton = ->
    $('#imageUrlText, #loadImageButton').remove()
    
  setImageSource = (imageSource) ->
    $('#imageToAnnotate').attr('src', imageSource)
  
  setDefaultMaxImageWidth = ->
    if (imageHasNoSizeSet())
      $('#imageToAnnotate').css('max-width', '600px')
  
  imageHasNoSizeSet = ->
    return jQuery('#imageToAnnotate').width() == 0
  
  whenImageLoadedMakeAnnotatableAndAdjustGadgetHeight = (callback) ->
    $('#imageToAnnotate').load(() ->
      imageAnnotationGadget.adjustGadgetHeightForImage()
      makeImageAnnotatable()
      removeMaxWidthFromImage()
      callback() if callback?
    )
  
  imageAnnotationGadget.adjustGadgetHeightForImage = ->
    bodyHeight = $('body').height()
    gadgets.window.adjustHeight(bodyHeight + 10) # + 10 for making scrollbar visible
  
  makeImageAnnotatable = ->
    image = $('#imageToAnnotate')[0]
    anno.makeAnnotatable(image)
    setAnnotationCanvasSizesToImageSize() # have to do this for some reason :(((
  
  setAnnotationCanvasSizesToImageSize = ->
    imageWidth = $('#imageToAnnotate').width()
    for annotationCanvas in $('canvas.annotorious-opacity-fade')
      $(annotationCanvas).width(imageWidth)
      annotationCanvas.width = imageWidth
  
  removeMaxWidthFromImage = ->
    # make it possible to resize image beyond max 600 px width as well :))
    $('#imageToAnnotate').css('max-width', '')
  
  imageAnnotationGadget.imageLoaded = ->
    return $('#imageToAnnotate').attr('src')?
  
  loadImageOnPaste = ->
    $('#imageUrlText').on('paste', loadImageFromPastedData)
  
  loadImageFromPastedData = (event) ->
    loadImageIfImagePasted(event)
  
  loadImageIfImagePasted = (event) ->
    clipboardData = event.clipboardData  || event.originalEvent.clipboardData
    items = clipboardData.items
    for item in items
      itemIsImage = item.type.indexOf("image") != -1
      if (itemIsImage)
        loadImageFromImageFile(item)
        return

  loadImageFromImageFile = (item) ->
    imageFile = item.getAsFile()
    imageReader = new FileReader();
    imageReader.onload = (event) ->
      base64ImageSource = event.target.result
      loadAndStoreImage(base64ImageSource)
    imageReader.readAsDataURL(imageFile)
    

  loadAndStoreImageOnButtonClick()
  loadImageOnPaste()
)
