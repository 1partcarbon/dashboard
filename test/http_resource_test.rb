require 'minitest'
require 'minitest/spec'
require 'minitest/autorun'

require_relative './../tasks/http_resource'

class FakeResponse
  attr_reader :code

  def initialize(code)
    @code = code.to_s
  end
end


describe HttpResource do

  let(:url)             { 'http://example.com' }

  describe '#fetch' do
    it 'returns the response of the given url' do
      response = FakeResponse.new(200) 
      Net::HTTP.stub :get_response, response do
        result = HttpResource.new.fetch(url)
        assert_equal response, result
      end
    end

    it 'returns false when there is no internet connection' do
      response = FakeResponse.new(404) 
      Net::HTTP.stub :get_response, response do
        refute HttpResource.new.fetch(url)
      end
    end

    it 'raises an invalid enpoint error when an invalid url is passed' do
      assert_raises(Dashboard::InvalidEndpointError) { HttpResource.new.fetch('wibble') }
    end
  end

end