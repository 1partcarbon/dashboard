require 'minitest'
require 'minitest/spec'
require 'minitest/autorun'

require_relative './../../helpers/tile_manager'
require_relative '../mocks/fake_response'

describe TileManager do

  let(:json_data) { File.read(File.expand_path("test/fixtures/get_data.json"))}

  describe 'create a tile' do
    it 'should create vimeo tile' do
      params = {:video_id => '12345'}
      vimeo = TileManager.create_tile('Vimeo',params)
      assert_equal 'Vimeo', vimeo.class.to_s
    end

    it 'should create iframe tile' do
      params = {:embed_url => 'www.iframe.com', :embed_width => 300, :embed_height => 200}
      iframe = TileManager.create_tile('IFrame',params)
      assert_equal 'IFrame', iframe.class.to_s
    end

    it 'should create json tile' do
      params = {:json_url => 'example.com'}
      response = FakeResponse.new(json_data, 200)
      Net::HTTP.stub :get_response, response do
        json = TileManager.create_tile('JSONTile',params)
        assert_equal 'JSONTile', json.class.to_s
      end
    end
  end
end
