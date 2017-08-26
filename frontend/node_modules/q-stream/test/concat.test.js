var qs = require('../src');
var utils = require('./utils');
var assert = require('assert');


describe("qs.concat", function() {
  it("should concatenate data", function(done) {
    var t = qs();

    t.pipe(qs.concat())
     .pipe(qs(function(d) {
       assert.deepEqual(d, [1, 2, 3]);
       done();
     }));

    t.push([1]);
    t.push([2]);
    t.push([3]);
    t.push(null);
  });

  it("should resolve with the concatenated data", function() {
    var t = qs();

    var p = t.pipe(qs.concat())
     .promise()
     .then(function(d) {
       assert.deepEqual(d, [1, 2, 3]);
     });

    t.push([1]);
    t.push([2]);
    t.push([3]);
    t.push(null);

    return p;
  });

  it("should take responsiblity of concat errors", function() {
    var t = qs();

    var p = t.pipe(qs.concat())
     .promise()
     .then(utils.badFulfill(), function(e) {
       assert(e instanceof Error);
     });

    t.push([1]);
    t.push([2]);
    t.push(8);
    t.push(null);

    return p;
  });

  it("should pass through the given stream options", function() {
    var t = qs.concat({objectMode: false});
    assert(!t._readableState.objectMode);
    assert(!t._writableState.objectMode);
  });
});
