require 'mysql2'
require 'yaml'

dbconfig = YAML::load(File.open('config/database.yml'))
client = Mysql2::Client.new(dbconfig)

yammerids = [
  1508111935,
  1489269123,
  1487902075,
  6587423,
]
usernames = [
  'Tobias Jones',
  'John Doe',
  'Michael Fynch',
  'Jane Miller',
]
latitudes = [
  37.454965,
  37.454965,
  37.454965,
  37.454965,
]
longitudes = [
  -122.14399,
  -122.14399,
  -122.14399,
  -122.14399,
]
addresses = [
  'address 1',
  'address 2',
  'address 3',
  'address 4',
]
talkingpoints = [
  'last nights HIMYM',
  'super secret company project',
  'bitch about boss',
  'Obamacare',
]

usernames.each_with_index do |name, i|
  client.query("INSERT INTO users (id, name, lat, lon, address, talkingpoint) VALUES (#{yammerids[i]}, '#{usernames[i]}', #{latitudes[i]}, #{longitudes[i]}, '#{addresses[i]}', '#{talkingpoints[i]}')")
end


