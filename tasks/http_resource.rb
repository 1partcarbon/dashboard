require 'net/http'
require 'json'

class HttpResource
  def fetch(url)
    
    uri = URI(url)
    begin
      response = Net::HTTP.get_response(uri)
    rescue 
      raise Dashboard::InvalidEndpointError
    end
    response.code == "200" ? response : false
  end
end

module Dashboard
  class InvalidEndpointError < StandardError; end
end


