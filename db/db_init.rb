require 'mysql2'
require 'yaml'

# This scripts creates all necessary database tables. If the tables already exists, they will be deleted first.

dbconfig = YAML::load(File.open('config/database.yml'))

client = Mysql2::Client.new(dbconfig)

puts "Create table coordinates..."
results = client.query("DROP TABLE IF EXISTS coordinates")
results = client.query("CREATE TABLE coordinates (id INT NOT NULL AUTO_INCREMENT, lat DECIMAL(10,6) NOT NULL, lng DECIMAL(10,6) NOT NULL, PRIMARY KEY (id))")
