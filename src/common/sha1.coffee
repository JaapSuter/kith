"use strict";

module.exports = (str) ->
    
  # http://kevin.vanzonneveld.net
  # +   original by: Webtoolkit.info (http://www.webtoolkit.info/)
  # + namespaced by: Michael White (http://getsprink.com)
  # +      input by: Brett Zamir (http://brett-zamir.me)
  # +   improved by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
  # *     example 1: sha1('Kevin van Zonneveld');
  # *     returns 1: '54916d2e62f65b3afa6e192e6a601cdbe5cb5897'
  rotate_left = (n, s) ->
    t4 = (n << s) | (n >>> (32 - s))
    t4
      
  #var lsb_hex = function (val) { // Not in use; needed?
  #    var str="";
  #    var i;
  #    var vh;
  #    var vl;
  #
  #    for ( i=0; i<=6; i+=2 ) {
  #      vh = (val>>>(i*4+4))&0x0f;
  #      vl = (val>>>(i*4))&0x0f;
  #      str += vh.toString(16) + vl.toString(16);
  #    }
  #    return str;
  #  };
  cvt_hex = (val) ->
    str = ""
    i = undefined
    v = undefined
    i = 7
    while i >= 0
      v = (val >>> (i * 4)) & 0x0f
      str += v.toString(16)
      i--
    str

  blockstart = undefined
  i = undefined
  j = undefined
  W = new Array(80)
  H0 = 0x67452301
  H1 = 0xEFCDAB89
  H2 = 0x98BADCFE
  H3 = 0x10325476
  H4 = 0xC3D2E1F0
  A = undefined
  B = undefined
  C = undefined
  D = undefined
  E = undefined
  temp = undefined
  str_len = str.length
  word_array = []
  i = 0
  while i < str_len - 3
    j = str.charCodeAt(i) << 24 | str.charCodeAt(i + 1) << 16 | str.charCodeAt(i + 2) << 8 | str.charCodeAt(i + 3)
    word_array.push j
    i += 4
  switch str_len % 4
    when 0
      i = 0x080000000
    when 1
      i = str.charCodeAt(str_len - 1) << 24 | 0x0800000
    when 2
      i = str.charCodeAt(str_len - 2) << 24 | str.charCodeAt(str_len - 1) << 16 | 0x08000
    when 3
      i = str.charCodeAt(str_len - 3) << 24 | str.charCodeAt(str_len - 2) << 16 | str.charCodeAt(str_len - 1) << 8 | 0x80
  word_array.push i
  word_array.push 0  until (word_array.length % 16) is 14
  word_array.push str_len >>> 29
  word_array.push (str_len << 3) & 0x0ffffffff
  blockstart = 0
  while blockstart < word_array.length
    i = 0
    while i < 16
      W[i] = word_array[blockstart + i]
      i++
    i = 16
    while i <= 79
      W[i] = rotate_left(W[i - 3] ^ W[i - 8] ^ W[i - 14] ^ W[i - 16], 1)
      i++
    A = H0
    B = H1
    C = H2
    D = H3
    E = H4
    i = 0
    while i <= 19
      temp = (rotate_left(A, 5) + ((B & C) | (~B & D)) + E + W[i] + 0x5A827999) & 0x0ffffffff
      E = D
      D = C
      C = rotate_left(B, 30)
      B = A
      A = temp
      i++
    i = 20
    while i <= 39
      temp = (rotate_left(A, 5) + (B ^ C ^ D) + E + W[i] + 0x6ED9EBA1) & 0x0ffffffff
      E = D
      D = C
      C = rotate_left(B, 30)
      B = A
      A = temp
      i++
    i = 40
    while i <= 59
      temp = (rotate_left(A, 5) + ((B & C) | (B & D) | (C & D)) + E + W[i] + 0x8F1BBCDC) & 0x0ffffffff
      E = D
      D = C
      C = rotate_left(B, 30)
      B = A
      A = temp
      i++
    i = 60
    while i <= 79
      temp = (rotate_left(A, 5) + (B ^ C ^ D) + E + W[i] + 0xCA62C1D6) & 0x0ffffffff
      E = D
      D = C
      C = rotate_left(B, 30)
      B = A
      A = temp
      i++
    H0 = (H0 + A) & 0x0ffffffff
    H1 = (H1 + B) & 0x0ffffffff
    H2 = (H2 + C) & 0x0ffffffff
    H3 = (H3 + D) & 0x0ffffffff
    H4 = (H4 + E) & 0x0ffffffff
    blockstart += 16
  temp = cvt_hex(H0) + cvt_hex(H1) + cvt_hex(H2) + cvt_hex(H3) + cvt_hex(H4)
  temp.toLowerCase()