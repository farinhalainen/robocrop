var defaults = require("./default.js");
var config = require("./" + (process.env.NODE_ENV || "development") + ".js");
module.exports = Object.assign({}, defaults, config);
