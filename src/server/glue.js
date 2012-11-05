(function() {
  "use strict";

  var Glue, bootstrap, common, css, cssify, fs, index, login, minify, opts, renderer, uglify;

  Glue = require('gluejs');

  fs = require('fs-extra');

  uglify = require('uglify-js2');

  cssify = require('clean-css');

  opts = 'development' === process.env.NODE_ENV ? {
    minify: false,
    sourceUrls: true
  } : {
    minify: true,
    sourceUrls: false
  };

  css = {
    src: __dirname + "/../client/scss/head.css",
    dst: __dirname + "/../client/public/css/head.css",
    cssifyWithUglyWorkAround: function(source) {
      return cssify.process(source.replace(/charset/g, 'ch_rset')).replace(/ch_rset/g, 'charset');
    },
    render: function() {
      var _this = this;
      if (opts.minify) {
        return fs.readFile(this.src, 'utf8', function(err, source) {
          return fs.writeFile(_this.dst, _this.cssifyWithUglyWorkAround(source), 'utf8', function(err) {
            return console.log('Wrote: ' + _this.dst);
          });
        });
      } else {
        return fs.copy(this.src, this.dst);
      }
    },
    watch: function() {
      var _this = this;
      this.render();
      return fs.watch(this.src, function(event, filename) {
        return _this.render();
      });
    }
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
      index.watch(renderer('index'));
      return css.watch();
    },
    render: function() {
      login.render(renderer('_login'));
      bootstrap.render(renderer('_bootstrap'));
      index.render(renderer('index'));
      return css.render();
    }
  };

}).call(this);
