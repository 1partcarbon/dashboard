Dir["../tiles/*"].each {|file| require_relative file }

class TileFactory
  def self.create_tile(params, type)
    tile = nil
    case type
    when 'vimeo'
      video_id = params[:video_id]
      tile = Vimeo.new(video_id)
    when 'iframe'
      url = params[:embed_url]
      height = params[:embed_height]
      width = params[:embed_width]
      tile = IFrame.new(url, width, height)
    when 'jsontile'
      begin 
        url = params[:json_url]
        tile = JSONTile.new(url)
      rescue Exception => e  
        raise e
      end
    end
    return tile
  end
end