(function() {
  'use strict';

  var child, exec, execFile, jar, java, path;

  execFile = require('child_process').execFile;

  exec = require('child_process').exec;

  path = require('path');

  java = path.normalize('C:/Program Files (x86)/Java/jre7/bin/java.exe');

  jar = path.normalize(__dirname + '/bin/compiler.jar');

  child = execFile(java, ['-jar', jar, '--help'], function(error, stdout, stderr) {
    console.log('stdout: ' + stdout);
    console.log('stderr: ' + stderr);
    if (error !== null) {
      return console.log('exec error: ' + error);
    }
  });

}).call(this);
