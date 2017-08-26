var qs = require('../src');
var assert = require('assert');


describe("qs.streamify", function() {
  it("should just return the object if it is already a stream", function() {
    var t = qs();
    assert.strictEqual(qs.streamify(t), t);
  });

  it("should wrap a non-stream value as a single output stream", function() {
    var results = [];

    return qs.streamify(3)
      .pipe(qs(function(d) {
        results.push(d);
      }))
      .promise()
      .then(function() {
        assert.deepEqual(results, [3]);
      });
  });

  it("should use the value as the created stream's flush value", function() {
    return qs.streamify(3)
      .promise()
      .then(function(v) {
        assert.deepEqual(v, 3);
      });
  });
});
