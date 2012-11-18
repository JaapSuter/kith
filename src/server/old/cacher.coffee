"use strict";

path = require 'path'
fs = require 'fs'
glob = require 'glob'
crypto = require 'crypto'

root = path.normalize __dirname + "/../client/public/"

hashify = (file, contents, callback) ->
  file = path.normalize file
  ext = path.extname file
  stem = path.join path.dirname(file), path.basename(file, ext)

  for existing in glob.sync(stem + '-*' + ext)
    fs.unlink existing

  md5 = crypto.createHash('md5').update(contents).digest('hex')
  
  file = stem + '-' + md5 + ext

  fs.writeFile file, contents, 'utf8', (err) =>
    callback(err, file, contents)

hashed = (inside, url) ->  
  
  file = if url[0] == '/'
    path.normalize path.join root, url
  else
    path.normalize path.resolve inside, url
  
  ext = path.extname file
  stem = path.join path.dirname(file), path.basename(file, ext)

  files = glob.sync(stem + "-*" + ext)
  
  if files.length == 0
    "error: #{url} not found"
  else if files.length > 1
    "error: #{url} exists multiple times"
  else
    path.dirname(url) + "/" + path.basename(files[0])

hasherify = (inside, str) ->
  str.replace /@{([^}]+)}/g, (match, url) ->
    hashed inside, url

module.exports = 
  hashify: hashify
  hashed: hashed
  hasherify: hasherify
