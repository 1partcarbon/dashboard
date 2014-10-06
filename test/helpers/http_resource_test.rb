require_relative './../../helpers/http_resource'
require_relative '../mocks/fake_response'

require "minitest/autorun"
require 'minitest'
require "minitest/spec"


describe HttpResource do

  let(:url)             { 'http://example.com' }

  describe '#get' do
    it 'returns the response of the given url' do
      response = FakeResponse.new(nil, 200)
      http = Net::HTTP.new(url)
      http.define_singleton_method(:request) do |*args|
        response
      end
      Net::HTTP.stub :new, http do
        result = HttpResource.new(url).get
        assert_equal http.request, result
      end
    end

    it 'returns false when there is no internet connection' do
      response = FakeResponse.new(nil, 404)
      http = Net::HTTP.new(url)
      http.define_singleton_method(:request) do |*args|
        response
      end
      Net::HTTP.stub :new, http do
        refute HttpResource.new(url).get
      end
    end

    it 'raises an invalid enpoint error when an invalid url is passed' do
      assert_raises(Dashboard::InvalidEndpointError) { HttpResource.new('wibble').get }
    end
  end

end
