require 'mysql2'
require 'yaml'
require 'rest_client'
require 'json'

def rest_call path
  # puts "Querying 'https://dash.carvoyant.com/api#{path}'..."
  return JSON.parse(RestClient::Request.new(
    :method => :get,
    :url =>"https://dash.carvoyant.com/api#{path}",
    :user => "2375ec7d-9859-4139-aca7-1ccb4bd6c970",
    :password => "4d828145-25b9-4853-9cd0-b315f338facd",
    :headers => { :accept => :json, :content_type => :json }).execute.to_str)
end

dbconfig = YAML::load(File.open('config/database.yml'))
client = Mysql2::Client.new(dbconfig)

rest_call("/vehicle")["vehicle"].each do |car|
  puts "\n=== #{car["vehicleId"]}: #{car["name"]} ==="
  client.query("INSERT INTO cars (id, name) VALUES (#{car["vehicleId"]}, '#{car["name"]}')")

  trips = rest_call("/vehicle/#{car["vehicleId"]}/trip")["trip"]
  trips.each do |trip|
    unless trip["startWaypoint"].nil? || trip["endWaypoint"].nil? || trip["startWaypoint"]["latitude"].to_i == 0
      client.query("INSERT INTO trips (id, start_lat, start_lng, end_lat, end_lng) VALUES (#{trip["id"]}, #{trip["startWaypoint"]["latitude"]}, #{trip["startWaypoint"]["longitude"]}, #{trip["endWaypoint"]["latitude"]}, #{trip["endWaypoint"]["longitude"]})")
      puts "#{trip["startWaypoint"]["latitude"]},#{trip["startWaypoint"]["longitude"]} -> #{trip["endWaypoint"]["latitude"]},#{trip["endWaypoint"]["longitude"]}"
    end
  end
end
