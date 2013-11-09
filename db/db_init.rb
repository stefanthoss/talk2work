require 'mysql2'
require 'yaml'

# This scripts creates all necessary database tables. If the tables already exists, they will be deleted first.

dbconfig = YAML::load(File.open('config/database.yml'))
client = Mysql2::Client.new(dbconfig)

puts "Create table cars..."
results = client.query("DROP TABLE IF EXISTS cars")
results = client.query("CREATE TABLE cars (id INT NOT NULL, name VARCHAR(255), PRIMARY KEY (id))")

puts "Create table trips..."
results = client.query("DROP TABLE IF EXISTS trips")
results = client.query("CREATE TABLE trips (id INT NOT NULL, start_lat DECIMAL(10,6) NOT NULL, start_lng DECIMAL(10,6) NOT NULL, end_lat DECIMAL(10,6) NOT NULL, end_lng DECIMAL(10,6) NOT NULL, PRIMARY KEY (id))")

# puts "Create table coordinates..."
# results = client.query("DROP TABLE IF EXISTS coordinates")
# results = client.query("CREATE TABLE coordinates (id INT NOT NULL AUTO_INCREMENT, lat DECIMAL(10,6) NOT NULL, lng DECIMAL(10,6) NOT NULL, PRIMARY KEY (id))")
