require 'sinatra'
require 'rest-client'
require 'yammer'

YAMMER_CLIENT_ID = 'wN7Tyzyeo5eXxXe7MP9U2g'
YAMMER_CLIENT_SECRET = 'Fk0njVHhYH59TdaXEVOW69yHl8NIbIdohNgTK75w'
YAMMER_REDIRECT_URI = 'http://192.241.233.188/auth/yammer/callback'

class MyApplication < Sinatra::Base

  get '/?' do
    "Hello World! <a href=\"https://www.yammer.com/dialog/oauth?client_id=#{YAMMER_CLIENT_ID}&redirect_uri=#{YAMMER_REDIRECT_URI}\">Login</a>"
  end

  get '/auth/yammer/callback' do
    auth_code = params[:code]
    url = "https://www.yammer.com/oauth2/access_token.json?client_id=#{YAMMER_CLIENT_ID}"
    token_reponse = RestClient.post(url, code: auth_code)
    if token_reponse.code != 200
      halt 500, "Invalid response code while authenticating: #{token_reponse.code}"
    end
    oauth_token = JSON.parse(token_reponse.body)['access_token']['token']
    puts "authtoken: #{oauth_token}"

    Yammer.configure do |c|
      c.client_id = YAMMER_CLIENT_ID
      c.client_secret = YAMMER_CLIENT_SECRET
    end
    yc = Yammer::Client.new(:access_token => oauth_token)


    network_users = yc.all_users.body
    puts "network_users: #{network_users}"
    rtnstr = "Your network #{network_users[0][:network_name]}:<br /><ul>"
    for user in network_users
      rtnstr += "<li>#{user[:full_name]}</li>"
    end
    rtnstr += "</ul>"
    return rtnstr
  end
end
