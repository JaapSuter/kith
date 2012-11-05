(function() {
  "use strict";

  module.exports = {
    getLocalIPv4s: function() {
      var addrs, i, iface, ifaces, j, os;
      os = require('os');
      ifaces = os.networkInterfaces();
      addrs = [];
      for (i in ifaces) {
        for (j in ifaces[i]) {
          iface = ifaces[i][j];
          if (iface.family === "IPv4" && !iface.internal) {
            addrs.push(iface.address);
          }
        }
      }
      return addrs;
    }
  };

}).call(this);
