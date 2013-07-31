youtubeGadget = window.youtubeGadget || {}
window.youtubeGadget = youtubeGadget

youtubeGadget.makeVideoResizable = ->
  if (not videoIsResizable())
    $('#youtubePlayerWithButtons').addClass('youtubePlayerResizable')
    $('#youtubePlayerWithButtons').resizable(
      {
        aspectRatio: true,
        alsoResize: "#youtubePlayer",
        minWidth: 350,
        resize: (event, ui) ->
          youtubeGadget.adjustHeightOfGadget()
        stop: (event, ui) ->
          youtubeGadget.saveNewPlayerSizeToWave(ui.size)
      }
    )
  

youtubeGadget.makeVideoUnresizable = ->
  if (videoIsResizable())
    makeVideoUnresizable()
  
videoIsResizable = ->
  return $('#youtubePlayerWithButtons').hasClass('youtubePlayerResizable')

makeVideoUnresizable = ->
  $('#youtubePlayerWithButtons').removeClass('youtubePlayerResizable')
  $('#youtubePlayerWithButtons').resizable('destroy')
  removeOldWidthAndHeightValues()
  

removeOldWidthAndHeightValues = ->
  # somehow necessary to avoid weird mistakes after resize and done->edit
  $('#youtubePlayerWithButtons').width('')
  $('#youtubePlayerWithButtons').height('')
