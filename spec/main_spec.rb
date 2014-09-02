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
    @expected = ConnectionHandler.new.fetch_data
  end

  it 'should fetch json data from rul' do
    get '/dashboard'
    expect(@expected).to eq(data)
  end
end