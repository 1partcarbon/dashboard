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
require 'json'

class ConnectionHandler
  def fetch_data
    response = open("https://gist.githubusercontent.com/Tvli/402a076f026733650af1/raw/0bcb60a2985f3c5b057b1b55fa7affe96a5b60d9/response")

    data = response.read
    
    data
    
    # @object = JSON.parse(data)
    
    # puts @object["name"]
    # puts @object["gender"]
  end
end



