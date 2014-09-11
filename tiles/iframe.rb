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
    context = {:url => @url, :height => @height, :width => @width}
    ERBParser.parse(context, 'views/tiles/iframe.erb')
  end

end

