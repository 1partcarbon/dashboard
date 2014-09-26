require_relative 'json_tile'
require_relative '../helpers/http_resource'
require 'date'

class PivotalTile < JSONTile
  attr_accessor :token
  attr_accessor :objects
  attr_accessor :type
  attr_accessor :stories_for_owners
  attr_accessor :grouped_stories

  def update
    headers = {"X-TrackerToken" => @token.to_s}
    data = HttpResource.new.fetch_with_token(@url, headers)
    if !data
      @objects = {}
    else
      @objects = JSON.parse(data.body)
    end
  end

  def display
    update

    case @type
    when "members_stories"
      calculate_stories_for_owners  
      context = {:type => @type, :stories_for_owners => @stories_for_owners}
    when "stories_by_state"
      @grouped_stories = []
      classify_stories_by_state
      context = {:objects => @objects, :type => @type, :grouped_stories => @grouped_stories}
    when "json_format"
      context = {:objects => @objects, :type => @type}
    end
    
    ERBParser.parse(context, "views/tiles/pivotal.erb")
  end

  def edit(params)
    project_id = params[:pivotal_project_id].to_s
    action_after = params[:pivotal_action_after].to_s
    time_after = params[:pivotal_time_after].to_s
    action_before = params[:pivotal_action_before].to_s
    time_before = params[:pivotal_time_before].to_s

    @url = "https://www.pivotaltracker.com/services/v5/projects/#{project_id}/stories?#{action_after}=#{time_after}T00:00:00Z&#{action_before}=#{time_before}T00:00:00Z"
    @token = params[:pivotal_token].to_s
    @type = params[:pivotal_type].to_s
    update
  end

  def calculate_stories_for_owners
    owners_id = [] 
    @stories_for_owners = [] 

    @objects.each do |items| 
      unless owners_id.include?(items["owned_by_id"]) 
        owners_id.push(items["owned_by_id"]) 
      end
    end

    owners_id.each do |owner_id| 
      counter = @objects.select {|items| items["owned_by_id"]==owner_id}.count 
      @stories_for_owners.push({"owner_id"=> owner_id, "story_amount"=> counter}) 
    end
  end

  def classify_stories_by_state
    @objects.each do |items|
      if items.has_key?("current_state") && items.has_key?("name")
        @grouped_stories.push(item(items["current_state"], items["name"], "state"))
      end

      if items.has_key?("labels") && items.has_key?("name")
        items["labels"].each do |label|
          @grouped_stories.push(item(label["name"], items["name"], "labels"))
        end
      end
    end
  end

  def item(current_status, name, option)
    if option.eql?("state")
      { "category"=> "Grouped by state", "status"=> current_status , "name"=> name }
    elsif option.eql?("labels")
      { "category"=> "Grouped by labels", "status"=> current_status , "name"=> name }
    else
      return
    end
  end

  def self.time_now
    Time.now.strftime('%Y-%m-%d')
  end
end























