const path = require('path')
const fs = require('fs')
const { Pool } = require('pg')
const winston = require('winston')

const {version, name} = require('../package.json')

const get_db = config => (
  new Pool({ connectionString: config.database.uri})
)

const configure_logging = server_config => {
  if (server_config.log_file) {
    winston.remove(winston.transports.Console);
    winston.add(
      winston.transports.File,
      { filename: server_config.log_file, json: false, timestamp: true }
    )
  }
  winston.level = server_config.log_level
  return winston
}

const get_banner = () => {
  const bannerPath = path.join(__dirname, '..', 'banner.txt');
  const banner = fs.readFileSync(bannerPath, 'ascii');
  lines = [
    banner,
    `${ name }`,
    `Version: ${ version }`,
    '',
    `NODE_ENV: ${ process.env.NODE_ENV || "development" }`,
  ]
  return lines
}

module.exports = {get_db, configure_logging, get_banner}
