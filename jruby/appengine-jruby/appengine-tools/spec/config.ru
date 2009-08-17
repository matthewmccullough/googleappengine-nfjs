require 'appengine-rack'

AppEngine::Rack.configure_app(
  :application => 'tools-test', :version => 'foo', :ssl_enabled => true)

ruby_app = lambda {|env| [200, {}, "Hello Rack!"]}

map '/admin' do
  use JavaServletFilter, 'com.example.AdminFilter', :wildcard => true
  run JavaServlet.new('com.example.AdminServlet', :wildcard => true)
end

map '/store' do
  use JavaServletFilter, 'com.example.StoreFilter', :name => 'StoreFilter'
  run JavaServlet.new('com.example.StoreServlet', :name => 'store')
end

map '/admin2' do
  use AppEngine::Rack::AdminRequired
  run ruby_app
end

map '/private' do
  use AppEngine::Rack::LoginRequired
  run ruby_app
end

map '/secure' do
  use AppEngine::Rack::SSLRequired
  run ruby_app
end

run ruby_app