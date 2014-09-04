require 'net/http'
require 'json'
require_relative '../modules/dashboard.rb'

class HttpResource

  def fetch(url)
    uri = URI(url)
    begin
      response = Net::HTTP.get_response(uri)
    rescue => e
      raise Dashboard::InvalidEndpointError, e.backtrace
    end
    response.code == "200" ? response : false
  end

end




