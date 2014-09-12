require 'minitest'
require "minitest/spec"
require "minitest/autorun"

require_relative '../../tiles/json_tile'
require_relative '../mocks/fake_response'


describe JSONTile do

  let(:json_data) { File.read(File.expand_path("test/fixtures/get_data.json"))} 
  let(:updated_data) { File.read(File.expand_path("test/fixtures/updated_data.json"))} 
  let(:params) {{:json_url => 'example.com'}}
  let(:edit_params) {{:json_url => 'www.updatedurl.com'}}

  describe 'intiailize' do 
    it 'assigns the tile a url' do
      tile = generate_json_tile
      assert_equal "example.com", tile.url
    end

    it 'generates a map with the json data' do
      json_tile = generate_json_tile
      assert_equal 1, json_tile.objects.count
    end
  end

  describe 'update' do
    it 'updates the map with the new data' do
      json_tile = generate_json_tile
      response = FakeResponse.new(updated_data, 200) 
      Net::HTTP.stub :get_response, response do       
        json_tile.update
        assert_equal 2, json_tile.objects.count
      end
    end
  end

  describe 'display' do
    it 'should render the json erb' do
      json_tile = generate_json_tile
      assert_includes json_tile.display, '<li>Test: Test string</li>'
    end
  end

  describe 'edit' do
    it 'should update the value of the url' do
      json_tile = generate_json_tile
      response = FakeResponse.new(updated_data, 200) 
      Net::HTTP.stub :get_response, response do       
        json_tile.edit(edit_params)
        assert_equal 'www.updatedurl.com', json_tile.url
      end
    end
  end

end

def generate_json_tile
  response = FakeResponse.new(json_data, 200) 
  Net::HTTP.stub :get_response, response do
    json_tile = JSONTile.new(params)
    return json_tile
  end
end
