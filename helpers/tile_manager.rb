Dir["../tiles/*"].each {|file| require_relative file }

class TileManager

  def self.create_tile(type, params={})
    begin
      tile = Object.const_get(type).new(params)
    rescue Exception => e
      raise e
    end
  end
end
