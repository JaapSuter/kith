"use strict";

module.exports =
  getLocalIPv4s: () ->
    os = require('os')
    ifaces = os.networkInterfaces()
    addrs = []
    for i of ifaces
      for j of ifaces[i]
        iface = ifaces[i][j]
        if iface.family is "IPv4" and not iface.internal
          addrs.push iface.address
    addrs
