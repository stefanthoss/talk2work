require 'mysql2'
require 'yaml'
require 'json'

require './index'


get '/map' do
  erb :map
end

get '/js/GeoJSON.js' do
  send_file 'js/GeoJSON.js'
end

get '/map_data.json' do
  content_type :json

  # open database connection
  dbconfig = YAML::load(File.open('config/database.yml'))
  client = Mysql2::Client.new(dbconfig)
  
  coords = []
  client.query("SELECT * FROM trips").each(:symbolize_keys => true) do |trip|
    coords << [trip[:end_lng], trip[:end_lat]]
  end

  JSON.generate({ type: "MultiPoint", coordinates: coords })
end

run Sinatra::Application
