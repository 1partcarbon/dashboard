require_relative 'json_tile'
require_relative '../helpers/http_resource'

class PivotalTile < JSONTile
  attr_accessor :token_name
  attr_accessor :token

  def update
    data = HttpResource.new.fetch_with_token(@url, @token_name, @token)
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
    @token_name = params[:pivotal_token_name].to_s
    @token = params[:pivotal_token].to_s
    update
  end
end