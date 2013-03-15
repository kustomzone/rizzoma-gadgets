(function() {
  var removeOldWidthAndHeightValues, youtubeGadget;

  youtubeGadget = window.youtubeGadget || {};

  window.youtubeGadget = youtubeGadget;

  youtubeGadget.makeVideoResizable = function() {
    $('#youtubePlayerWithButtons').addClass('youtubePlayerResizable');
    return $('#youtubePlayerWithButtons').resizable({
      aspectRatio: true,
      alsoResize: "#youtubePlayer",
      minWidth: 350,
      resize: function(event, ui) {
        return youtubeGadget.adjustHeightOfGadget();
      },
      stop: function(event, ui) {
        return youtubeGadget.saveNewPlayerSizeToWave(ui.size);
      }
    });
  };

  youtubeGadget.makeVideoUnresizable = function() {
    $('#youtubePlayerWithButtons').removeClass('youtubePlayerResizable');
    $('#youtubePlayerWithButtons').resizable('destroy');
    return removeOldWidthAndHeightValues();
  };

  removeOldWidthAndHeightValues = function() {
    $('#youtubePlayerWithButtons').width('');
    return $('#youtubePlayerWithButtons').height('');
  };

}).call(this);
