var q = require('q');
var assert = require('assert');
var domain = require('domain');
var qs = require('../src');
var utils = require('./utils');
var Transform = require('readable-stream/transform');


describe("qs", function() {
  function identity(d, enc, next) {
    next(null, d);
  }

  function tr(transform, flush) {
    var t = new Transform({objectMode: true});
    if (flush) t._flush = flush;
    t._transform = transform || identity;
    return t;
  }

  it("should create a transform stream", function(done) {
    var results = [];
    var r = tr();
    var t = new tr(transform, flush);

    function transform(d, enc, next) {
      results.push(d);
      next();
    }

    function flush() {
      assert.deepEqual(results, [2, 3, 4]);
      done();
    }

    r.pipe(qs(function(d) { return d + 1; }))
     .pipe(t);

    r.push(1);
    r.push(2);
    r.push(3);
    r.push(null);
  });

  it("should fall back to creating an identity transform stream", function(done) {
    var results = [];
    var r = tr();
    var t = new tr(transform, flush);

    function transform(d, enc, next) {
      results.push(d);
      next();
    }

    function flush() {
      assert.deepEqual(results, [1, 2, 3]);
      done();
    }

    r.pipe(qs())
     .pipe(qs({}))
     .pipe(t);

    r.push(1);
    r.push(2);
    r.push(3);
    r.push(null);
  });

  it("should allow both a function and options to be given", function(done) {
    var t = qs({objectMode: true}, function(d) {
      assert.equal(d, 1);
      assert(t._readableState.objectMode);
      assert(t._writableState.objectMode);
      done();
    });

    t.write(1);
  });

  it("should allow its transform functions to return promises", function(done) {
    var results = [];
    var r = tr();
    var t = new tr(transform, flush);

    function transform(d, enc, next) {
      results.push(d);
      next();
    }

    function flush() {
      assert.deepEqual(results, [2, 3, 4]);
      done();
    }

    r.pipe(qs(function(d) {
      return q()
        .delay(0)
        .then(function() { return d + 1; });
    }))
     .pipe(t);

    r.push(1);
    r.push(2);
    r.push(3);
    r.push(null);
  });

  it("should use the stream as the transform function's context", function(done) {
    var s = qs(function(d) {
      assert.strictEqual(this, s);
      done();
    });

    s.write(1);
  });

  it("should use object mode by default", function() {
    var s = qs();
    assert(s._readableState.objectMode);
    assert(s._writableState.objectMode);

    s = qs({objectMode: false});
    assert(!s._readableState.objectMode);
    assert(!s._writableState.objectMode);
  });

  it("should fail its promise if an error occurs", function() {
    var t = qs(utils.err(':('));

    var p = t
      .promise()
      .then(utils.badFulfill(), errback);

    function errback(e) {
      assert(e instanceof Error);
      assert.equal(e.message, ':(');
    }

    t.write(1);
    return p;
  });

  it("should fulfill its promise once all data has been consumed", function() {
    var r = qs();
    var s = r.pipe(qs());

    return q()
      .then(function() { r.push(1); })
      .delay(0)
      .then(function() { assert(!s.promise().isFulfilled()); })
      .then(function() { r.push(null); })
      .delay(0)
      .then(function() { assert(s.promise().isFulfilled()); });
  });

  it("should fulfill its promise with its flush function's result", function() {
    var t = qs()
      .flush(function() {
        return q()
          .delay(0)
          .then(function() { return 23; });
      });

    var p = t
      .promise()
      .then(function(v) {
        assert.equal(v, 23);
      });

    t.end();
    return p;
  });

  it("should use the stream as the flush function's context", function(done) {
    var t = qs()
      .flush(function() {
        assert.strictEqual(t, this);
        done();
      });

    t.end();
  });

  it("should reject its promise if a flush error occurs", function() {
    var t = qs().flush(utils.err(':('));

    var p = t
      .promise()
      .then(utils.badFulfill(), errback);

    t.end();

    function errback(e) {
      assert(e instanceof Error);
      assert.equal(e.message, ':(');
    }

    return p;
  });

  it("should rethrow errors if no promise was asked for", function(done) {
    domain
      .create()
      .on('error', function(e) {
        assert(e instanceof Error);
        assert.equal(e.message, ':(');
        done();
      })
      .run(function() {
        qs(utils.err(':(')).write(1);
      });
  });

  it("should keep 'error' listeners working on their own", function(done) {
    qs(utils.err(':('))
     .on('error', function(e) {
       assert(e instanceof Error);
       assert.equal(e.message, ':(');
       done();
     })
     .write(1);
  });

  it("should keep 'error' listeners working when a promise is used", function() {
    var d1 = q.defer();
    var d2 = q.defer();

    var t = qs(utils.err(':('))
     .on('error', function(e) {
       check(e);
       d1.resolve();
     });

    t.promise()
     .then(utils.badFulfill(), function(e) {
       check(e);
       d2.resolve();
     });

    t.write(1);

    function check(e) {
      assert(e instanceof Error);
      assert.equal(e.message, ':(');
    }

    return q.all([d1.promise, d2.promise]);
  });
});
