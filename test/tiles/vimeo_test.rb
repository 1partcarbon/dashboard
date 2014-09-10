require "minitest/spec"
require "minitest/autorun"

require_relative '../../tiles/vimeo'

describe 'intiailize' do  
  it 'should be initialised with a url to the video' do
    vimeo = Vimeo.new('12345')
    assert_equal '//player.vimeo.com/video/12345', vimeo.url 
  end
end

describe 'display' do
  it 'should render the vimeo erb' do 
    vimeo = Vimeo.new('12345')
    assert_includes  vimeo.display, '<iframe src="//player.vimeo.com/video/12345"'
  end
end