require 'net/http'
require 'json'

class HttpResource
  def fetch(url)
    response = Net::HTTP.get_response(url)
    response.code == "200" ? response : false
  end
end



