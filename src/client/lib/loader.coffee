"use strict";

counter = 0
onReady = null
fragment = document.createDocumentFragment()

load = (src, callback, id, assignCallback) ->
  counter += 1
        
  script = document.createElement("script")
  script.async = true
  script.id = id if id?

  if assignCallback
    assignCallback(callback)
  else
    if script.readyState # IE
      script.onreadystatechange = () ->
        if script.readyState is "loaded" or script.readyState is "complete"
          script.onreadystatechange = null
          callback()
    else # Others
      script.onload = () ->
        callback()

  script.src = src
  fragment.appendChild script

onLoaded = () ->
  counter -= 1
  if counter is 0 and onReady
    onReady()

module.exports.loadWithEvent = (src, id) ->
  load(src, onLoaded, id)

module.exports.loadWithCallback = (src, id, assignCallback) ->
  load(src, onLoaded, id, assignCallback)    

module.exports.ready = (callback) ->
  onReady = callback
  document.body.appendChild fragment
  if counter is 0 and onReady
    onReady()
