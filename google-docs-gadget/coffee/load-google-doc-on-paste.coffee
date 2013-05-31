googleDocGadget = window.googleDocGadget || {}
window.googleDocGadget = googleDocGadget

# from http://stackoverflow.com/a/11654596/1469195, then changed to coffeescript
updateQueryString = (key, value, url) ->
  url = window.location.href  unless url
  re = new RegExp("([?|&])" + key + "=.*?(&|#|$)(.*)", "gi")
  if (re.test(url))
    if (typeof value isnt "undefined" and value isnt null)
      url.replace(re, '$1' + key + "=" + value + '$2$3')
    else
      url.replace(re, "$1$3").replace(/(&|\?)$/, "")
  else
    if (typeof value isnt "undefined" and value isnt null)
      separator = (if url.indexOf("?") isnt -1 then "&" else "?")
      hash = url.split("#")
      url = hash[0] + separator + key + "=" + value
      url += "#" + hash[1]  if hash[1]
      url
  return url

loadGoogleDocOnEnter= ->
  $('#googleDocUrlText').keyup((event) ->
    enterKeyCode = 13
    if (event.keyCode == enterKeyCode)
      loadGoogleDoc()
  )

loadGoogleDocOnPaste = ->
  $('#googleDocUrlText').on("paste", () ->
    setTimeout(loadGoogleDocFromTextBox, 0) # have to use timeout here so paste is finished and then url is grabbed :)
  )

loadGoogleDocFromTextBox = ->
  enteredUrl = $('#googleDocUrlText').val()
  googleDocLink = enteredUrl.trim()
  googleDocLinkForMinimalUI = updateQueryString("rm", "minimal", googleDocLink)
  googleDocGadget.loadGoogleDoc(googleDocLinkForMinimalUI)
  googleDocGadget.storeGoogleDocUrlInWave(googleDocLinkForMinimalUI)
  
googleDocGadget.loadGoogleDoc = (googleDocLink) ->
  removeTextField()
  setIFrameSource(googleDocLink)
  showIFrameAndGoogleDocMenuButton()
  adjustHeightOfGadget()

setIFrameSource = (googleDocLink) ->
  return $("#googleDocIFrame").attr("src", googleDocLink)

removeTextField = ->
  $('#googleDocUrlText').remove()

giveWrongUrlWarning =  (url) ->
  alert("Could not use #{url}, please check if #{url} is a google doc url :)")

showIFrameAndGoogleDocMenuButton = ->
  $('#googleDocDiv').show()

adjustHeightOfGadget = ->
  gadgets.window.adjustHeight()

# for loading at start if no url is present in wave (see sync with wave file)
googleDocGadget.showUrlEnterBox = ->
  jQuery('#googleDocUrlText').show()

loadGoogleDocOnEnter()
loadGoogleDocOnPaste()
