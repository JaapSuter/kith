"use strict";

module.exports.bootstrap = () ->
  
  bacon = require 'client/lib/bacon'
  facebookPermissions = "email, read_requests, read_friendlists
    user_groups, user_events, user_hometown, user_interests, user_likes, user_photos, user_relationships, user_relationship_details, user_subscriptions, user_videos
    friends_groups, friends_events, friends_hometown, friends_interests, friends_likes, friends_photos, friends_relationships, friends_relationship_details, friends_subscriptions, friends_videos"

  facebookPermissions = ""

  FB.init
    appId: "517278478301891"
    channelUrl: "//local.jaap.com/channel.html"
    logging: false
    status: false
    cookie: false
    xfbml: false
    
  $facebookAuth = $('#kith-facebook-auth')
  $facebookFriends = $('#kith-facebook-friends')

  onFacebookAuthStatus = (res) ->
    if res.error
      return updateFacebookAuthStatus()
  
    if res.status is 'connected' and res.authResponse?    
      $facebookAuth.removeClass('grey').addClass('blue').removeAttr('disabled')
      $facebookAuth.children('.kith-caption').text('Disconnect')
      $facebookAuth.one 'click', (e) ->
        e.preventDefault()
        $facebookAuth.removeClass('blue').addClass('grey').attr('disabled', true)
        $facebookAuth.children('.kith-caption').text('Disconnecting')
        FB.api "/me/permissions", 'delete', updateFacebookAuthStatus

      updateFriends()
    else
      $facebookAuth.removeClass('grey').addClass('blue').removeAttr('disabled')
      $facebookAuth.children('.kith-caption').text('Connect')
      $facebookAuth.one 'click', (e) ->
        e.preventDefault()
        $facebookAuth.removeClass('blue').addClass('grey').attr('disabled', true)
        $facebookAuth.children('.kith-caption').text('Connecting')
        FB.login(onFacebookAuthStatus, scope: facebookPermissions)
    
  updateFacebookAuthStatus = () ->
    FB.getLoginStatus(onFacebookAuthStatus, true)

  updateFacebookAuthStatus()

  updateFriends = () ->
    FB.api '/me/friends?limit=300', (res) ->
      items = ("<li>#{friend.name}</li>" for friend in res.data).join('')
      $facebookFriends.html("<ul>#{items}</ul>")

  ### 
    FB.getLoginStatus (response) ->
      if response.status is "connected"
        $('#authorize-facebook-status').text('connected')
        $('#authorize-facebook-button').hide()

        FB.api '/me/friends?limit=300', (res) ->
          alert(JSON.stringify(res.data, null, '  '))

      else if response.status is "not_authorized"
        $('#authorize-facebook-status').text('not yet authorized')
        $('#authorize-facebook-button').show()
      else
        $('#authorize-facebook-button').show()
    
    $('#authorize-facebook-status').text('unknown')      
    $('#authorize-facebook-button').show()
    $('#authorize-facebook-button').on('click', facebookLogin)

  
  facebookLogin = () ->
    FB.login (response) ->
      if response.authResponse
        alert('logged in')
  ###

root = exports ? this

if root.kithIndexLoaded
  root.kithIndexLoaded()
