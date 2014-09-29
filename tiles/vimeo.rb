require_relative 'tile.rb'

class Vimeo < Tile

  attr_accessor :url
  attr_accessor :video_id

  def initialize(params)
    edit(params)
  end

  def update

  end

  def edit(params)
    @video_id = params[:video_id].to_s
    @url = "//player.vimeo.com/video/" + @video_id
  end

  def display(index)
    context = {:url => @url}
    ERBParser.parse(context, "views/tiles/vimeo.erb")
  end

end
