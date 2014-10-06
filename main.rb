require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'sinatra/reloader' if development?

Dir["tiles/*"].each {|file| require_relative file }
require_relative 'helpers/tile_manager'

class Main < Sinatra::Base

  attr_accessor :tiles

  @@env = { pivotal_token:  '911f87a7a91f7465ef00d89d9cb8edc3'}

  def self.env_params
    @@env
  end

  def self.update_env(params)
    @@env = params
  end

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
    @tile = TileManager.create_tile(t)
    display_tile_erb("new", t)
  end

  post '/new_tile/:type' do |t|
    begin
      tile = TileManager.create_tile(t, params)
      tile.update
      add_tile(tile)
      redirect to '/dashboard'
    rescue URI::InvalidURIError
      @tile = tile
      @errors.push("URL is invalid")
      display_tile_erb("new", t)
    rescue Dashboard::InvalidEndpointError
      @tile = tile
      @errors.push("JSON is invalid, try checking your url")
      display_tile_erb("new", t)
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
    display_tile_erb("edit", t)
  end

  post '/edit_tile/:type' do |t|
    begin
      index = params[:index].to_i
      old_tile = tiles[index].dup
      @tile = tiles[index]
      @tile.edit(params)
      @tile.update
      redirect to '/dashboard'
    rescue URI::InvalidURIError
      @errors.push("URL is invalid")
      tiles[index] = old_tile
      display_tile_erb("edit", t)
    rescue Dashboard::InvalidEndpointError
      @errors.push("JSON is invalid, try checking your url")
      tiles[index] = old_tile
      display_tile_erb("edit", t)
    end
  end

  after do
    @errors.clear
  end

  get '/settings' do
    @env = @@env
    erb :settings
  end

  post '/settings' do
  	@@env = params
    redirect to '/dashboard'
  end

  def add_tile(tile)
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

  def display_tile_erb(action, type)
    if type == 'PivotalTile'
      @projects = Pivotal.get_projects
    end
    erb "#{action.downcase}_tile_#{type.downcase}".to_sym
  end

end
