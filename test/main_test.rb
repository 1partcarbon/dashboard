# require File.dirname(__FILE__) + '../../main.rb'
require_relative '../main.rb'
require 'rack/test'
require_relative 'test_helper'

set :environment, :test
    


describe 'routes test' do
  it 'should load test page' do
    get '/tests'
    assert last_response.ok?
  end

  it 'reverse post' do
    post '/tests', params = { :str => 'teng'}
    assert_equal 'gnet', last_response.body
  end
end


describe 'when navigate to dashboard' do
  let(:data) { File.read("#{__dir__}/fixtures/get_data.json") }
  let(:valid_url) { "https://gist.githubusercontent.com/Tvli/402a076f026733650af1/raw/b7f2ea0c33e4d7fa8adc4916cae267c08eea37ee/respons" }
  let(:invalid_url) { "https://gist.githubusercontent.com/Tvli/raw/b7f2ea0c33e4d7fa8adc4916cae267c08eea37ee/respons" }


  before do
    @false_response = ConnectionHandler.new.url_validate(invalid_url)
    @true_response = ConnectionHandler.new.url_validate(valid_url)

    users = ConnectionHandler.new.fetch_data

    @expected = JSON.parse(users)["Users"]
  end


  it 'should fetch json data from rul' do
    get '/dashboard'
    assert_equal JSON.parse(data), @expected
  end

  it 'should have four objects' do
    get '/dashboard'
    assert_equal 4, @expected.count
  end




  describe 'when the url is not valid' do
    it 'the response should be 404' do
      assert_equal "404", @false_response
    end
  end
  
  describe 'when the url is valid' do
    it 'the response should be 200' do
      assert_equal "200", @true_response
    end
  end
 
end











