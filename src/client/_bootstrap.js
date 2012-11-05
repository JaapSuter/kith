(function() {
  "use strict";

  var ldr;

  ldr = require('client/lib/loader.js');

  ldr.loadWithCallback("//connect.facebook.net/en_US/all.js", "facebook-jssdk", function(callback) {
    return window.fbAsyncInit = callback;
  });

  ldr.loadWithEvent("//ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js");

  ldr.loadWithEvent("/js/index.js");

  ldr.ready(function() {
    return kith.bootstrap();
  });

}).call(this);
