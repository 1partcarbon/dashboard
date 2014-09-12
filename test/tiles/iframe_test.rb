require "minitest/spec"
require "minitest/autorun"

require_relative '../../tiles/iframe'

describe IFrame do

  let (:params) {{:embed_url => 'www.embedurl.com', :embed_width => 500, :embed_height => 300}}
  let (:edit_params) {{:embed_url => 'www.newurl.com', :embed_width => 400, :embed_height => 200}}

  describe 'intiailize' do  
    it 'should be initialised with a url whatever is being embedded' do
      iframe = IFrame.new(params)
      assert_equal 'www.embedurl.com', iframe.url 
      assert_equal 500, iframe.width
      assert_equal 300, iframe.height
    end
  end

  describe 'display' do
    it 'should render the iframe erb' do 
      iframe = IFrame.new(params)
      assert_includes  iframe.display, '<iframe src="www.embedurl.com" width="500" height="300"'
    end
  end

  describe 'edit' do
    it 'should change the iframe attributes' do
      iframe = IFrame.new(params)
      iframe.edit(edit_params)
      assert_equal 'www.newurl.com', iframe.url 
      assert_equal 400, iframe.width
      assert_equal 200, iframe.height
    end
  end
end