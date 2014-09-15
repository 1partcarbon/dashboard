require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'sinatra/reloader' if development?

Dir["tiles/*"].each {|file| require_relative file }
require_relative 'helpers/tile_manager'

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

  get '/spike' do
    erb :spike_dashboard
  end

  get '/new_tile/:type' do |t|
    display_new_tile_erb(t)
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

  get '/remove_tile' do
    index = params[:index].to_i
    remove_tile(index)
    redirect to '/dashboard'
  end

  get '/edit_tile/:type' do |t|
    index = params[:index].to_i
    @tile = tiles[index]
    display_edit_tile_erb(t)
  end

  post '/edit_tile/:type' do |t|
    begin
      index = params[:index].to_i
      old_tile = tiles[index]
      @tile = tiles[index].edit(params)
      redirect to '/dashboard'
    rescue URI::InvalidURIError
      @errors.push("URL is invalid")
      @tile = old_tile
      display_edit_tile_erb(t)
    rescue Dashboard::InvalidEndpointError
      @errors.push("JSON is invalid, try checking your url")
      @tile = old_tile
      display_edit_tile_erb(t)
    end
  end

  after do
    @errors.clear
  end

  def add_tile(params, type)
    tile = TileManager.create_tile(params, type)
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
    when 'timetile'
      erb :new_tile_time
    end
  end

  def display_edit_tile_erb(type)
    case type
    when 'vimeo'
      erb :edit_tile_vimeo
    when 'jsontile'
      erb :edit_tile_json
    when 'iframe'
      erb :edit_tile_iframe
    end 
  end

end