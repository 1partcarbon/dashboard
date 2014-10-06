require_relative 'tile.rb'
require_relative '../helpers/http_resource.rb'

class JSONTile < Tile

  attr_accessor :url
  attr_accessor :objects

  def initialize(params)
    set_params(params)
  end

  def update
    http = HttpResource.new(@url)
    data = http.get
    if !data
      @objects = {}
    else
      @objects = JSON.parse(data.body)
    end
  end

  def display(index)
    update
    context = {:objects => @objects}
    ERBParser.parse(context, "views/tiles/json.erb")
  end

  def edit(params)
    set_params(params)
  end

  private
  def set_params(params)
    @url = params[:json_url].to_s
  end
end
