require 'open-uri'
require 'json'

 response = open("https://gist.githubusercontent.com/Tvli/402a076f026733650af1/raw/0bcb60a2985f3c5b057b1b55fa7affe96a5b60d9/response")
 data = response.read

 objects = JSON.parse(data)

 index = rand(4)

 puts objects[index]