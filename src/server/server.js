(function() {
  var express, port, server;

  express = require('express');

  server = express();

  server.use(express.logger());

  server.get('/', function(req, rsp) {
    return rsp.send('Hello universe...');
  });

  port = process.env.PORT || 5000;

  server.listen(port, function() {
    return console.log("Listening on " + port);
  });

}).call(this);
