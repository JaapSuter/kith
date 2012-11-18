"use strict";

http = require "http"

server = http.createServer (req, rsp) ->
  rsp.writeHead 200, 'Content-Type': 'text/html'
  rsp.end "<html><body><h1>Yo dawg", 'utf-8'


server.listen 5000