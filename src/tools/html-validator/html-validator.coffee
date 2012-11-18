'use strict';

request = require 'request'
prettyjson = require 'prettyjson'

module.exports = (html) ->  

  options =
    url: 'http://html5.validator.nu/'
    qs: out: 'json'
    headers: 'Content-Type': 'text/html; charset=utf-8' 
    body: html
    
  request.post options, (err, res, body) ->
    data = JSON.parse body
    console.log prettyjson.render data
    
module.exports(test)
