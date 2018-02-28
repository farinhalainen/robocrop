const dgram = require("dgram");

const config = require("./config");
const { get_db, configure_logging, get_banner } = require("./common");

const logger = configure_logging(config.udp_server);

const db = get_db(config);

const server = dgram.createSocket("udp4");

msg = get_banner()
  .concat([
    "",
    `UDP Server listening on ` +
      `${config.udp_server.host}:${config.udp_server.port}`
  ])
  .join("\n");

server.on("listening", () => {
  logger.info(msg);
});

const q = `
  INSERT INTO readings(plant_id, value) VALUES($1, $2);
  UPDATE plants SET "denorm_latest_value"=$2 WHERE id=$1`;
server.on("message", message => {
  var plant_id, value;
  try {
    plant_id = message.readUInt8(); //single byte at position 0
    value = message.readUInt16BE(1); //16 bit unsigned int at positions 2-3
  } catch (ex) {
    logger.error(`${ex}`);
    return;
  }

  db.query(q, [plant_id, value], (err, res) => {
    if (err) {
      logger.error(err.stack);
      return;
    }
    logger.debug(`Inserted plant_id: ${plant_id}, value: ${value}`);
  });
});

server.on("error", err => {
  logger.error(`UPD server error:\n${err.stack}`);
  server.close();
});

server.bind(config.udp_server.port, config.udp_server.host);
