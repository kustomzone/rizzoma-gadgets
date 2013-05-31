(function() {
  var adjustHeightOfGadget, giveWrongUrlWarning, googleDocGadget, loadGoogleDocFromTextBox, loadGoogleDocOnEnter, loadGoogleDocOnPaste, removeTextField, setIFrameSource, showIFrameAndGoogleDocMenuButton, updateQueryString;

  googleDocGadget = window.googleDocGadget || {};

  window.googleDocGadget = googleDocGadget;

  updateQueryString = function(key, value, url) {
    var hash, re, separator;
    if (!url) {
      url = window.location.href;
    }
    re = new RegExp("([?|&])" + key + "=.*?(&|#|$)(.*)", "gi");
    if (re.test(url)) {
      if (typeof value !== "undefined" && value !== null) {
        url.replace(re, '$1' + key + "=" + value + '$2$3');
      } else {
        url.replace(re, "$1$3").replace(/(&|\?)$/, "");
      }
    } else {
      if (typeof value !== "undefined" && value !== null) {
        separator = (url.indexOf("?") !== -1 ? "&" : "?");
        hash = url.split("#");
        url = hash[0] + separator + key + "=" + value;
        if (hash[1]) {
          url += "#" + hash[1];
        }
        url;

      }
    }
    return url;
  };

  loadGoogleDocOnEnter = function() {
    return $('#googleDocUrlText').keyup(function(event) {
      var enterKeyCode;
      enterKeyCode = 13;
      if (event.keyCode === enterKeyCode) {
        return loadGoogleDoc();
      }
    });
  };

  loadGoogleDocOnPaste = function() {
    return $('#googleDocUrlText').on("paste", function() {
      return setTimeout(loadGoogleDocFromTextBox, 0);
    });
  };

  loadGoogleDocFromTextBox = function() {
    var enteredUrl, googleDocLink, googleDocLinkForMinimalUI;
    enteredUrl = $('#googleDocUrlText').val();
    googleDocLink = enteredUrl.trim();
    googleDocLinkForMinimalUI = updateQueryString("rm", "minimal", googleDocLink);
    googleDocGadget.loadGoogleDoc(googleDocLinkForMinimalUI);
    return googleDocGadget.storeGoogleDocUrlInWave(googleDocLinkForMinimalUI);
  };

  googleDocGadget.loadGoogleDoc = function(googleDocLink) {
    removeTextField();
    setIFrameSource(googleDocLink);
    showIFrameAndGoogleDocMenuButton();
    return adjustHeightOfGadget();
  };

  setIFrameSource = function(googleDocLink) {
    return $("#googleDocIFrame").attr("src", googleDocLink);
  };

  removeTextField = function() {
    return $('#googleDocUrlText').remove();
  };

  giveWrongUrlWarning = function(url) {
    return alert("Could not use " + url + ", please check if " + url + " is a google doc url :)");
  };

  showIFrameAndGoogleDocMenuButton = function() {
    return $('#googleDocDiv').show();
  };

  adjustHeightOfGadget = function() {
    return gadgets.window.adjustHeight();
  };

  googleDocGadget.showUrlEnterBox = function() {
    return jQuery('#googleDocUrlText').show();
  };

  loadGoogleDocOnEnter();

  loadGoogleDocOnPaste();

}).call(this);
