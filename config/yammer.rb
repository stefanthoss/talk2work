# registered with tobias@bddemo.com

YAMMER_CLIENT_ID = 'zTu3YdOc8chdMwvqlk5xVA'
YAMMER_CLIENT_SECRET = 'RkXX5kbr25Fb7YhMExHkE7ASacc0BM4fkZUO5ix0'
if ENV['RACK_ENV'] == 'production'
  YAMMER_REDIRECT_URI = 'http://talk2work.com/auth/yammer/callback'
else
  YAMMER_REDIRECT_URI = 'http://localhost/auth/yammer/callback'
end
YAMMER_DEV_TOKEN = 'JyWfbxa86UDx33Pbkq8lQ'
