require_relative 'tile.rb'

class TimeTile < Tile

  def intialize
  end

  def display
    context = {:time => Time.now.getgm}
    ERBParser.parse(context, 'views/tiles/time.erb')
  end

  def editable?
    false
  end
end