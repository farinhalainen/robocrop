-- Database: robocrop_db

-- DROP DATABASE robocrop_db;

CREATE DATABASE robocrop_db
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'en_GB.UTF-8'
       LC_CTYPE = 'en_GB.UTF-8'
       CONNECTION LIMIT = -1;
GRANT CONNECT, TEMPORARY ON DATABASE robocrop_db TO public;
GRANT ALL ON DATABASE robocrop_db TO postgres;
GRANT ALL ON DATABASE robocrop_db TO robocrop;

\connect robocrop_db;
CREATE TABLE plants
(
  id bigserial NOT NULL,
  name text NOT NULL,
  threshold smallint NOT NULL DEFAULT 512,
  genus text,
  room text,
  CONSTRAINT pk_plant PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE plants
  OWNER TO robocrop;

CREATE TABLE readings
(
  plant_id bigint NOT NULL,
  value smallint NOT NULL,
  created_at timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT ok_readings PRIMARY KEY (plant_id, created_at),
  CONSTRAINT fk_plant_id FOREIGN KEY (plant_id)
      REFERENCES plants (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE readings
  OWNER TO robocrop;

