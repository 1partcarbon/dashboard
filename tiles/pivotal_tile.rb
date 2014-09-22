require_relative 'json_tile'
require_relative '../helpers/http_resource'

class PivotalTile < JSONTile
  attr_accessor :token
  attr_accessor :objects

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
    context = {:objects => @objects}
    ERBParser.parse(context, "views/tiles/pivotal.erb")
  end

  def edit(params)
    @url = params[:pivotal_url].to_s
    @token = params[:pivotal_token].to_s
    update
  end
end