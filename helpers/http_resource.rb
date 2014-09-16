require 'net/http'
require 'json'
require 'uri'
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

  def fetch_with_token(url, headers)
    uri = URI.parse(url)
    begin
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(uri.request_uri, headers)
      response = http.request(request)
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



