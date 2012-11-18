(function() {
  'use strict';

  var prettyjson, request;

  request = require('request');

  prettyjson = require('prettyjson');

  module.exports = function(html) {
    var options;
    options = {
      url: 'http://html5.validator.nu/',
      qs: {
        out: 'json'
      },
      headers: {
        'Content-Type': 'text/html; charset=utf-8'
      },
      body: html
    };
    return request.post(options, function(err, res, body) {
      var data;
      data = JSON.parse(body);
      return console.log(prettyjson.render(data));
    });
  };

  module.exports(test);

}).call(this);
