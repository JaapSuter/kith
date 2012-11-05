"use strict";

express = require('express')
passport = require('passport')
passloc = require('passport-local')
flash = require('connect-flash')
exerr = require('express-error')
sha1 = require('../common/sha1.js')
uniqueId = require(__dirname + '/../common/utils.js').uniqueId
getLocalIPv4s = require(__dirname + '/../server/utils.js').getLocalIPv4s
glue = require(__dirname + '/../server/glue.js')

glue.render()

strategy = new passloc.Strategy(
  usernameField: 'cnonce',
  passwordField: 'hash'
  (cnonce, hash, done) ->
    nonce = strategy.closeNonce()
    if hash != sha1(nonce + strategy._password + cnonce)
      return done(null, false)
          
    done null, cnonce
)

strategy._password = 'ken sent me'
strategy.openNonce = () ->
  nonceLen = 16
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

app.use express.logger()
app.use express.compress()
app.use express.cookieParser()
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.session({ secret: '1018' })
app.use flash()
app.use passport.initialize()
app.use passport.session()
app.use app.router
app.use express.static(__dirname + '/../client/public')
app.use express.errorHandler()

app.configure('development', ->
  app.use(exerr.express3(contextLinesCount: 3))
)

localIPv4 = do (localIPv4s = getLocalIPv4s()) -> localIPv4s[localIPv4s.length - 1]

app.get '/', (req, res) -> 
  res.render 'index.jade',
    isAuthenticated: req.isAuthenticated()
    message: req.flash('error')
    nonce: if req.isAuthenticated() then null else strategy.openNonce()    

app.post '/login',  
  passport.authenticate 'local',
    successRedirect: '/'
    failureRedirect: '/'
    failureFlash: 'Invalid Login'

app.get '/logout', (req, res) -> 
  req.logout()
  res.redirect('/')

port = process.env.PORT || 5000

app.listen(port, () ->
  console.log("Listening on " + port)
)