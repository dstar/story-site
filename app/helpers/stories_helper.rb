module StoriesHelper
  def Wordcount(story_id)
    if @authinfo[:username] and ( StoryPermission.has_permission(User.find(@authinfo[:user_id]), { 'id' => story_id, 'permission' => 'author'}) or StoryPermission.has_permission(User.find(@authinfo[:user_id]), { 'id' => story_id, 'permission' => 'beta-reader'}) )
      Story.count_by_sql ["select sum(words) from chapters where story_id = ?", story_id]
    else
      Story.count_by_sql ["select sum(words) from chapters where story_id = ? AND status = 'released'", story_id]
    end
  end
end
