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
var http = require('http');
var fs = require('fs');
var index = fs.readFileSync('index.html');

http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end(index);
}).listen(9615);