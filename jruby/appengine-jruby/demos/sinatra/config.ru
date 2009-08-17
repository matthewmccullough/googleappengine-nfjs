require 'appengine-rack'

AppEngine::Rack.configure_app(
    :application => 'ambientideas',
    :version => 7)

require 'guestbook'
run Sinatra::Application
