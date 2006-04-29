module StoriesHelper
  def Wordcount(story_id)
    Story.count_by_sql ["select sum(words) from chapters where story_id = ?", story_id]
  end
  def StoryHost(story_id)
    Story.find(story_id).short_title.concat('.').concat(request.domain).concat(request.port_string)
  end
end
