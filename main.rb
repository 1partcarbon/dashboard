require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'sinatra/reloader' if development?

require 'json'
require_relative 'tasks/http_resource.rb'


get '/dashboard' do
  url = "https://gist.githubusercontent.com/Tvli/402a076f026733650af1/raw/b7f2ea0c33e4d7fa8adc4916cae267c08eea37ee/respons"

  data = HttpResource.new.fetch(url)
  if !data
    erb :not_found
  else

    users = JSON.parse(data.body)
    @objects = users["Users"]
  
    @number = 0
    erb :dashboard, :layout => :layout
  end
end



get '/index' do
  erb :index
end


get '/tests' do
  'Hey'
end

post '/tests' do
  reverse params[:str]
end

def reverse string
  string.each_char.to_a.reverse.join
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