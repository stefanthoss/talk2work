require 'sinatra'
require 'rest-client'
require 'yammer'
require 'mysql2'
require 'yaml'
require 'json'

require_relative 'config/yammer'

module Helpers
  def current_user
    mysqlcon.query("SELECT * FROM users WHERE id = #{session[:userid]}").first
  end
end

class MyApplication < Sinatra::Base
  use Rack::Session::Cookie, :secret => 'eeVoowungahngaone3an4ohViitu6iex'
  helpers Helpers

  get '/?' do
    if ENV['RACK_ENV'] == 'production'
      # do the real thing in production
      @loginurl = "https://www.yammer.com/dialog/oauth?client_id=#{YAMMER_CLIENT_ID}&redirect_uri=#{YAMMER_REDIRECT_URI}"
    else
      # fake login in development
      @loginurl = "/auth/yammer/callback"
    end
    erb :login
  end

  get '/auth/yammer/callback' do
    # get oauth token from yammer
    if ENV['RACK_ENV'] == 'production'
      # do the real thing in production
      auth_code = params[:code]
      url = "https://www.yammer.com/oauth2/access_token.json?client_id=#{YAMMER_CLIENT_ID}&client_secret=#{YAMMER_CLIENT_SECRET}&code=#{auth_code}"
      token_reponse = RestClient.get(url)
      if token_reponse.code != 200
        halt 500, "Invalid response code while authenticating: #{token_reponse.code}"
      end
      oauth_token = JSON.parse(token_reponse.body)['access_token']['token']
      puts "authtoken: #{oauth_token}"
    else
      # just use hardcoded dev token for development, will expire sometime
      oauth_token = YAMMER_DEV_TOKEN
    end

    # get information about user
    Yammer.configure do |c|
      c.client_id = YAMMER_CLIENT_ID
      c.client_secret = YAMMER_CLIENT_SECRET
    end
    yc = Yammer::Client.new(:access_token => oauth_token)
    current_user = yc.current_user.body
    if mysqlcon.query("SELECT COUNT(*) AS cnt FROM users WHERE id = #{current_user[:id]}").first['cnt'] != 1
      halt 500, "Could not find user with id #{current_user[:id]}"
    end
    # save user info in session
    session[:userid] = current_user[:id]
    session[:username] = current_user[:full_name]
    redirect to('/choice')
  end

  get '/choice' do
    "You have to choose, #{session[:username]}!<br /><a href=\"/matches\">Give</a><br /><a href=\"/join\">Join</a>"
  end

  get '/matches' do
    @user = user(session[:userid])
    matchids = matches_for(session[:userid])
    @matches = []
    for matchid in matchids
      @matches << user(matchid)
    end
    erb :matches
  end

  get '/join' do
    "We will notify you, #{session[:username]}!"
  end

  get '/confirm' do
    @user = user(session[:userid])
    erb :confirmation
  end

  get '/map/:car_id' do
    @car_id = params[:car_id]
    erb :map
  end

  get '/map' do
    erb :map
  end

  get '/map_data.json/:car_id' do
    content_type :json
    
    coords = []
    mysqlcon.query("SELECT * FROM trips WHERE car_id = #{params[:car_id]}").each(:symbolize_keys => true) do |trip|
      coords << [trip[:end_lat], trip[:end_lng]]
    end
    coords.to_json
  end

  get '/map_data.json' do
    content_type :json
    
    coords = []
    mysqlcon.query("SELECT * FROM trips").each(:symbolize_keys => true) do |trip|
      coords << [trip[:end_lat], trip[:end_lng], "Election results"]
    end
    coords.to_json
  end

  get '/directionsmap' do
    erb :directionsmap
  end

  get '/directionsmap_data.json' do
    [[37.419476,-122.140335], [37.332085,-122.030278], [37.38685,-122.036222]].to_json
  end

  private
    def mysqlcon
      # open database connection
      dbconfig = YAML::load(File.open('config/database.yml'))
      client = Mysql2::Client.new(dbconfig)
    end

    def user(id)
      mysqlcon.query("SELECT * FROM users WHERE id = #{id}").first
    end

    def matches_for(id)
      [ 1508111935, 1489269123, 9847577, 1495442374, ].reject do |e|
        e == id
      end
    end
end
