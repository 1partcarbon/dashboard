require_relative 'tile.rb'
require_relative '../tasks/http_resource.rb'

class JSONTile < Tile

  attr_accessor :url
  attr_accessor :objects

  def initialize(url)
    @url = url
    update
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
    erb = ERB.new(File.read(File.expand_path("views/tiles/json.erb")))
    context = {:objects => @objects}
    erb_context = ERBContext.new(context)
    erb_binding = erb_context.get_binding
    erb.result(erb_binding)
  end
end