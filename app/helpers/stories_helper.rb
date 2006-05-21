module StoriesHelper
  def Wordcount(story_id)
    Story.count_by_sql ["select sum(words) from chapters where story_id = ?", story_id]
  end
end
