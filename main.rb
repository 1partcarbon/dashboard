require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'sinatra/reloader' if development?

require_relative 'tiles/vimeo.rb'
require_relative 'tiles/json_tile.rb'
require_relative 'tiles/iframe.rb'

tiles = []

get '/dashboard' do
  @tiles_to_display = tiles
  erb :dashboard, :layout => :simple_layout
end

get '/new_tile' do
  erb :new_tile, :layout => :simple_layout
end

get '/new_tile/vimeo' do
  erb :new_tile_vimeo, :layout => :simple_layout
end

get '/new_tile/json' do
  erb :new_tile_json, :layout => :simple_layout
end

get '/new_tile/iframe' do
  erb :new_tile_iframe, :layout => :simple_layout
end

post '/new_tile/iframe' do
  url = params[:embed_url]
  height = params[:embed_height]
  width = params[:embed_width]
  iframe = IFrame.new(url, width, height)
  tiles.push(iframe)
  redirect to '/dashboard'
end

post '/new_tile/vimeo' do
  id = params[:video_id]
  vimeo = Vimeo.new(id)
  tiles.push(vimeo)
  redirect to '/dashboard'
end

post '/new_tile/json' do
  url = params[:json_url]
  json = JSONTile.new(url)
  tiles.push(json)
  redirect to '/dashboard'
end