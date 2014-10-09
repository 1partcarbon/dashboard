require "minitest/spec"
require "minitest/autorun"

require_relative '../../tiles/vimeo'



describe Vimeo do

  let(:params) {{:video_id => 12345}}
  let(:edit_params) {{:video_id => 456}}
  describe 'intiailize' do
    it 'should be initialised with a url to the video' do
      vimeo = Vimeo.new(params)
      assert_equal '//player.vimeo.com/video/12345', vimeo.url
    end
  end

  describe 'display' do
    it 'should render the vimeo erb' do
      vimeo = Vimeo.new(params)
      assert_includes  vimeo.display(0), '<iframe src="//player.vimeo.com/video/12345"'
    end
  end

  describe 'edit' do
    it 'should change the value of vimeo tile' do
      vimeo = Vimeo.new(params)
      vimeo.edit(edit_params)
      assert_equal '//player.vimeo.com/video/456', vimeo.url
    end
  end
end
