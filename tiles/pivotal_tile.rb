require_relative 'json_tile'
require_relative '../helpers/http_resource'

class PivotalTile < JSONTile
  attr_accessor :token
  attr_accessor :objects
  attr_accessor :type
  attr_accessor :stories_for_owners

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
    when "stories_by_status"
      context = {:objects => @objects, :type => @type}
    when "json_format"
      context = {:objects => @objects, :type => @type}
    end
    
    ERBParser.parse(context, "views/tiles/pivotal.erb")
  end

  def edit(params)
    @url = params[:pivotal_url].to_s
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
end