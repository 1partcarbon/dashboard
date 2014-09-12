require 'minitest'
require 'minitest/spec'
require 'minitest/autorun'

require_relative './../../helpers/erb_parser'

describe ERBParser do
  describe 'parse' do
    it 'parses the erb and returns correct html' do
      context = { :name => 'test'}
      erb_path = 'test/fixtures/erb_parser_test_file.erb'
      output = ERBParser.parse(context, erb_path)
      assert_includes output, '<p>Name: test</p>'
    end
  end
end