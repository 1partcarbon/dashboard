require 'net/http'
require 'json'
require 'uri'
require_relative '../modules/dashboard.rb'

class HttpResource

  attr_accessor :url
  attr_accessor :headers

  def initialize(url, headers={})
    @url = url
    @headers = headers
  end

  def get
    parsed_url = URI.parse(@url)
    begin
      http = Net::HTTP.new(parsed_url.host, parsed_url.port)
      http.use_ssl = (parsed_url.scheme == "https")
      request = Net::HTTP::Get.new(parsed_url.request_uri, @headers)
      response = http.request(request)
    rescue
      raise Dashboard::InvalidEndpointError
    end
    response.code == "200" ? response : false
  end

end
