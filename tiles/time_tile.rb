require_relative 'tile.rb'

class TimeTile < Tile

  def initialize(params={})

  end

  def display(index)
    context = {:time => Time.now.getgm}
    ERBParser.parse(context, 'views/tiles/time.erb')
  end

  def editable?
    false
  end

  def update
    super
  end
end
