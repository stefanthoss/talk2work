require 'sinatra'
require 'omniauth'
require 'omniauth-yammer'
require 'rest-client'

YAMMER_CLIENT_ID = 'wN7Tyzyeo5eXxXe7MP9U2g'
YAMMER_CLIENT_SECRET = 'Fk0njVHhYH59TdaXEVOW69yHl8NIbIdohNgTK75w'
YAMMER_REDIRECT_URI = 'http://192.241.233.188/auth/yammer/callback'

class MyApplication < Sinatra::Base
  use Rack::Session::Cookie, :secret => 'Ea2Cie1beir2ChuwahceiPheequees5l'
  use OmniAuth::Builder do
    provider :yammer, YAMMER_CLIENT_ID, YAMMER_CLIENT_SECRET
  end

  get '/?' do
    "Hello World! <a href=\"https://www.yammer.com/dialog/oauth?client_id=#{YAMMER_CLIENT_ID}&redirect_uri=#{YAMMER_REDIRECT_URI}\">Login</a>"
  end

  get '/auth/failure' do
    halt 401, params['message']
  end

  get '/auth/yammer/callback' do
    yammer_token = request.env['omniauth.auth']
    puts "authtoken: #{yammer_token}"
    network_users = JSON.parse(RestClient.get("https://www.yammer.com/api/v1/users.json", headers: { 'Authorization' => "Bearer #{yammer_token}" }))
    puts "network_users: #{network_users}"
    rtnstr = "Your network: #{network_users[0]['network_name']}:<br /><ul>"
    for user in network_users
      rtnstr += "<li>#{user['full_name']}</li>"
    end
    rtnstr += "</ul>"
    return rtnstr
  end
end
