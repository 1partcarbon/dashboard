require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'sinatra/reloader' if development?

Dir["tiles/*"].each {|file| require_relative file }

class Main < Sinatra::Base

 #set :tiles, Array.new

  attr_accessor :tiles

  def initialize
    @tiles = []
    @errors = []
    super
  end

  after do
    @errors.clear
  end

  get '/dashboard' do
    @tiles_to_display = tiles
    erb :dashboard
  end

  get '/new_tile' do
    erb :new_tile
  end

  get '/new_tile/vimeo' do
    erb :new_tile_vimeo
  end

  get '/new_tile/json' do
    erb :new_tile_json
  end

  get '/new_tile/iframe' do
    erb :new_tile_iframe
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
    begin 
      json = JSONTile.new(url)
      add_tile(json)
      redirect to '/dashboard'
    rescue
      @errors.push("URL is invalid")
      erb :new_tile_json
    end 
  end

  def add_tile(tile)
    tiles.push(tile)
  end

  def remove_tile(index)
    tiles.delete_at(index)
  end

  def delete_all
    tiles = []
  end

end