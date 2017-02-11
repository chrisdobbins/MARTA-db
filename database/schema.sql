use MARTA;

CREATE TABLE stops(stop_id INT, stop_code INT, stop_name VARCHAR(50), stop_desc VARCHAR(75),
stop_lat DECIMAL (10, 8), stop_lon DECIMAL(10,8), zone_id VARCHAR(5), stop_url VARCHAR(5),
location_type VARCHAR(5), parent_station VARCHAR(5),stop_timezone VARCHAR(5),
wheelchair_boarding INT,
PRIMARY KEY(stop_id));

CREATE TABLE routes(route_id INT, agency_id VARCHAR(25),
route_short_name VARCHAR(5), route_long_name VARCHAR(100),
route_desc VARCHAR(5), route_type INT,
route_url VARCHAR(5), route_color VARCHAR(6), route_text_color VARCHAR(6),
PRIMARY KEY(route_id));

CREATE TABLE trips(route_id INT,service_id INT, trip_id INT,trip_headsign VARCHAR(100),
trip_short_name VARCHAR(5), direction_id INT,block_id INT,shape_id INT,
wheelchair_accessible INT, bikes_allowed INT,
PRIMARY KEY(trip_id),
FOREIGN KEY(route_id) REFERENCES routes (route_id));

CREATE TABLE stop_times(trip_id INT, arrival_time TIME, departure_time TIME,
  stop_id INT, stop_sequence INT, stop_headsign VARCHAR(0),
  pickup_type INT, drop_off_type INT, shape_dist_traveled DECIMAL(8, 5),
  FOREIGN KEY(trip_id) REFERENCES trips (trip_id),
  FOREIGN KEY(stop_id) REFERENCES stops (stop_id));


LOAD DATA LOCAL INFILE '/data/stops.csv'
INTO TABLE stops
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
--

LOAD DATA LOCAL INFILE '/data/routes.csv'
INTO TABLE routes
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
--
LOAD DATA LOCAL INFILE '/data/trips.csv'
INTO TABLE trips
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '/data/stop_times.csv'
INTO TABLE stop_times
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
ALTER TABLE stop_times
  ADD stop_times_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;

-- API user setup
DROP USER IF EXISTS api_user;
CREATE USER 'api_user' IDENTIFIED BY 'f97810eb9a9b4de79b52297d32db4087';
GRANT SELECT ON MARTA.* TO 'api_user'@'%';
