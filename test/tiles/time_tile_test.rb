require "minitest/spec"
require "minitest/autorun"

require_relative '../../tiles/time_tile'

describe TimeTile do
  describe 'display' do
    it 'should render the time tile erb' do
      time_tile = TimeTile.new
      assert_includes time_tile.display, 'UTC</p>'
    end
  end

end