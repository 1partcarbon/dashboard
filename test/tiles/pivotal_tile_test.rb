require 'minitest'
require "minitest/spec"
require "minitest/autorun"

require_relative '../../tiles/pivotal_tile'
require_relative '../mocks/fake_response'

describe PivotalTile do

  let(:params) {{pivotal_project_id: 1, pivotal_action_after: "created_after", pivotal_time_after: "2014-09-01", pivotal_action_before: "updated_before", pivotal_time_before: "2014-09-15", pivotal_type: "members_stories" }}
  let(:edited_params) {{pivotal_project_id: 2, pivotal_action_after: "deadline_after", pivotal_time_after: "2013-09-01", pivotal_action_before: "accepted_before", pivotal_time_before: "2013-09-15", pivotal_type: "ticker_stories" }}

  describe 'intiailize' do
    it 'assigns the tile the params' do
      tile = PivotalTile.new(params)
      assert_equal "members_stories", tile.type
      assert_equal "1", tile.project_id
      assert_equal "2014-09-01", tile.time_after
      assert_equal "2014-09-15", tile.time_before
      assert_equal "https://www.pivotaltracker.com/services/v5/projects/1/stories?created_after=2014-09-01T00:00:00Z&updated_before=2014-09-15T00:00:00Z", tile.url
      assert_equal 0, tile.counter
    end
  end

  describe 'edit' do
    it 'changes tile params' do
      tile = PivotalTile.new(params)
      tile.edit(edited_params)
      assert_equal "ticker_stories", tile.type
      assert_equal "2", tile.project_id
      assert_equal "2013-09-01", tile.time_after
      assert_equal "2013-09-15", tile.time_before
      assert_equal "https://www.pivotaltracker.com/services/v5/projects/2/stories?deadline_after=2013-09-01T00:00:00Z&accepted_before=2013-09-15T00:00:00Z", tile.url
      assert_equal 0, tile.counter
    end
  end

  describe 'update' do
    it 'populates the list of stories' do
      fake_stories = [{:owned_by_id => 2, :updated_at => '2014-09-01'}]
      fake_counts = [{:owner_id => 2, :story_amount => 1}]
      Pivotal.stub :pivotal_update, fake_stories do
        Pivotal.stub :calculate_stories_for_owners, fake_counts do
          tile = PivotalTile.new(params)
          assert_equal fake_counts, tile.stories
        end
      end
    end
  end

  describe 'display' do
    it 'renders pivotal erb' do
      fake_stories = [{:owned_by_id => 2, :updated_at => '2014-09-01'}]
      fake_counts = [{:owner_id => 2, :story_amount => 1}]
      Pivotal.stub :pivotal_update, fake_stories do
        Pivotal.stub :calculate_stories_for_owners, fake_counts do
          tile = PivotalTile.new(params)
          assert_includes tile.display(0), "memberStories(#{fake_counts.to_json});"
        end
      end
    end
  end

end
