require_relative 'http_resource'

class Pivotal

  def self.calculate_stories_for_owners(objects)
    owners_id = []
    stories_for_owners = []

    objects.each do |items|
      unless owners_id.include?(items["owned_by_id"])
        owners_id.push(items["owned_by_id"])
      end
    end

    owners_id.each do |owner_id|
      counter = objects.select {|items| items["owned_by_id"]==owner_id}.count
      stories_for_owners.push({"owner_id"=> owner_id, "story_amount"=> counter})
    end
    stories_for_owners
  end

  def self.classify_stories_by_state(objects)
    grouped_stories = []
    objects.each do |items|
      if items.has_key?("current_state") && items.has_key?("name")
        grouped_stories.push(item(items["current_state"], items["name"], "state"))
      end

      if items.has_key?("labels") && items.has_key?("name")
        items["labels"].each do |label|
          grouped_stories.push(item(label["name"], items["name"], "labels"))
        end
      end
    end
    grouped_stories
  end

  def self.item(current_status, name, option)
    if option.eql?("state")
      { "category"=> "Grouped by state", "status"=> current_status , "name"=> name }
    elsif option.eql?("labels")
      { "category"=> "Grouped by labels", "status"=> current_status , "name"=> name }
    else
      return
    end
  end

  def self.pivotal_update(token,url)
    headers = {"X-TrackerToken" => Main.env[:pivotal_token]}
    data = HttpResource.new.fetch_with_token(url, headers)
    if !data
      objects = {}
    else
      objects = JSON.parse(data.body)
    end
  end

  def self.get_projects
    url = "https://www.pivotaltracker.com/services/v5/projects/"
    headers = {"X-TrackerToken" => Main.env[:pivotal_token]}
    data = HttpResource.new.fetch_with_token(url, headers)
    objects = nil
    if !data
      objects = {}
    else
      objects = JSON.parse(data.body)
    end
    sort_projects(objects)
  end

  def self.sort_projects(objects)
    projects = []
    objects.each do |items|
      if items.has_key?("id") && items.has_key?("name")
        projects.push({"id" => items["id"], "name" => items["name"] })
      end
    end
    projects
  end

end
