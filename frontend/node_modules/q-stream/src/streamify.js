var oneshot = require('./oneshot');
var isStream = require('./isStream');
module.exports = streamify;


function streamify(v) {
  if (isStream(v)) return v;
  var t = oneshot();
  t.write(v);
  return t;
}
