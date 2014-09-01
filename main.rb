require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'sinatra/reloader' if development?

require 'json'
require_relative('tasks/runner.rb')

get '/dashboard' do
  @name = "dash"

  data = Runner.new.fetch_data
  @object = JSON.parse(data)


  @number = 0
  erb :dashboard, :layout => :layout
end

get '/projects' do
  erb :projects, :layout => :layout
end

not_found do
  erb :not_found
end


class Stream
  def each
    100.times { |i| yield "#{i}\n" }
  end
end

get('/') { Stream.new }

# get '/hello/:name' do
#   # matches "GET /hello/foo" and "GET /hello/bar"
#   # params[:name] is 'foo' or 'bar'
#   "Hello #{params[:name]}!"
# end

get '/param/:pa' do
  para = params[:pa]
  "#{para} works"
end

get '/hello/:name' do |n|
  # matches "GET /hello/foo" and "GET /hello/bar"
  # params[:name] is 'foo' or 'bar'
  # n stores params[:name]
  "Hello #{n}!"
end

get '/say/*/to/*' do
  # matches /say/hello/to/world
  params[:splat] # => ["hello", "world"]
end


get '/posts' do
  title = params[:title]
  author = params[:author]
end


set(:probability) {|value| condition {rand <= value}}

get '/win_a_car', :probability => 0.5 do
  "You won"
end

get '/win_a_car' do
  "Not won"
end