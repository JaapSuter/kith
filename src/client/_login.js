(function() {
  "use strict";

  var login, onLoginSubmit, password, sha1, uniqueId;

  sha1 = require('common/sha1');

  uniqueId = require('common/utils').uniqueId;

  login = document.getElementById('kith-login-button');

  password = document.getElementById('kith-login-password');

  onLoginSubmit = function(e) {
    var cnonce, form, nonce;
    e.preventDefault();
    nonce = password.getAttribute('data-nonce');
    cnonce = uniqueId(nonce.length);
    form = document.getElementById('kith-login-form');
    form.cnonce.value = cnonce;
    form.hash.value = sha1(nonce + password.value + cnonce);
    return form.submit();
  };

  login.onclick = onLoginSubmit;

  password.onkeydown = function(e) {
    var enterKeyCode;
    enterKeyCode = 13;
    if (e.keyCode === enterKeyCode) {
      return onLoginSubmit();
    }
  };

}).call(this);
