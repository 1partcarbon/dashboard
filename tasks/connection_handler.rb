# require 'rubygems'
# require 'active_support/all'

# require_relative('hello.rb')
# require_relative('intervention.rb')
# script = ARGV[0]

# method = script.constantize  

# case script
# when "Hello"
#  method.new.hi 
# when "Intervention"
#   method.new.every
# else
#   puts "No this task"
# end

require 'open-uri'
require 'net/http'
require 'json'

class ConnectionHandler
  

  def fetch_data
    url = "https://gist.githubusercontent.com/Tvli/402a076f026733650af1/raw/b7f2ea0c33e4d7fa8adc4916cae267c08eea37ee/respons"
    if url_validate(url) == "200"
       response = open(url)
       data = response.read
     else
      false
    end
  end

  def url_validate(url)
    uri = URI.parse(url)
    request = Net::HTTP.new(uri.host, uri.port)
    request.use_ssl = true if uri.scheme == 'https'
    res = request.request_head(uri.path).code
  end


end



