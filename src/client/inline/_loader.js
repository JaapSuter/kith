(function(){function require(p, context, parent){ context || (context = 0); var path = require.resolve(p, context), mod = require.modules[context][path]; if (!mod) throw new Error('failed to require "' + p + '" from ' + parent); if(mod.context) { context = mod.context; path = mod.main; mod = require.modules[context][mod.main]; if (!mod) throw new Error('failed to require "' + path + '" from ' + context); } if (!mod.exports) { mod.exports = {}; mod.call(mod.exports, mod, mod.exports, require.relative(path, context)); } return mod.exports;}require.modules = [{}];require.resolve = function(path, context){ var orig = path, reg = path + '.js', index = path + '/index.js'; return require.modules[context][reg] && reg || require.modules[context][index] && index || orig;};require.relative = function(relativeTo, context) { return function(p){ if ('.' != p.charAt(0)) return require(p, context, relativeTo); var path = relativeTo.split('/') , segs = p.split('/'); path.pop(); for (var i = 0; i < segs.length; i++) { var seg = segs[i]; if ('..' == seg) path.pop(); else if ('.' != seg) path.push(seg); } return require(path.join('/'), context, relativeTo); };};
require.modules[0] = { "client/_loader.js": function(module, exports, require){(function() {
  "use strict";

  var counter, fragment, load, onLoaded, onReady;

  counter = 0;

  onReady = null;

  fragment = document.createDocumentFragment();

  load = function(src, callback, id, assignCallback) {
    var script;
    counter += 1;
    script = document.createElement("script");
    script.async = true;
    if (id != null) {
      script.id = id;
    }
    if (assignCallback) {
      assignCallback(callback);
    } else {
      if (script.readyState) {
        script.onreadystatechange = function() {
          if (script.readyState === "loaded" || script.readyState === "complete") {
            script.onreadystatechange = null;
            return callback();
          }
        };
      } else {
        script.onload = function() {
          return callback();
        };
      }
    }
    script.src = src;
    return fragment.appendChild(script);
  };

  onLoaded = function() {
    counter -= 1;
    if (counter === 0 && onReady) {
      return onReady();
    }
  };

  module.exports.loader = {
    loadWithEvent: function(src, id) {
      return load(src, onLoaded, id);
    },
    loadWithCallback: function(src, id, assignCallback) {
      return load(src, onLoaded, id, assignCallback);
    },
    ready: function(callback) {
      onReady = callback;
      document.body.appendChild(fragment);
      if (counter === 0 && onReady) {
        return onReady();
      }
    }
  };

}).call(this);
}};
kith = require('client/_loader.js');
}());