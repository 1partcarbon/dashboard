require_relative 'tile.rb'
require_relative '../helpers/http_resource.rb'

class JSONTile < Tile

  attr_accessor :url
  attr_accessor :objects

  def initialize(params)
    edit(params)
  end

  def update
    data = HttpResource.new.fetch(@url)
    if !data
      @objects = {}
    else
      @objects = JSON.parse(data.body)
    end
  end

  def display
    update
    context = {:objects => @objects}
    ERBParser.parse(context, "views/tiles/json.erb")
  end

  def edit(params)
    @url = params[:json_url].to_s
    update
  end
end