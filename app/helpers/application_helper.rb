# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def StoryHost(story_id)
    unless story_id == "playground"
      Story.find(story_id).short_title.concat('.').concat(request.domain).concat(request.port_string)
    else
      story_id.concat('.').concat(request.domain).concat(request.port_string)
    end
  end
end
