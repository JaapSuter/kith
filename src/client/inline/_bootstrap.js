(function(){function t(e,o,n){o||(o=0);var r=t.resolve(e,o),i=t.modules[o][r];if(!i)throw Error('failed to require "'+e+'" from '+n);if(i.context&&(o=i.context,r=i.main,i=t.modules[o][i.main],!i))throw Error('failed to require "'+r+'" from '+o);return i.exports||(i.exports={},i.call(i.exports,i,i.exports,t.relative(r,o))),i.exports}t.modules=[{}],t.resolve=function(e,o){var n=e,r=e+".js",i=e+"/index.js";return t.modules[o][r]&&r||t.modules[o][i]&&i||n},t.relative=function(e,o){return function(n){if("."!=n.charAt(0))return t(n,o,e);var r=e.split("/"),i=n.split("/");r.pop();for(var u=0;i.length>u;u++){var a=i[u];".."==a?r.pop():"."!=a&&r.push(a)}return t(r.join("/"),o,e)}},t.modules[0]={"client/_bootstrap.js":function(t,e,o){(function(){"use strict";var t;t=o("client/lib/loader.js"),t.loadWithCallback("//connect.facebook.net/en_US/all.js","facebook-jssdk",function(t){return window.fbAsyncInit=t}),t.loadWithEvent("//ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"),t.loadWithEvent("/js/index.js"),t.ready(function(){return kith.bootstrap()})}).call(this)},"client/lib/loader.js":function(t){(function(){"use strict";var e,o,n,r,i;e=0,i=null,o=document.createDocumentFragment(),n=function(t,n,r,i){var u;return e+=1,u=document.createElement("script"),u.async=!0,r!=null&&(u.id=r),i?i(n):u.readyState?u.onreadystatechange=function(){return u.readyState==="loaded"||u.readyState==="complete"?(u.onreadystatechange=null,n()):void 0}:u.onload=function(){return n()},u.src=t,o.appendChild(u)},r=function(){return e-=1,e===0&&i?i():void 0},t.exports.loadWithEvent=function(t,e){return n(t,r,e)},t.exports.loadWithCallback=function(t,e,o){return n(t,r,e,o)},t.exports.ready=function(t){return i=t,document.body.appendChild(o),e===0&&i?i():void 0}}).call(this)}},kith=t("client/_bootstrap.js")})()