require_relative 'tile.rb'

class Vimeo < Tile

  attr_accessor :url

  def initialize(video_id)
    @url = "//player.vimeo.com/video/" + video_id
  end

  def update
    
  end

  def display
    context = {:url => @url}
    ERBParser.parse(context, "views/tiles/vimeo.erb")
  end

end

