require 'mysql2'
require 'yaml'

dbconfig = YAML::load(File.open('config/database.yml'))
client = Mysql2::Client.new(dbconfig)

yammerids = [
  1508111935,
  1489269123,
  9847577,
  1495442374,
]
usernames = [
  'Tobias Jones',
  'Jessica Johnson',
  'Gregory Love',
  'Neil McCarthy',
]
latitudes = [
  34.046241,
  34.082264,
  34.135234,
  34.150490,
]
longitudes = [
  -118.529704,
  -118.434829,
  -118.413425,
  -118.397160,
]
addresses = [
  '830 Radcliffe Avenue, Los Angeles, CA, USA',
  '134 N Beverly Glen Blvd, Los Angeles, CA, USA',
  '3499 Coldwater Canyon Avenue, Los Angeles, CA, USA',
  '12117 Moorpark Street, Los Angeles, CA, USA',
]
talkingpoints = [
  'last nights HIMYM',
  'secret company project',
  'bitch about boss',
  'Obamacare',
]

usernames.each_with_index do |name, i|
  client.query("INSERT INTO users (id, name, lat, lon, address, talkingpoint) VALUES (#{yammerids[i]}, '#{usernames[i]}', #{latitudes[i]}, #{longitudes[i]}, '#{addresses[i]}', '#{talkingpoints[i]}')")
end


