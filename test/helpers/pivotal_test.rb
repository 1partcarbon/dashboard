require 'minitest'
require 'minitest/spec'
require 'minitest/autorun'

require_relative './../../helpers/pivotal'

describe Pivotal do

  describe 'calculate_stories_for_owners' do
    let(:objects) { [{ "owned_by_id" => 1 }, {"owned_by_id" => 2}, {"owned_by_id" => 1}] }
    let(:expected) { [{"owner_id" => 1, "story_amount" => 2}, {"owner_id" => 2, "story_amount" => 1}] }

    it 'counts the number of stories belonging to each user' do
      output = Pivotal.calculate_stories_for_owners(objects)
      assert_equal expected, output
    end
  end

  describe 'classify_stories_by_state' do
    let(:story_1) { {"current_state" => "state_1", "name" => "name_1", "labels" => [{"name" => "label_1"}]} }
    let(:objects) { [story_1] }
    let(:expected) { [{ "category"=> "Grouped by state", "status"=> "state_1" , "name"=> "name_1" }, { "category"=> "Grouped by labels", "status"=> "label_1" , "name"=> "name_1" }] }

    it 'groups the stories by state and label' do
      output = Pivotal.classify_stories_by_state(objects)
      assert_equal expected, output
    end

  end
end
