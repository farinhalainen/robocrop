module.exports = isStream;


function isStream(v) {
  return typeof (v || 0).pipe == 'function';
}
