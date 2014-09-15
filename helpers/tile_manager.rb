Dir["../tiles/*"].each {|file| require_relative file }

class TileManager

  def self.create_tile(params, type)
    tile = nil
    begin
      case type
      when 'vimeo'
        tile = Vimeo.new(params)
      when 'iframe'
        tile = IFrame.new(params)
      when 'jsontile'
        tile = JSONTile.new(params)
      when 'timetile'
        tile = TimeTile.new
      end
    rescue Exception => e  
        raise e
    end
    tile
  end
end