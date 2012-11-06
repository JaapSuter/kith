"use strict";

sha1 = require 'common/sha1'
uniqueId = require('common/utils').uniqueId

login = document.getElementById('kith-login-button')
password = document.getElementById('kith-login-password')

onLoginSubmit = (e) ->

  e.preventDefault()
  
  nonce = password.getAttribute('data-nonce')
  cnonce = uniqueId(nonce.length)

  form = document.getElementById('kith-login-form')  
  form.cnonce.value = cnonce
  form.hash.value = sha1(nonce + sha1(password.value + cnonce))
  form.submit()

login.onclick = onLoginSubmit
password.onkeydown = (e) ->
  enterKeyCode = 13
  if e.keyCode == enterKeyCode
    onLoginSubmit(e)

