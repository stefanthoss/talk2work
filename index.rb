require 'sinatra'
require 'rest-client'
require 'yammer'
require 'mysql2'
require 'yaml'
require 'json'

YAMMER_CLIENT_ID = 'wN7Tyzyeo5eXxXe7MP9U2g'
YAMMER_CLIENT_SECRET = 'Fk0njVHhYH59TdaXEVOW69yHl8NIbIdohNgTK75w'
YAMMER_REDIRECT_URI = 'http://192.241.233.188/auth/yammer/callback'
YAMMER_DEV_TOKEN = 'iQhCMcDgfSw7Dk9qKPuUAQ'

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
      url = "https://www.yammer.com/oauth2/access_token.json?client_id=#{YAMMER_CLIENT_ID}"
      token_reponse = RestClient.post(url, code: auth_code)
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
        rtnstr += "<li>#{user[:full_name]}</li>"
      end
    end
    rtnstr += "</ul>"
    return rtnstr
  end

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
end
