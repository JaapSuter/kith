"use strict";

Glue = require 'gluejs'
fs = require 'fs'
uglify = require 'uglify-js2'

opts = 
  minify: true
  sourceUrls: false

minify = (code) ->
  minified = uglify.minify code, fromString: true
  minified.code

renderer = (name) -> (err, glued) ->
  glued = minify(glued) if opts.minify
  inline = name[0] == '_'
  dir = if inline then "inline" else "public/js"
  fs.writeFileSync(__dirname + "/../client/#{dir}/#{name}.js", glued)

common = () ->
  new Glue()    
    .set('debug', opts.sourceUrls)
    .basepath('src')
    .export('kith')
  

login = common()
  .basepath('src')
  .include('src/common/sha1.js')
  .include('src/common/utils.js')
  .include('src/client/_login.js')
  .main('src/client/_login.js')  
  
bootstrap = common()
  .include('src/client/lib/loader.js')
  .include('src/client/_bootstrap.js')
  .main('src/client/_bootstrap.js')

index = common()
  .include('src/client/lib/bacon.js')
  .include('src/client/lib/bacon.ui.js')
  .include('src/client/index.js')
  .main('src/client/index.js')
        
module.exports = 
  watch: () ->
    login.watch renderer('_login')
    bootstrap.watch renderer('_bootstrap')
    index.watch renderer('index')    
  render: () ->
    login.render renderer('_login')
    bootstrap.render renderer('_bootstrap')
    index.render renderer('index')
    
