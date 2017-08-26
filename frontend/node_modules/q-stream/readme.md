# q-stream

![Build Status](https://api.travis-ci.org/justinvdm/q-stream.png)

simple promise-based streams.


```javascript
var q = require('q');
var qs = require('q-stream');

var r = qs();

r.pipe(qs(function(d) { return d * 10; }))
 .pipe(qs(function(d) { return q(d).delay(200); }))
 .pipe(qs(function(d) { console.log(d); }))
  .flush(function() { return 23; })
  .promise()
   .then(function(d) { console.log(d); })
   .done();

r.push(1);
r.push(2);
r.push(3);
r.push(null);

// 10
// 20
// 30
// 23
```


## install

node:

```
$ npm install q-stream
```


## api

### `qs([opts], [fn])`

Creates a new q-stream based transform stream.

If `opts` is given, it is passed through to the base `Transform` constructor as the options to use to create the stream. In contrast to the base `Transform` constructor and [through2](https://www.npmjs.org/package/through2), q-stream sets `objectMode` to `true` by default (since this mode is used so often).

If `fn` is given, is is used as the transform stream's `_transform` function. `fn` should take the form `function(chunk, enc)`, where `chunk` is the current chunk to be transformed and `enc` is the encoding type if `chunk` is a `string`. In contrast to the original `_transform` function, no callback should be provided. Instead, the return value is used as the result of the chunk's transformation. `fn` may also return a promise fulfulled with the chunk's transformation result. Similar to the original `_transform` function, the transformation result is optional, so a return value does not need to be given.

#### `.flush(fn)`

Sets the function to be invoked as part of the stream's flush. By default, this function is a 'no op'. `fn` is not provided with any arguments, and may optionally provide a return value to be used to be used to resolve the stream's promise. Returns the stream to allow for further chaining.

#### `.promise()`

Returns a promise that will be fulfilled at the end of the stream's flush with the return value of the stream's flush function result. Note that the promise will be fulfilled just before the stream's `'end'` event is emitted.

If an error occured inside the stream or inside the stream's flush function, the promise will be rejected with the error that occured.

Note that if `.promise()` is never invoked, errors occuring in the stream will be rethrown. However, if `.promise()` *is* invoked, the errors will no longer be rethrown, and it is the programmer's responsibility the returned promise properly. See q's [`promise.done`](https://github.com/kriskowal/q/wiki/API-Reference#promisedoneonfulfilled-onrejected-onprogress) for how to handle the returned promise.


### `qs.concat([opts])`

Returns a new transform stream that accepts reads in data from a readable stream and sends out the data concatenated into a single output value.

```javascript
var s = qs();
s.pipe(qs.concat())
 .pipe(qs(function(d) { console.log(d); }));

s.push([1]);
s.push([2, 3]);
s.push(null);

// [ 1, 2, 3 ]
```

`qs.concat()` is a thin wrapper around [concat-stream](https://github.com/maxogden/concat-stream), but works a little differently. `concat-stream` is a writeable stream that would usually be found at the end of a readable stream's chain of `.pipe()`s, with the given callback function allowing the concatenated result to be retrieved. Further piping isn't possible, since it is a writeable-only stream. `qs.concat()` also expects to be used as part of a readable stream's chain of `pipe()`s, but its output can be piped into other streams (as shown in the example above).

`qs.concat()`'s promise is also fulfilled with the concatenation result for cases where further piping isn't necessary:

```javascript
var s = qs();
s.pipe(qs.concat())
 .promise()
 .then(function(v) { console.log(v); })
 .done();

s.push([1]);
s.push([2, 3]);
s.push(null);

// [ 1, 2, 3 ]
```

If `opts` is given, it is passed through to both the newly created stream, and to its internal [concat-stream](https://github.com/maxogden/concat-stream).


### `qs.oneshot([opts])`

Returns a new transform stream that accepts only a single value to be written before ending. The stream's promise is also fulfilled with the same single value.

```javascript
var t = qs.oneshot();

t.promise()
 .then(function(v) { console.log(v); })
 .done();

t.write('I am done now');

// I am done now
```

If `opts` is given, it is passed through to the newly created stream.


### `qs.streamify(v)`

Returns a [oneshot](#qsoneshotopts) stream with the given value `v` already written to it. If `v` is a stream, it instead simply returned.

```javascript
qs.streamify(23)
  .pipe(qs(function(d) { console.log(d); }));

// 23
```

### `qs.isStream(v)`

Returns whether `v` is a stream or not. If `v` contains `'pipe'` as a function property, it assumed to be a stream.

```javascript
console.log(qs.isStream(1));  // false
console.log(qs.isStream(qs()));  // true
```
