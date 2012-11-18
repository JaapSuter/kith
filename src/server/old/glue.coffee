"use strict";

Glue = require 'gluejs'
fs = require 'fs-extra'
uglify = require 'uglify-js2'
cssify = require 'clean-css'
path = require 'path'
cacher = require '../server/cacher.js'

opts = if 'development' == process.env.NODE_ENV
  minify: true
  sourceUrls: false
else
  minify: true
  sourceUrls: false

hashify = (file, contents) ->
  cacher.hashify file, contents, (err, file, contents) ->
    console.log "wrote: #{file}"

css = 
  src: __dirname + "/../client/scss/head.css"
  dst: __dirname + "/../client/public/css/head.css"

  cssifyWithUglyWorkAround: (source) ->
    cssify.process(source.replace /charset/g, 'ch_rset')
          .replace /ch_rset/g, 'charset'
  
  render: () ->
    fs.readFile @src, 'utf8', (err, source) =>
      if opts.minify  
        hashify @dst, @cssifyWithUglyWorkAround(source)
      else
        hashify @dst, source

  watch: () ->
    @render()
    fs.watch @src, (event, filename) =>
      @render()
    

minify = (code) ->
  minified = uglify.minify code, fromString: true
  minified.code

renderer = (name) -> (err, glued) ->
  glued = minify(glued) if opts.minify
  external = name[0] != '_'
  if external
    file = __dirname + "/../client/public/js/#{name}.js"
    hashify(file, glued)
  else
    root =  __dirname + "/../client/public/index.html"
    file = __dirname + "/../client/inline/#{name}.js"

    glued = cacher.hasherify root, glued    
    fs.writeFileSync(file, glued)
    

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
  .replace('socket.io-client', 'window.io')
  .main('src/client/index.js')
        
self = module.exports =

  watch: () ->
    login.watch renderer('_login')
    bootstrap.watch renderer('_bootstrap')
    index.watch renderer('index')
    css.watch()

  render: () ->
    login.render renderer('_login')
    bootstrap.render renderer('_bootstrap')
    index.render renderer('index')
    css.render()

  hashed: (inside, url) ->
    cacher.hashed(inside, url)
    ###
      ext = path.extname file
      dir = path.join __dirname, "../client/public/", path.dirname(file)
      stem = path.join dir, path.basename(file, ext)    
      files = glob.sync(stem + "-*" + ext)
      if files.length == 0
        return "error: #{file} not found"
      if files.length > 1
        return "error: #{file} exists multiple times"
      file = path.join(path.dirname(file), path.basename(files[0])).replace /\\/g, '/'
      return file
    ###