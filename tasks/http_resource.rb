require 'net/http'
require 'json'

class HttpResource
  def fetch(url)
    
    uri = URI(url)
    response = Net::HTTP.get_response(uri)
    response.code == "200" ? response : false
    # raise Dashboard::InvalidEndpointError
  end
end

module Dashboard
  class InvalidEndpointError < StandardError; end
end


