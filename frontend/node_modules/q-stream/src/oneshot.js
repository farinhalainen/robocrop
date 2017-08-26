var qs = require('./qs');
module.exports = oneshot;


function oneshot(opts) {
  var result;

  var t = qs(opts, function(d) {
    result = d;
    this.end();
    return d;
  })
  .flush(function() {
    return result;
  });

  return t;
}
