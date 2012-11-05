(function() {
  "use strict";

  module.exports = function(str) {
    var A, B, C, D, E, H0, H1, H2, H3, H4, W, blockstart, cvt_hex, i, j, rotate_left, str_len, temp, word_array;
    rotate_left = function(n, s) {
      var t4;
      t4 = (n << s) | (n >>> (32 - s));
      return t4;
    };
    cvt_hex = function(val) {
      var i, v;
      str = "";
      i = void 0;
      v = void 0;
      i = 7;
      while (i >= 0) {
        v = (val >>> (i * 4)) & 0x0f;
        str += v.toString(16);
        i--;
      }
      return str;
    };
    blockstart = void 0;
    i = void 0;
    j = void 0;
    W = new Array(80);
    H0 = 0x67452301;
    H1 = 0xEFCDAB89;
    H2 = 0x98BADCFE;
    H3 = 0x10325476;
    H4 = 0xC3D2E1F0;
    A = void 0;
    B = void 0;
    C = void 0;
    D = void 0;
    E = void 0;
    temp = void 0;
    str_len = str.length;
    word_array = [];
    i = 0;
    while (i < str_len - 3) {
      j = str.charCodeAt(i) << 24 | str.charCodeAt(i + 1) << 16 | str.charCodeAt(i + 2) << 8 | str.charCodeAt(i + 3);
      word_array.push(j);
      i += 4;
    }
    switch (str_len % 4) {
      case 0:
        i = 0x080000000;
        break;
      case 1:
        i = str.charCodeAt(str_len - 1) << 24 | 0x0800000;
        break;
      case 2:
        i = str.charCodeAt(str_len - 2) << 24 | str.charCodeAt(str_len - 1) << 16 | 0x08000;
        break;
      case 3:
        i = str.charCodeAt(str_len - 3) << 24 | str.charCodeAt(str_len - 2) << 16 | str.charCodeAt(str_len - 1) << 8 | 0x80;
    }
    word_array.push(i);
    while ((word_array.length % 16) !== 14) {
      word_array.push(0);
    }
    word_array.push(str_len >>> 29);
    word_array.push((str_len << 3) & 0x0ffffffff);
    blockstart = 0;
    while (blockstart < word_array.length) {
      i = 0;
      while (i < 16) {
        W[i] = word_array[blockstart + i];
        i++;
      }
      i = 16;
      while (i <= 79) {
        W[i] = rotate_left(W[i - 3] ^ W[i - 8] ^ W[i - 14] ^ W[i - 16], 1);
        i++;
      }
      A = H0;
      B = H1;
      C = H2;
      D = H3;
      E = H4;
      i = 0;
      while (i <= 19) {
        temp = (rotate_left(A, 5) + ((B & C) | (~B & D)) + E + W[i] + 0x5A827999) & 0x0ffffffff;
        E = D;
        D = C;
        C = rotate_left(B, 30);
        B = A;
        A = temp;
        i++;
      }
      i = 20;
      while (i <= 39) {
        temp = (rotate_left(A, 5) + (B ^ C ^ D) + E + W[i] + 0x6ED9EBA1) & 0x0ffffffff;
        E = D;
        D = C;
        C = rotate_left(B, 30);
        B = A;
        A = temp;
        i++;
      }
      i = 40;
      while (i <= 59) {
        temp = (rotate_left(A, 5) + ((B & C) | (B & D) | (C & D)) + E + W[i] + 0x8F1BBCDC) & 0x0ffffffff;
        E = D;
        D = C;
        C = rotate_left(B, 30);
        B = A;
        A = temp;
        i++;
      }
      i = 60;
      while (i <= 79) {
        temp = (rotate_left(A, 5) + (B ^ C ^ D) + E + W[i] + 0xCA62C1D6) & 0x0ffffffff;
        E = D;
        D = C;
        C = rotate_left(B, 30);
        B = A;
        A = temp;
        i++;
      }
      H0 = (H0 + A) & 0x0ffffffff;
      H1 = (H1 + B) & 0x0ffffffff;
      H2 = (H2 + C) & 0x0ffffffff;
      H3 = (H3 + D) & 0x0ffffffff;
      H4 = (H4 + E) & 0x0ffffffff;
      blockstart += 16;
    }
    temp = cvt_hex(H0) + cvt_hex(H1) + cvt_hex(H2) + cvt_hex(H3) + cvt_hex(H4);
    return temp.toLowerCase();
  };

}).call(this);
