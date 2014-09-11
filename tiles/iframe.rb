require_relative 'tile.rb'

class IFrame < Tile

  attr_accessor :url, :height, :width

  def initialize(url, width, height)
    @url = url
    @width = width
    @height = height
  end

  def update
    
  end

  def display
    erb = ERB.new(File.read(File.expand_path("views/tiles/iframe.erb")))
    context = {:url => @url, :height => @height, :width => @width}
    erb_context = ERBContext.new(context)
    erb_binding = erb_context.get_binding
    erb.result(erb_binding)
  end

end

