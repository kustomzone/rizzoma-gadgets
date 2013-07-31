youtubeGadget = window.youtubeGadget || {}
window.youtubeGadget = youtubeGadget

tryToLoadVideoFromWave = ->
  videoShouldBeLoaded = videoIdStoredInWave() and not youtubeGadget.videoLoaded() 
  if (videoShouldBeLoaded and youtubeApiReady())
    youtubeGadget.loadVideoFromWave(youtubeGadget.enterCurrentMode)
  else if (videoShouldBeLoaded and not youtubeApiReady())
    setTimeout(tryToLoadVideoFromWave, 1000)
  else if not videoIdStoredInWave()
    youtubeGadget.showUrlEnterBox()

videoIdStoredInWave = ->
  return wave.getState().get("videoId")?

youtubeApiReady = ->
  return YT.Player?

youtubeGadget.loadVideoFromWave = (callback) ->
  videoId = getVideoIdFromWave()
  videoWidth = getVideoWidthFromWave()
  videoHeight = getVideoHeightFromWave()
  videoStart = youtubeGadget.getVideoStartFromWave()
  videoEnd = youtubeGadget.getVideoEndFromWave()
  youtubeGadget.loadPlayerWithVideoId(videoId, videoWidth, videoHeight, videoStart, videoEnd, 
    () ->
      youtubeGadget.adjustHeightOfGadget()
      callback())

getVideoIdFromWave = ->
  return wave.getState().get("videoId")
  
getVideoWidthFromWave = ->
  return wave.getState().get("videoWidth") || 640

getVideoHeightFromWave = ->
  return wave.getState().get("videoHeight") || 390

youtubeGadget.getVideoStartFromWave = ->
  return wave.getState().get("videoStart") || null

youtubeGadget.getVideoEndFromWave = ->
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
  
youtubeGadget.videoSyncedWithWave = ->
  videoStartTime = getVideoStartTime()
  videoEndTime = getVideoEndTime()
  return videoStartTime == youtubeGadget.getVideoStartFromWave() and videoEndTime == youtubeGadget.getVideoEndFromWave()

getVideoStartTime = ->
  # Acrtionscrit player does not have getIfrae, for now ignoring this case
  if youtubeGadget.youtubePlayer.getIframe? and /start=([0-9]+)/.test(youtubeGadget.youtubePlayer.getIframe().src)
    return parseInt(youtubeGadget.youtubePlayer.getIframe().src.match(/start=([0-9]+)/)[1])
  else
    return null
  
getVideoEndTime = ->
  # Actionscript player does not have getIfrae, for now ignoring this case
  if youtubeGadget.youtubePlayer.getIframe? and /end=([0-9]+)/.test(youtubeGadget.youtubePlayer.getIframe().src)
    return parseInt(youtubeGadget.youtubePlayer.getIframe().src.match(/end=([0-9]+)/)[1])
  else
    return null
    
wave.setStateCallback(tryToLoadVideoFromWave)