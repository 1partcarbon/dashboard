require_relative '../helpers/pivotal'
require 'date'

class PivotalTile < Tile
  attr_accessor :token
  attr_accessor :objects
  attr_accessor :type
  attr_accessor :stories_for_owners
  attr_accessor :grouped_stories
  attr_accessor :time_before
  attr_accessor :time_after
  attr_accessor :project_id


  def initialize(params)
    edit(params)
  end

  def update
    @objects = Pivotal.pivotal_update(@token, @url)
    case @type
    when "members_stories"
      @stories = Pivotal.calculate_stories_for_owners(@objects)
    when "stories_by_state"
      @stories =  Pivotal.classify_stories_by_state(@objects)
    end
  end

  def display(index)
    update
    context = {:type => @type, :stories => @stories, :index => index}
    ERBParser.parse(context, "views/tiles/pivotal.erb")
  end

  def edit(params)
    @project_id = params[:pivotal_project_id].to_s
    action_after = params[:pivotal_action_after].to_s
    @time_after = params[:pivotal_time_after].to_s
    action_before = params[:pivotal_action_before].to_s
    @time_before = params[:pivotal_time_before].to_s


    @url = "https://www.pivotaltracker.com/services/v5/projects/#{@project_id}/stories?#{action_after}=#{@time_after}T00:00:00Z&#{action_before}=#{@time_before}T00:00:00Z"
    @token = params[:pivotal_token].to_s
    @type = params[:pivotal_type].to_s
    update
  end



  def self.time_now
    Time.now.strftime('%Y-%m-%d')
  end


end
