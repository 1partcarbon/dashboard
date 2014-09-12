require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'sinatra/reloader' if development?

Dir["tiles/*"].each {|file| require_relative file }
require_relative 'helpers/tile_factory'

class Main < Sinatra::Base

  attr_accessor :tiles

  def initialize
    @tiles = []
    @errors = []
    super
  end

  get '/' do 
    redirect to '/dashboard'
  end

  get '/dashboard' do
    @tiles_to_display = tiles
    erb :dashboard
  end

  get '/new_tile' do
    erb :new_tile
  end

  get '/new_tile/:type' do |t|
    display_new_tile_erb(t)
  end

  get '/remove_tile' do
    index = params[:index].to_i
    remove_tile(index)
    redirect to '/dashboard'
  end

  post '/new_tile/:type' do |t|
    begin 
      add_tile(params, t)
      redirect to '/dashboard'
    rescue URI::InvalidURIError
      @errors.push("URL is invalid")
      display_new_tile_erb(t)
    rescue Dashboard::InvalidEndpointError
      @errors.push("JSON is invalid, try checking your url")
      display_new_tile_erb(t)
    end
  end

  after do
    @errors.clear
  end

  def add_tile(params, type)
    tile = TileFactory.create_tile(params, type)
    if tile != nil
      tiles.push(tile)
    end
  end

  def remove_tile(index)
    tiles.delete_at(index)
  end

  def delete_all
    tiles = []
  end

  def display_new_tile_erb(type)
    case type
    when 'vimeo'
      erb :new_tile_vimeo
    when 'jsontile'
      erb :new_tile_json
    when 'iframe'
      erb :new_tile_iframe
    end
  end

end