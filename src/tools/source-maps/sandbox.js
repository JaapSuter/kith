(function() {
  var foobar;

  console.log('Hello world');

  foobar = function(cb) {
    var s;
    s = 3 + 4;
    return cb("fsdasdfa", s);
  };

  foobar(function(str, i) {
    var n, _i, _results;
    _results = [];
    for (n = _i = 0; 0 <= i ? _i <= i : _i >= i; n = 0 <= i ? ++_i : --_i) {
      _results.push(console.log("" + n + ": " + str));
    }
    return _results;
  });

}).call(this);
