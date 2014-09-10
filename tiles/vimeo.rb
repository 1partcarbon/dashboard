require_relative 'tile.rb'

class Vimeo < Tile

  attr_accessor :url
  attr_accessor :template

  def initialize(video_id)
    @url = "//player.vimeo.com/video/" + video_id
  end

  def update
    
  end

  def display
    erb = ERB.new(File.read(File.expand_path("views/tiles/vimeo.erb")))
    context = {:url => @url}
    erb_context = ERBContext.new(context)
    erb_binding = erb_context.get_binding
    erb.result(erb_binding)
  end

end