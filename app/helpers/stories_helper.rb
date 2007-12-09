module StoriesHelper
  def Wordcount(story_id)
    if @authinfo[:username] and ( StoryPermission.has_permission(User.find(@authinfo[:user_id]), { 'id' => story_id, 'permission' => 'author'}) or StoryPermission.has_permission(User.find(@authinfo[:user_id]), { 'id' => story_id, 'permission' => 'beta-reader'}) )
      Story.count_by_sql ["select sum(words) from chapters where story_id = ?", story_id]
    else
      Story.count_by_sql ["select sum(words) from chapters where story_id = ? AND status = 'released'", story_id]
    end
  end

  def nav_links(story)
    nav_buffer = ""
    if @authinfo[:user] and (story and @authinfo[:user].has_universe_permission(@universe.id,'owner') or @authinfo[:user].has_story_permission(story.id,'author') )
      nav_buffer += link_to 'Edit Story Permissions', :controller => 'stories', :action => 'permissions', :id => story.id
      nav_buffer +=  " | "
      nav_buffer += link_to 'Edit Story', :action => 'edit', :id => story
      nav_buffer += link_to 'Delete Story', :action => 'delete_story', :id => story
      nav_buffer +=  " | "
      link_to 'Add Chapter', :controller => 'chapters', :action => 'new', :story_id => story.id
    end
    return nav_buffer
  end

  def can_delete?(story)
    if @authinfo[:user] and (story and @authinfo[:user].has_universe_permission(@universe.id,'owner') or @authinfo[:user].has_story_permission(story.id,'author') )
      return true
    else
      return false
    end
  end

  def can_comment(chapter)
    if is_author(chapter) or is_beta_reader(chapter)
      return true
    end
    return false
  end

  def is_author(chapter)
    logger.error "User is #{@authinfo[:user].username}; chapter is #{chapter}"
    if @authinfo[:user] and @authinfo[:user].has_story_permission(chapter.story.id,'author')
      return true
    end
    return false
  end

  def is_beta_reader(chapter)
    if @authinfo[:user] and @authinfo[:user].has_story_permission(chapter.story.id,'beta-reader')
      return true
    end
    return false
  end

end
