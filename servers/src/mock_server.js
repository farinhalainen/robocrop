const express = require("express");
const config = require("./config");

const mockPlants = require("./mocks/plants.json");
const mockReadings = require("./mocks/readings.json");

const app = express();

app.listen(config.http_server.port, config.http_server.host, () => {
  console.log(`Test server running on ${config.http_server.port}!`);
});

app.all("/*", (req, res, next) => {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "X-Requested-With");
  next();
});

app.get("/plants", (req, res, next) => {
  console.log("got here");
  res.json(mockPlants);
});

app.get("/plants/1/readings", (req, res, next) => {
  res.json(mockReadings);
});
