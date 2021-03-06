require 'appengine-rack'
AppEngine::Rack.configure_app(
  :application => 'ambientideas',
  :version => 6)

%w{R db/ doc/ log/ script/ test/ tmp/}.each do |x|
  AppEngine::Rack.app.resource_files.exclude "/#{x}**"
end

ENV['RAILS_ENV'] = AppEngine::Rack.environment
require 'config/environment'
run ActionController::Dispatcher.new
