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
    assert_equal last_response.body, 'gnet'
  end
end


describe 'when navigate to dashboard' do
  let(:data) { File.read("#{__dir__}/fixtures/get_data.json") }

  before do
    users = ConnectionHandler.new.fetch_data

    @expected = JSON.parse(users)["Users"]
  end


  it 'should fetch json data from rul' do
    get '/dashboard'
    assert_equal @expected, JSON.parse(data)
  end

  it 'should have four objects' do
    get '/dashboard'
    assert_equal @expected.count, 4
  end


describe 'when the url is not valid' do
  it 'the not found page should be loaded' do
    
  end
end

describe 'when the url is valid' do
  it 'the dashboard page should be loaded' do
    
  end
end
 
end











