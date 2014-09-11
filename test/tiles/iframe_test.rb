require "minitest/spec"
require "minitest/autorun"

require_relative '../../tiles/iframe'

describe IFrame do
  describe 'intiailize' do  
    it 'should be initialised with a url whatever is being embedded' do
      iframe = IFrame.new('www.embedurl.com', 500, 300)
      assert_equal 'www.embedurl.com', iframe.url 
      assert_equal 500, iframe.width
      assert_equal 300, iframe.height
    end
  end

  describe 'display' do
    it 'should render the iframe erb' do 
      iframe = IFrame.new('www.embedurl.com', 500, 300)
      assert_includes  iframe.display, '<iframe src="www.embedurl.com" width="500" height="300"'
    end
  end
end