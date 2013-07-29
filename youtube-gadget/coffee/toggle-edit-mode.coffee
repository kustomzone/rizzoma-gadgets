youtubeGadget = window.youtubeGadget || {}
window.youtubeGadget = youtubeGadget

VIEW_MODE = 1
EDIT_MODE = 2
CURRENT_MODE = VIEW_MODE # should always start in view mode

reactToBlipModeChange = ->
  wave.setModeCallback(handleBlipModeChange)
  
handleBlipModeChange = ->
  mode = wave.getMode()
  if (mode isnt CURRENT_MODE)
    enterNewMode(mode)
    CURRENT_MODE = mode

enterNewMode = (mode) ->
  if (mode == EDIT_MODE)
    youtubeGadget.enterEditMode()
  else if (mode == VIEW_MODE)
    removeOldYoutubePlayer()
    youtubeGadget.loadVideoFromWave()
    youtubeGadget.enterViewMode()

removeOldYoutubePlayer = ->
  youtubeGadget.youtubePlayer.destroy()
  $('youtubePlayerWithButtons').prepend("<div id='youtubePlayer'></div>")

youtubeGadget.enterEditMode = ->
  youtubeGadget.makePlayerEditable()

youtubeGadget.enterViewMode = ->
  makePlayerUneditable()

youtubeGadget.makePlayerEditable = ->
    videoStart = youtubeGadget.getVideoStartFromWave()
    videoEnd = youtubeGadget.getVideoEndFromWave()
    youtubeGadget.makeVideoResizable()
    youtubeGadget.showStartAndEndButtons(videoStart, videoEnd)
    youtubeGadget.adjustHeightOfGadget()

makePlayerUneditable = ->
  youtubeGadget.makeVideoUnresizable()
  youtubeGadget.hideStartEndButtons()
  youtubeGadget.adjustHeightOfGadget()

reactToBlipModeChange()