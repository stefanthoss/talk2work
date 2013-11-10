YAMMER_CLIENT_ID = 'wN7Tyzyeo5eXxXe7MP9U2g'
YAMMER_CLIENT_SECRET = 'Fk0njVHhYH59TdaXEVOW69yHl8NIbIdohNgTK75w'
if ENV['RACK_ENV'] == 'production'
  YAMMER_REDIRECT_URI = 'http://talk2work.com/auth/yammer/callback'
else
  YAMMER_REDIRECT_URI = 'http://localhost/auth/yammer/callback'
end
YAMMER_DEV_TOKEN = 'JyWfbxa86UDx33Pbkq8lQ'
