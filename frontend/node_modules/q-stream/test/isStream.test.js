var qs = require('../src');
var assert = require('assert');
var Transform = require('readable-stream/transform');


describe("qs.isStream", function() {
  it("should determine whether the given value is a stream", function() {
    assert(!qs.isStream(3));
    assert(!qs.isStream(null));
    assert(!qs.isStream(void 0));
    assert(!qs.isStream({pipe: null}));

    assert(qs.isStream(qs()));
    assert(qs.isStream(new Transform()));
  });
});
