(function() {
  "use strict";

  var Glue, bootstrap, common, fs, index, login, minify, opts, renderer, uglify;

  Glue = require('gluejs');

  fs = require('fs');

  uglify = require('uglify-js2');

  opts = 'production' === process.env.NODE_ENV ? {
    minify: false,
    sourceUrls: true
  } : {
    minify: true,
    sourceUrls: false
  };

  minify = function(code) {
    var minified;
    minified = uglify.minify(code, {
      fromString: true
    });
    return minified.code;
  };

  renderer = function(name) {
    return function(err, glued) {
      var dir, inline;
      if (opts.minify) {
        glued = minify(glued);
      }
      inline = name[0] === '_';
      dir = inline ? "inline" : "public/js";
      return fs.writeFileSync(__dirname + ("/../client/" + dir + "/" + name + ".js"), glued);
    };
  };

  common = function() {
    return new Glue().set('debug', opts.sourceUrls).basepath('src')["export"]('kith');
  };

  login = common().basepath('src').include('src/common/sha1.js').include('src/common/utils.js').include('src/client/_login.js').main('src/client/_login.js');

  bootstrap = common().include('src/client/lib/loader.js').include('src/client/_bootstrap.js').main('src/client/_bootstrap.js');

  index = common().include('src/client/lib/bacon.js').include('src/client/lib/bacon.ui.js').include('src/client/index.js').main('src/client/index.js');

  module.exports = {
    watch: function() {
      login.watch(renderer('_login'));
      bootstrap.watch(renderer('_bootstrap'));
      return index.watch(renderer('index'));
    },
    render: function() {
      login.render(renderer('_login'));
      bootstrap.render(renderer('_bootstrap'));
      return index.render(renderer('index'));
    }
  };

}).call(this);
