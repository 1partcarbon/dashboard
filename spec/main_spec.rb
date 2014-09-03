# require File.dirname(__FILE__) + '../../main.rb'
require_relative '../main.rb'
require 'rack/test'
require 'spec_helper'

set :environment, :test
    
def app
  Sinatra::Application
end

describe 'routes test' do
  it 'should load test page' do
    get '/tests'
    expect(last_response).to be_ok
  end

  it 'reverse post' do
    post '/tests', params = { :str => 'teng'}
    expect(last_response.body).to eq('gnet')
  end
end


describe 'when navigate to dashboard' do
  let(:data) { 
    File.read("spec/fixtures/get_data.json")
  }

  before do
    users = ConnectionHandler.new.fetch_data

    @expected = JSON.parse(users)["Users"]
  end


  it 'should fetch json data from rul' do
    get '/dashboard'
    expect(@expected).to eq(JSON.parse(data))
  end

  it 'should have four objects' do
    get '/dashboard'
    expect(@expected.count).to eq(4)
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











