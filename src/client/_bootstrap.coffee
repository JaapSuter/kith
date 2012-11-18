"use strict";

ldr = require 'client/lib/loader.js'

ldr.loadWithCallback "//connect.facebook.net/en_US/all.js", "facebook-jssdk", (callback) -> window.fbAsyncInit = callback
ldr.loadWithEvent "//ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"
ldr.loadWithCallback "@{/js/index.js}", (callback) -> window.kithIndexLoaded = callback
ldr.ready () ->
  kith.bootstrap()