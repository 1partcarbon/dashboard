require_relative '../helpers/pivotal'
require 'date'

class PivotalTile < Tile
  attr_accessor :objects
  attr_accessor :type
  attr_accessor :stories
  attr_accessor :time_before
  attr_accessor :time_after
  attr_accessor :project_id
  attr_accessor :action_after
  attr_accessor :action_before
  attr_accessor :counter
  attr_accessor :story_state
  attr_reader :url
  attr_reader :story_states

  STORY_STATES = ["accepted", "delivered", "finished", "started", "rejected", "planned", "unstarted", "unscheduled"]
  STORY_ACTIONS = ["created", "updated", "accepted", "deadline"]

  def story_states
    STORY_STATES
  end

  def story_actions
    STORY_ACTIONS
  end

  def initialize(params)
    edit(params)
    @counter = 0
  end

  def update
    unsorted_stories = Pivotal.pivotal_update( @url)
    objects = unsorted_stories.sort_by { |k| k["updated_at"] }
    case @type
    when "members_stories"
      @stories = Pivotal.calculate_stories_for_owners(objects)
    when "stories_by_state"
      @stories =  Pivotal.classify_stories_by_state(objects)
    else
      @stories = Pivotal.insert_into_array(objects)
    end
  end

  def display(index)
    update
    case @type
    when 'tick_stories'
      story = @stories[@counter]

      context = {:type => @type, :story => story, :index => index}
      @counter =  (@counter + 1) % @stories.size
      ERBParser.parse(context, "views/tiles/pivotal.erb")
    else
      context = {:type => @type, :stories => @stories, :index => index, :story_state => @story_state}
      ERBParser.parse(context, "views/tiles/pivotal.erb")
    end

  end

  def edit(params)
    setup_variables(params)
    time_after_param  = "#{@time_after}T00:00:00Z" unless @time_after.empty? || @time_after == nil
    time_before_param  = "#{@time_before}T00:00:00Z" unless @time_before.empty? || @time_before == nil
    params = { @action_after.to_sym => time_after_param, @action_before.to_sym => time_before_param, :with_state => @story_state }
    params.delete_if {|key, value| value == nil || value.empty? }
    query = params.to_a.map { |x| "#{x[0]}=#{x[1]}" }.join("&")
    @url = "https://www.pivotaltracker.com/services/v5/projects/#{@project_id}/stories?#{query}"
    update
  end

  def self.time_now
    Time.now.strftime('%Y-%m-%d')
  end

  private
    def setup_variables(params)
      @project_id = params[:pivotal_project_id].to_s
      @time_after = params[:pivotal_time_after].to_s
      @time_before = params[:pivotal_time_before].to_s
      @story_state = params[:pivotal_story_state]
      @type = params[:pivotal_type].to_s
      @action_after = params[:pivotal_action_after].to_s
      @action_before = params[:pivotal_action_before].to_s
    end
end
