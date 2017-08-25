const express = require('express')

const config = require('./config')
const {get_db, configure_logging, get_banner} = require('./common')

const logger = configure_logging(config.http_server)

const db = get_db(config)

//=============================================================================
// Server config
//=============================================================================

const app = express()

banner_msg = get_banner().concat([
  '',
  `HTTP Server listening on ` +
  `${ config.http_server.host }:${ config.http_server.port }`,
]).join('\n')

app.listen(config.http_server.port, config.http_server.host, () => {
    logger.info(banner_msg)
})

//=============================================================================
// Routes
//=============================================================================

//CORS
app.all('/*', function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "X-Requested-With");
  next()
});

app.get('/', (req, res) => {
  res.json({
    'endpoints': [
      '/plants',
      '/plants/{id}',
      '/plants/{id}/readings',
      '/plants/{id}/hourly-readings',
      '/readings',
      '/hourly-readings',
    ]
  })
})

app.get('/plants', (req,  res, next) => {
  const { offset, limit } = get_offset_limit(config, req)
  db.query(all_plants_q, [offset, limit], (err, result) => {
    if (err) return next(err)
    plants = serialise_plants(result.rows)
    res.json({ plants })
  })
})

app.get('/plants/:id', (req,  res, next) => {
  db.query(single_plant_q, [req.params.id], (err, result) => {
    if (err) return next(err)
    if (result.rows.length == 0)
      return next(res.status(404).send({ error: 'Not Found.' }))
    res.json(serialise_plant(result.rows[0]))
  })
})

app.get('/plants/:id/readings', (req,  res, next) => {
  const { offset, limit } = get_offset_limit(config, req)
  db.query(plant_readings_q, [req.params.id, offset, limit], (err, result) => {
    if (err) return next(err)
    res.json(serialise_readings(result.rows))
  })
})

app.get('/plants/:id/hourly-readings', (req,  res, next) => {
  const { offset, limit } = get_offset_limit(config, req)
  db.query(
    plant_hourly_readings_q, [req.params.id, offset, limit],
    (err, result) => {
    if (err) return next(err)
    res.json(serialise_readings(result.rows))
  })
})

app.get('/readings', (req,  res, next) => {
  const { offset, limit } = get_offset_limit(config, req)
  db.query(all_readings_q, [offset, limit], (err, result) => {
    if (err) return next(err)
    res.json(serialise_readings(result.rows))
  })
})

app.get('/hourly-readings', (req,  res, next) => {
  const { offset, limit } = get_offset_limit(config, req)
  db.query(all_hourly_readings_q, [offset, limit], (err, result) => {
    if (err) return next(err)
    res.json(serialise_readings(result.rows))
  })
})

//=============================================================================
// Queries
//=============================================================================

const all_plants_q = `
  select
    r1.created_at, r1.value,
    plants.name, plants.threshold, plants.id,
    plants.room, plants.species
  from
    readings r1
  left join
    readings r2
    on (r1.plant_id = r2.plant_id and r1.created_at < r2.created_at)
  join plants
    on (plants.id = r1.plant_id)
  where r2.plant_id is null
  offset $1
  limit $2`

const single_plant_q = `
  select
    r1.created_at, r1.value,
    plants.name, plants.threshold, plants.id,
    plants.room, plants.species
  from
    readings r1
  left join
    readings r2
    on (r1.plant_id = r2.plant_id and r1.created_at < r2.created_at)
  join plants
    on (plants.id = r1.plant_id)
  where r2.plant_id is null and plants.id = $1;`


const plant_readings_q = `
  select *
  from readings
  where plant_id = $1
  order by created_at desc
  offset $2
  limit $3`

const readings_per_hour = `
  select
    q.plant_id, q.created_at, q.value
  from
    (
      select plant_id, max(created_at) as created_at
      from readings group by plant_id, date_part('hour', created_at)
    ) latest_per_hour
  join
    readings q
    on latest_per_hour.plant_id = q.plant_id
    and latest_per_hour.created_at = q.created_at`

const all_hourly_readings_q = readings_per_hour + `
  order by created_at desc
  offset $1
  limit $2`

const plant_hourly_readings_q = readings_per_hour + `
  where q.plant_id = $1
  order by created_at desc
  offset $2
  limit $3`

const all_readings_q = `
  select * from readings
  order by created_at desc
  offset $1
  limit $2`

//=============================================================================
// Serialisers
//=============================================================================

const serialise_plants = list => (list.map(serialise_plant))

const serialise_plant =
  ({id, name, room, species, value, created_at, threshold}) =>
    ({
      id: parseInt(id),
      name,
      room,
      species,
      latestValue: value,
      latestReadingAt: created_at,
      threshold,
    })

const serialise_readings = list => (list.map(serialise_reading))

const serialise_reading =
  ({value, created_at, plant_id}) =>
    ({
      plant_id: parseInt(plant_id),
      value,
      time: created_at,
    })

//=============================================================================
// Helpers
//=============================================================================

app.use(function (err, req, res, next) {
  logger.error(err)
  res.status(500).send({ error: 'Something broke.' })
})

const get_offset_limit = (config, req) => {
  const offset = req.query.offset || '0'
  const default_limit = config.http_server.default_limit
  const max_limit = config.http_server.max_limit
  const limit = Math.min(parseInt(req.query.limit || default_limit), max_limit)
  return { offset, limit }
}
