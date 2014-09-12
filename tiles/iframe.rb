require_relative 'tile.rb'

class IFrame < Tile

  attr_accessor :url, :width, :height

  def initialize(params)
    edit(params)
  end

  def update
    
  end

  def edit(params)
    @url = params[:embed_url]
    @width = params[:embed_width].to_i
    @height = params[:embed_height].to_i
  end

  def display
    context = {:url => @url, :height => @height, :width => @width}
    ERBParser.parse(context, 'views/tiles/iframe.erb')
  end

end

