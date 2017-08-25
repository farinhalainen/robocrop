module.exports = {
  database: {
    uri: 'postgresql://robocrop:robocrop@localhost:5432/robocrop_dev'
  },
  http_server: {
    host: '0.0.0.0',
    port: 3001,
    log_level: 'debug',
  },
  udp_server: {
    host: '0.0.0.0',
    port: 2391,
    log_level: 'debug',
  }
}
