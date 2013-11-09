require 'rest_client'
require 'json'

def get_rest_call path
  # puts "Querying 'https://dash.carvoyant.com/api#{path}'..."
  return JSON.parse(RestClient::Request.new(
    :method => :get,
    :url =>"https://dash.carvoyant.com/api#{path}",
    :user => "2375ec7d-9859-4139-aca7-1ccb4bd6c970",
    :password => "4d828145-25b9-4853-9cd0-b315f338facd",
    :headers => { :accept => :json, :content_type => :json }).execute.to_str)
end

cars = get_rest_call("/vehicle")["vehicle"]

cars.each do |car|
  # puts "\n=== #{car["vehicleId"]}: #{car["name"]} ==="
  trips = get_rest_call("/vehicle/#{car["vehicleId"]}/trip")["trip"]
  trips.each do |trip|
    # puts "#{trip["startWaypoint"]["latitude"]},#{trip["startWaypoint"]["longitude"]} -> #{trip["endWaypoint"]["latitude"]},#{trip["endWaypoint"]["longitude"]}"
    puts "#{trip["startWaypoint"]["latitude"]},#{trip["startWaypoint"]["longitude"]}"
    puts "#{trip["endWaypoint"]["latitude"]},#{trip["endWaypoint"]["longitude"]}"
  end
end
