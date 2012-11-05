(function() {
  "use strict";

  var counter, fragment, load, onLoaded, onReady;

  counter = 0;

  onReady = null;

  fragment = document.createDocumentFragment();

  load = function(src, callback, id, assignCallback) {
    var script;
    counter += 1;
    script = document.createElement("script");
    script.async = true;
    if (id != null) {
      script.id = id;
    }
    if (assignCallback) {
      assignCallback(callback);
    } else {
      if (script.readyState) {
        script.onreadystatechange = function() {
          if (script.readyState === "loaded" || script.readyState === "complete") {
            script.onreadystatechange = null;
            return callback();
          }
        };
      } else {
        script.onload = function() {
          return callback();
        };
      }
    }
    script.src = src;
    return fragment.appendChild(script);
  };

  onLoaded = function() {
    counter -= 1;
    if (counter === 0 && onReady) {
      return onReady();
    }
  };

  module.exports.loadWithEvent = function(src, id) {
    return load(src, onLoaded, id);
  };

  module.exports.loadWithCallback = function(src, id, assignCallback) {
    return load(src, onLoaded, id, assignCallback);
  };

  module.exports.ready = function(callback) {
    onReady = callback;
    document.body.appendChild(fragment);
    if (counter === 0 && onReady) {
      return onReady();
    }
  };

}).call(this);
