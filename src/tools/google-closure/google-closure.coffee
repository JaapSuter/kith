'use strict';

execFile = require('child_process').execFile
exec = require('child_process').exec
path = require('path')


java = path.normalize 'C:/Program Files (x86)/Java/jre7/bin/java.exe'
jar = path.normalize __dirname + '/bin/compiler.jar'

child = execFile java, ['-jar', jar, '--help'], (error, stdout, stderr) ->
    console.log 'stdout: ' + stdout
    console.log 'stderr: ' + stderr
    if error != null
      console.log 'exec error: ' + error