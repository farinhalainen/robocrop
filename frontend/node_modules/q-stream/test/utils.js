var utils = exports;


utils.err = function(message) {
  return function() {
    throw new Error(message);
  };
};


utils.badFulfill = function() {
  return utils.err('promise should not have been fulfilled');
};
