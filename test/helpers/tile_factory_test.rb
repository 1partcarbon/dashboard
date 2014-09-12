require 'minitest'
require 'minitest/spec'
require 'minitest/autorun'

require_relative './../../helpers/tile_factory'
require_relative '../mocks/fake_response'

describe TileFactory do

  let(:json_data) { File.read(File.expand_path("test/fixtures/get_data.json"))} 

  describe 'create a tile' do
    it 'should create vimeo tile' do
      params = {:video_id => '12345'}
      vimeo = TileFactory.create_tile(params, 'vimeo')
      assert_equal 'Vimeo', vimeo.class.to_s
      assert_equal '//player.vimeo.com/video/12345', vimeo.url
    end
  
    it 'should create iframe tile' do
      params = {:embed_url => 'www.iframe.com', :embed_width => 300, :embed_height => 200}
      iframe = TileFactory.create_tile(params, 'iframe')
      assert_equal 'IFrame', iframe.class.to_s
      assert_equal 'www.iframe.com', iframe.url
      assert_equal 300, iframe.width
      assert_equal 200, iframe.height
    end

    it 'should create json tile' do
      params = {:json_url => 'example.com'}
      response = FakeResponse.new(json_data, 200) 
      Net::HTTP.stub :get_response, response do
        json = TileFactory.create_tile(params, 'jsontile')
        assert_equal 'JSONTile', json.class.to_s
        assert_equal 'example.com', json.url
      end
    end
  end
end