var q = require('q');
var util = require('util');
var Transform = require('readable-stream/transform');
module.exports = qs;


function qs(fn, opts) {
  var sw;
  if (typeof fn != 'function') sw = opts, opts = fn, fn = sw;

  fn = fn || identity;
  opts = opts || {};
  if (!('objectMode' in opts)) opts.objectMode = true;

  var promised = false;
  var d = q.defer();

  var flush = noop;
  var t = new QTransform(opts);
  t._transform = transform(t, fn);

  t._flush = function(done) {
    q.try(flush)
     .then(function(result) { d.resolve(result); })
     .nodeify(done);
  };

  t.flush = function(fn) {
    flush = (fn || noop).bind(t);
    return t;
  };

  t.promise = function() {
    if (!promised) {
      t.on('error', reject);
      promised = true;
    }

    return d.promise;
  };

  function reject(e) {
    d.reject(e);
  }

  return t;
}


function transform(t, fn) {
  fn = fn.bind(t);

  return function(d, enc, next) {
    q.fcall(fn.bind(this), d, enc)
     .nodeify(next);
  };
}


function identity(v) {
  return v;
}


function noop() {
}


function QTransform() {
  Transform.apply(this, arguments);
}


util.inherits(QTransform, Transform);
