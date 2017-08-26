var qs = require('./qs');
var _concat = require('concat-stream');
module.exports = concat;


function concat(opts) {
  var t = qs(opts, function(d) { r.push(d); })
  .flush(function() {
    var result = w.getBody();
    this.push(result);
    return result;
  });

  var r = qs()
    .on('error', error);

  var w = r.pipe(_concat(opts || {}))
    .on('error', error);

  function error(e) {
    t.emit('error', e);
  }

  return t;
}
