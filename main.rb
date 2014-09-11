require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'sinatra/reloader' if development?

require_relative 'tiles/vimeo.rb'
require_relative 'tiles/json_tile.rb'
require_relative 'tiles/iframe.rb'

class Main < Sinatra::Base

 set :tiles, Array.new


  get '/dashboard' do
    @tiles_to_display = settings.tiles
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

  get '/remove_tile' do
    index = params[:index].to_i
    remove_tile(index)
    redirect to '/dashboard'
  end

  post '/new_tile/iframe' do
    url = params[:embed_url]
    height = params[:embed_height]
    width = params[:embed_width]
    iframe = IFrame.new(url, width, height)
    add_tile(iframe)
    redirect to '/dashboard'
  end

  post '/new_tile/vimeo' do
    id = params[:video_id]
    vimeo = Vimeo.new(id)
    add_tile(vimeo)
    redirect to '/dashboard'
  end

  post '/new_tile/json' do
    url = params[:json_url]
    json = JSONTile.new(url)
    add_tile(json)
    redirect to '/dashboard'
  end

  def add_tile(tile)
    settings.tiles.push(tile)
  end

  def remove_tile(index)
    settings.tiles.delete_at(index)
  end

  def delete_all
    settings.tiles = []
  def

end