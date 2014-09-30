require_relative '../helpers/pivotal'
require 'date'

class PivotalTile < Tile
  attr_accessor :objects
  attr_accessor :type
  attr_accessor :stories
  attr_accessor :time_before
  attr_accessor :time_after
  attr_accessor :project_id
  attr_accessor :counter
  attr_accessor :story_state
  attr_reader :url
  attr_reader :story_states

  STORY_STATES = ["accepted", "delivered", "finished", "started", "rejected", "planned", "unstarted", "unscheduled"]

  def story_states
    STORY_STATES
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
      context = {:type => @type, :stories => @stories, :index => index}
      ERBParser.parse(context, "views/tiles/pivotal.erb")
    end

  end

  def edit(params)
    @project_id = params[:pivotal_project_id].to_s
    action_after = params[:pivotal_action_after].to_s
    @time_after = params[:pivotal_time_after].to_s
    action_before = params[:pivotal_action_before].to_s
    @time_before = params[:pivotal_time_before].to_s

    puts params

    @story_state = params[:pivotal_story_state]


    @type = params[:pivotal_type].to_s

    case @type
    when 'state_filtered'
      @url = "https://www.pivotaltracker.com/services/v5/projects/#{@project_id}/stories?with_state=#{@story_state}"
      if @time_after != nil && !@time_after.empty?
        @url = @url + "&#{action_after}=#{@time_after}T00:00:00Z"
      end
      if @time_before != nil && !@time_before.empty?
        @url = @url + "&#{action_before}=#{@time_before}T00:00:00Z"
      end
    else
      @url = "https://www.pivotaltracker.com/services/v5/projects/#{@project_id}/stories?#{action_after}=#{@time_after}T00:00:00Z&#{action_before}=#{@time_before}T00:00:00Z"
    end

    puts "********************************* #{@url}"
    update
  end



  def self.time_now
    Time.now.strftime('%Y-%m-%d')
  end


end
