require 'net/http'
require 'json'
require_relative '../modules/dashboard.rb'

class HttpResource

  def fetch(url)
    uri = uri(url)
    begin
      response = Net::HTTP.get_response(uri)
    rescue
      raise Dashboard::InvalidEndpointError
    end
    response.code == "200" ? response : false
  end

private
  def uri(url)
    uri = URI(url)
    begin
      uri.scheme ? uri : false
    rescue
      raise URI::InvalidURIError
    end
  end

end




