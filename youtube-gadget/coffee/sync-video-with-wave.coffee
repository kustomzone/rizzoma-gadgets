youtubeGadget = window.youtubeGadget || {}
window.youtubeGadget = youtubeGadget

tryToLoadVideoFromWave = ->
  videoShouldBeLoaded = videoIdStoredInWave() and not youtubeGadget.videoLoaded() 
  if (videoShouldBeLoaded and youtubeApiReady())
    loadVideoFromWave()
  else if (videoShouldBeLoaded and not youtubeApiReady())
    setTimeout(loadVideoFromWave, 1000)
  else if not videoIdStoredInWave()
    youtubeGadget.showUrlEnterBox()

videoIdStoredInWave = ->
  return wave.getState().get("videoId")?

youtubeApiReady = ->
  return YT.Player?

loadVideoFromWave = ->
  videoId = getVideoIdFromWave()
  videoWidth = getVideoWidthFromWave()
  videoHeight = getVideoHeightFromWave()
  videoStart = getVideoStartFromWave()
  videoEnd = getVideoEndFromWave()
  youtubeGadget.loadPlayerWithVideoId(videoId, videoWidth, videoHeight, videoStart, videoEnd)
  
getVideoIdFromWave = ->
  return wave.getState().get("videoId")
  
getVideoWidthFromWave = ->
  return wave.getState().get("videoWidth") || 640

getVideoHeightFromWave = ->
  return wave.getState().get("videoHeight") || 390

getVideoStartFromWave = ->
  return wave.getState().get("videoStart") || null

getVideoEndFromWave = ->
  return wave.getState().get("videoEnd") || null

youtubeGadget.storeVideoIdInWave = (videoId) ->
    wave.getState().submitValue("videoId", videoId)
  
youtubeGadget.saveNewPlayerSizeToWave = (size) ->
  wave.getState().submitValue("videoWidth", size.width)
  wave.getState().submitValue("videoHeight", size.height)

youtubeGadget.storeStartTimeInWave = (startTime) ->
  wave.getState().submitValue("videoStart", startTime)

youtubeGadget.storeEndTimeInWave = (endTime) ->
  wave.getState().submitValue("videoEnd", endTime)

wave.setStateCallback(tryToLoadVideoFromWave)