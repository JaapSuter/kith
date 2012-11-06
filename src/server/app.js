(function() {
  "use strict";

  var app, delay, express, expressError, flash, getLocalIPv4s, glue, hook, localIPv4, oneYearInMs, passloc, passport, port, server, sha1, shutdown, strategy, uniqueId;

  express = require('express');

  passport = require('passport');

  passloc = require('passport-local');

  flash = require('connect-flash');

  expressError = require('express-error');

  sha1 = require('../common/sha1.js');

  uniqueId = require(__dirname + '/../common/utils.js').uniqueId;

  getLocalIPv4s = require(__dirname + '/../server/utils.js').getLocalIPv4s;

  glue = require(__dirname + '/../server/glue.js');

  if ('development' === process.env.NODE_ENV) {
    glue.watch();
  } else {
    glue.render();
  }

  strategy = new passloc.Strategy({
    usernameField: 'cnonce',
    passwordField: 'hash'
  }, function(cnonce, hash, done) {
    var nonce;
    nonce = strategy.closeNonce();
    if (hash !== sha1(nonce + sha1(strategy._password + cnonce))) {
      return done(null, false);
    }
    return done(null, cnonce);
  });

  strategy._password = 'ken sent me';

  strategy.openNonce = function() {
    var nonceLen;
    nonceLen = 20;
    return this._nonce = uniqueId(nonceLen);
  };

  strategy.closeNonce = function() {
    var nonce;
    nonce = this._nonce;
    this._nonce = void 0;
    return nonce;
  };

  passport.serializeUser(function(user, done) {
    return done(null, user);
  });

  passport.deserializeUser(function(id, done) {
    return done(null, 'guest');
  });

  passport.use(strategy);

  app = express();

  app.set('views', __dirname + '/../client/views');

  hook = {
    callback: function(req, res, next) {
      return next();
    }
  };

  oneYearInMs = 365 * 24 * 60 * 60 * 1000;

  app.use(express.logger());

  app.use(hook.callback);

  app.use(express.compress());

  app.use(express.cookieParser());

  app.use(express.bodyParser());

  app.use(express.methodOverride());

  app.use(express.session({
    secret: '1018'
  }));

  app.use(flash());

  app.use(passport.initialize());

  app.use(passport.session());

  app.use(app.router);

  app.use(express["static"](__dirname + '/../client/public', {
    maxAge: oneYearInMs
  }));

  if ('development' === app.get('env')) {
    app.use(expressError.express3({
      contextLinesCount: 5
    }));
    app.use(express.errorHandler({
      dumpExceptions: true,
      showStack: true
    }));
  }

  if ('production' === app.get('env')) {
    app.use(express.errorHandler());
  }

  localIPv4 = (function(localIPv4s) {
    return localIPv4s[localIPv4s.length - 1];
  })(getLocalIPv4s());

  app.get('/', function(req, res) {
    return res.render('index.jade', {
      isAuthenticated: req.isAuthenticated(),
      error: req.flash('error'),
      nonce: req.isAuthenticated() ? null : strategy.openNonce(),
      env: app.get('env'),
      getHashedUrl: glue.get
    });
  });

  app.post('/login', passport.authenticate('local', {
    successRedirect: '/',
    failureRedirect: '/',
    failureFlash: 'Invalid Login'
  }));

  app.get('/logout', function(req, res) {
    req.logout();
    return res.redirect('/');
  });

  port = process.env.PORT || 5000;

  server = app.listen(port, function() {
    return console.log("Listening on " + port);
  });

  delay = function(ms, cb) {
    return setTimeout(cb, ms);
  };

  shutdown = function(okCloser, errCloser) {
    var timeOutInMs;
    if (errCloser == null) {
      errCloser = okCloser;
    }
    hook.callback = function(req, res, next) {
      res.setHeader("Connection", "close");
      return res.send(502, "Server is in the process of restarting.");
    };
    server.close(function() {
      console.log("Server closed...");
      return okCloser();
    });
    timeOutInMs = 30 * 1000;
    return delay(timeOutInMs, function() {
      console.error("Could not close connections in time, forcefully shutting down");
      return errCloser();
    });
  };

  process.once('SIGUSR2', function() {
    console.log('Received kill signal (SIGUSR2), cleaning up ad shutting down.');
    return shutdown(function() {
      console.log('All done, killing self SIGUSR2.');
      return process.kill(process.pid, 'SIGUSR2');
    });
  });

  process.on('SIGTERM', function() {
    console.log("Received kill signal (SIGTERM), cleaning up ad shutting down.");
    return shutdown((function() {
      console.log('All done, exiting ok.');
      return process.exit();
    }), (function() {
      console.error("Could not close connections in time, forcefully shutting down.");
      return process.exit(1);
    }));
  });

}).call(this);
