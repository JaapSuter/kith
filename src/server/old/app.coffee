"use strict";

express = require('express')
passport = require('passport')
passloc = require('passport-local')
flash = require('connect-flash')
expressError = require('express-error')
sha1 = require('../common/sha1.js')
uniqueId = require(__dirname + '/../common/utils.js').uniqueId
getLocalIPv4s = require(__dirname + '/../server/utils.js').getLocalIPv4s
shuffle = require(__dirname + '/../server/utils.js').shuffle
glue = require(__dirname + '/../server/glue.js')

if 'development' == process.env.NODE_ENV
  glue.watch()
else
  glue.render()

strategy = new passloc.Strategy(
  usernameField: 'cnonce'
  passwordField: 'hash',
  (cnonce, hash, done) ->
    nonce = strategy.closeNonce()
    if hash != sha1(nonce + sha1(strategy._password + cnonce))
      unless 'development' == process.env.NODE_ENV
        return done(null, false)
          
    done null, cnonce
)

strategy._password = 'ken sent me'
strategy.openNonce = () ->
  nonceLen = 20
  @_nonce = uniqueId(nonceLen)

strategy.closeNonce = () ->
  nonce = @_nonce
  @_nonce = undefined
  nonce

passport.serializeUser (user, done) -> done null, user
passport.deserializeUser (id, done) -> done null, 'guest'
passport.use(strategy)

app = express()
app.set('views', __dirname + '/../client/views');

hook = 
  callback: (req, res, next) -> next()
  
oneYearInMs = 365 * 24 * 60 * 60 * 1000

app.use express.logger()
app.use hook.callback
app.use express.compress()
app.use express.cookieParser()
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.session({ secret: '1018' })
app.use flash()
app.use passport.initialize()
app.use passport.session()
app.use app.router
app.use express.static(__dirname + '/../client/public', { maxAge: oneYearInMs })

if 'development' == app.get('env')
  app.use(expressError.express3(contextLinesCount: 5))
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));

if 'production' == app.get('env')
  app.use express.errorHandler()
   
localIPv4 = do (localIPv4s = getLocalIPv4s()) -> localIPv4s[localIPv4s.length - 1]

app.get '/', (req, res) -> 
  res.render 'index.jade',
    isAuthenticated: req.isAuthenticated()
    error: req.flash('error')
    nonce: if req.isAuthenticated() then null else strategy.openNonce()
    env: app.get('env')
    hashed: (url) -> glue.hashed(__dirname + '/../client/public/index.html', url)
    
app.post '/login',  
  passport.authenticate 'local',
    successRedirect: '/'
    failureRedirect: '/'
    failureFlash: 'Invalid Login'

app.get '/logout', (req, res) -> 
  req.logout()
  res.redirect('/')

port = process.env.PORT || 5000
server = require('http').createServer(app)
server.listen port, () ->
  console.log("Listening on " + port)

delay = (ms, cb) -> setTimeout cb, ms

shutdown = (okCloser, errCloser) ->
  errCloser ?= okCloser

  hook.callback = (req, res, next) ->
    res.setHeader "Connection", "close"
    res.send 502, "Server is in the process of restarting."
  server.close () ->
    console.log "Server closed..."
    okCloser()
  timeOutInMs = 30 * 1000
  delay timeOutInMs, ->
    console.error "Could not close connections in time, forcefully shutting down"
    errCloser()

process.once 'SIGUSR2', ->
  console.log 'Received kill signal (SIGUSR2), cleaning up ad shutting down.'
  shutdown () ->  
    console.log 'All done, killing self SIGUSR2.'
    process.kill process.pid, 'SIGUSR2'

process.on 'SIGTERM', ->
  console.log "Received kill signal (SIGTERM), cleaning up ad shutting down."
  shutdown (() ->
              console.log 'All done, exiting ok.'
              process.exit()),
           (() ->
             console.error "Could not close connections in time, forcefully shutting down."
             process.exit(1))