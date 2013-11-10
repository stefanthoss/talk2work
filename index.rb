require 'sinatra'
require 'rest-client'
require 'yammer'
require 'mysql2'
require 'yaml'
require 'json'

require_relative 'config/yammer'

class MyApplication < Sinatra::Base

  get '/?' do
    if ENV['RACK_ENV'] == 'production'
      loginurl = "https://www.yammer.com/dialog/oauth?client_id=#{YAMMER_CLIENT_ID}&redirect_uri=#{YAMMER_REDIRECT_URI}"
    else
      loginurl = "/auth/yammer/callback"
    end
    "Hello World! <a href=\"#{loginurl}\">Login</a>"
  end

  get '/auth/yammer/callback' do
    if ENV['RACK_ENV'] == 'production'
      auth_code = params[:code]
      #url = "https://www.yammer.com/oauth2/access_token.json?client_id=#{YAMMER_CLIENT_ID}"
      #token_reponse = RestClient.post(url, code: auth_code)
      url = "https://www.yammer.com/oauth2/access_token.json?client_id=#{YAMMER_CLIENT_ID}&client_secret=#{YAMMER_CLIENT_SECRET}&code=#{auth_code}"
      token_reponse = RestClient.get(url)
      if token_reponse.code != 200
        halt 500, "Invalid response code while authenticating: #{token_reponse.code}"
      end
      oauth_token = JSON.parse(token_reponse.body)['access_token']['token']
      puts "authtoken: #{oauth_token}"
    else
      oauth_token = YAMMER_DEV_TOKEN
    end

    Yammer.configure do |c|
      c.client_id = YAMMER_CLIENT_ID
      c.client_secret = YAMMER_CLIENT_SECRET
    end
    yc = Yammer::Client.new(:access_token => oauth_token)

    network_users = yc.all_users.body
    rtnstr = "Your network #{network_users[0][:network_name]}:<br /><ul>"
    for i in 0..10
      for user in yc.all_users(page: i).body
        rtnstr += "<li>#{user[:id]}: #{user[:full_name]}</li>"
      end
    end
    rtnstr += "</ul>"
    return rtnstr
  end

  get '/map/:car_id' do
    @car_id = params[:car_id]
    erb :map
  end

  get '/map' do
    erb :map
  end

  get '/img/ic_location.png' do
    send_file 'img/ic_location.png'
  end

  get '/map_data.json/:car_id' do
    content_type :json

    # open database connection
    dbconfig = YAML::load(File.open('config/database.yml'))
    client = Mysql2::Client.new(dbconfig)
    
    coords = []
    client.query("SELECT * FROM trips WHERE car_id = #{params[:car_id]}").each(:symbolize_keys => true) do |trip|
      coords << [trip[:end_lat], trip[:end_lng]]
    end
    coords.to_json
  end

  get '/map_data.json' do
    content_type :json

    # open database connection
    dbconfig = YAML::load(File.open('config/database.yml'))
    client = Mysql2::Client.new(dbconfig)
    
    coords = []
    client.query("SELECT * FROM trips").each(:symbolize_keys => true) do |trip|
      coords << [trip[:end_lat], trip[:end_lng]]
    end
    coords.to_json
  end

  get '/directionsmap' do
    erb :directionsmap
  end

  get '/directionsmap_data.json' do
    [[37.419476,-122.140335], [37.332085,-122.030278], [37.38685,-122.036222]].to_json
  end
end
