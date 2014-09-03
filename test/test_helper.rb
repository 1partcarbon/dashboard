require "minitest/autorun"
require 'rack/test'

ENV["RACK_ENV"] = "test"

include Rack::Test::Methods

def app
  Sinatra::Application
end