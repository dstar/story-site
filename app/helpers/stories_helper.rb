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

  def build_chapter_links(chapter)
    link_buffer = ""

    link_buffer += link_to "(Edit) ", :controller => 'chapters', :action => 'edit', :id => chapter.id if is_author(chapter)

    if chapter.status == 'released'
      link_buffer += link_to "Part #{chapter.number} ", chapter_url(:chapter => chapter)
      link_buffer += "<em>NEW!</em> " if (Date.today - chapter.date < 7)
    end

    link_buffer += "<em><strong>Part #{chapter.number} DRAFT</strong></em> " + link_to("Comment ", :controller => 'chapters', :action => 'show_draft', :id => chapter.id) if can_comment(chapter)

    link_buffer += "(#{chapter.date}, #{chapter.words} words" if chapter.status == 'released' or can_comment(chapter)

    comment_count = Paragraph.count_by_sql(["select count(*) from paragraphs p, pcomments c where p.chapter_id=? and c.paragraph_id = p.id and c.flag != 2",chapter.id])
    link_buffer += ", #{comment_count} comments" if can_comment(chapter)

    link_buffer += ", <strong>#{chapter.get_num_comments_unread_by(@authinfo[:username])} unread</strong>" if chapter.get_num_comments_unread_by(@authinfo[:username]) > 0 and can_comment(chapter)

    link_buffer += ", <span class=\"unacknowledged_count\">#{chapter.get_num_unacknowledged_comments} unacknowledged</span>" if is_author(chapter) and chapter.get_num_unacknowledged_comments > 0

    link_buffer += ") <br/>\n" if chapter.status == "released" or can_comment(chapter)

    return link_buffer
  end

end
