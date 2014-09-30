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
  attr_reader :url


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
    when "tick_stories"
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


    @url = "https://www.pivotaltracker.com/services/v5/projects/#{@project_id}/stories?#{action_after}=#{@time_after}T00:00:00Z&#{action_before}=#{@time_before}T00:00:00Z"
    @type = params[:pivotal_type].to_s
    update
  end



  def self.time_now
    Time.now.strftime('%Y-%m-%d')
  end


end
