var q = require('q');
var qs = require('../src');
var assert = require('assert');


describe("qs.oneshot", function() {
  it("should end the stream after the chunk", function() {
    var t = qs.oneshot();

    return q()
      .delay(0)
      .then(function() {
        assert(!t.promise().isFulfilled());
        t.write(1);
        return t.promise();
      });
  });

  it("should fulfill the stream's promise with the first chunk", function() {
    var t = qs.oneshot();
    t.write(1);

    return t
      .promise()
      .then(function(v) {
        assert.equal(v, 1);
      });
  });

  it("should pass through the given stream options", function() {
    var t = qs.oneshot({objectMode: false});
    assert(!t._readableState.objectMode);
    assert(!t._writableState.objectMode);
  });
});
