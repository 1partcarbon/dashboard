require "erb"

class VimeoTile 
  attr_accessor :url
  attr_accessor :template

  def initialize
    @url = "//player.vimeo.com/video/86328631"
  end

  def update
    
  end

  def display
    erb = ERB.new(File.read(File.expand_path("views/vimeo_tile.erb")))
    erb.result()
  end
end