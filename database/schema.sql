use MARTA;

DROP TABLE IF EXISTS stops, routes, trips, stop_times;

CREATE TABLE stops(stop_id INT, stop_code INT, stop_name VARCHAR(50),
stop_lat DECIMAL (10, 8), stop_lon DECIMAL(10,8),
PRIMARY KEY (stop_id) );

CREATE TABLE routes(route_id VARCHAR(8),
route_short_name VARCHAR(10), route_long_name VARCHAR(100),
route_desc VARCHAR(5), route_type INT,
route_url VARCHAR(5), route_color VARCHAR(6), route_text_color VARCHAR(6),
PRIMARY KEY (route_id) );

CREATE TABLE trips(route_id VARCHAR(8),service_id INT, trip_id INT,trip_headsign VARCHAR(100),
direction_id INT,block_id INT,shape_id INT,
PRIMARY KEY (trip_id),
FOREIGN KEY (route_id) REFERENCES routes (route_id));

CREATE TABLE stop_times(trip_id INT, arrival_time TIME, departure_time TIME,
  stop_id INT, stop_sequence INT,
  FOREIGN KEY (trip_id) REFERENCES trips (trip_id),
  FOREIGN KEY (stop_id) REFERENCES stops (stop_id) );


LOAD DATA LOCAL INFILE '/data/stops.csv'
INTO TABLE stops
FIELDS TERMINATED BY ','
-- LINES TERMINATED BY '\n'
IGNORE 1 LINES;
--

LOAD DATA LOCAL INFILE '/data/routes.csv'
INTO TABLE routes
FIELDS TERMINATED BY ','
IGNORE 1 LINES;
--
LOAD DATA LOCAL INFILE '/data/trips.csv'
INTO TABLE trips
FIELDS TERMINATED BY ','
-- LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '/data/stop_times.csv'
INTO TABLE stop_times
FIELDS TERMINATED BY ','
-- LINES TERMINATED BY '\n'
IGNORE 1 LINES;
ALTER TABLE stop_times
  ADD stop_times_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;

-- API user setup
DROP USER IF EXISTS api_user;
CREATE USER 'api_user' IDENTIFIED BY 'f97810eb9a9b4de79b52297d32db4087';
GRANT SELECT ON MARTA.* TO 'api_user'@'%';
