require 'mysql2'
require 'yaml'

# This scripts creates all necessary database tables. If the tables already exists, they will be deleted first.

dbconfig = YAML::load(File.open('config/database.yml'))
client = Mysql2::Client.new(dbconfig)

puts "Create table cars..."
results = client.query("DROP TABLE IF EXISTS cars")
results = client.query("CREATE TABLE cars (id INT NOT NULL, user_id INT, car_name VARCHAR(255), avg_fuel_rate FLOAT, PRIMARY KEY (id))")

puts "Create table trips..."
results = client.query("DROP TABLE IF EXISTS trips")
results = client.query("CREATE TABLE trips (id INT NOT NULL, car_id INT NOT NULL, start_lat FLOAT(10,6) NOT NULL, start_lng FLOAT(10,6) NOT NULL, end_lat FLOAT(10,6) NOT NULL, end_lng FLOAT(10,6) NOT NULL, PRIMARY KEY (id))")

# puts "Create table coordinates..."
# results = client.query("DROP TABLE IF EXISTS coordinates")
# results = client.query("CREATE TABLE coordinates (id INT NOT NULL AUTO_INCREMENT, lat FLOAT(10,6) NOT NULL, lng FLOAT(10,6) NOT NULL, PRIMARY KEY (id))")
puts "Create table users..."
results = client.query("DROP TABLE IF EXISTS users")
results = client.query("CREATE TABLE users (id INT NOT NULL, name VARCHAR(100) NOT NULL, lat FLOAT(10,6) NOT NULL, lon FLOAT(10,6) NOT NULL, address VARCHAR(255) NOT NULL, yammeroauth VARCHAR(22) NULL DEFAULT NULL, talkingpoint VARCHAR(255) NULL, rewards INT NOT NULL DEFAULT 0, PRIMARY KEY (id))")
