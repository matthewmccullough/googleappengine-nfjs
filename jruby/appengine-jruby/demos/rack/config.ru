require 'appengine-rack'

AppEngine::Rack.configure_app(
    :application => "ambientideas",
    :version => 6 )

run lambda { Rack::Response.new("Hello World!") }
