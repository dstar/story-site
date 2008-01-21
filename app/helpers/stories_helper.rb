module StoriesHelper
  def Wordcount(story_id)
    story = Story.find(story_id)
    if is_author(story) || is_beta_reader(story)
      Story.count_by_sql ["select sum(words) from chapters where story_id = ?", story_id]
    else
      Story.count_by_sql ["select sum(words) from chapters where story_id = ? AND status = 'released'", story_id]
    end
  end

  def nav_links(story)
    nav_buffer = ""
    if  is_universe_owner(@story) || is_author(@story)

      if is_author(@story)
        nav_buffer += link_to 'Edit Story Permissions', :controller => 'stories', :action => 'permissions', :id => story.id
      elsif is_universe_owner(@story)
        nav_buffer += link_to 'Add Author', :controller => 'universes', :action => 'story_add_owner', :story_id => story.id
      end

      nav_buffer +=  " | "
      nav_buffer += link_to 'Edit Story', :action => 'edit', :id => story
      nav_buffer +=  " | "
      nav_buffer += link_to 'Delete Story', :action => 'delete_story', :id => story
      nav_buffer +=  " | "
      nav_buffer += link_to 'Add Chapter', :controller => 'stories', :action => 'new_chapter', :id => story.id
    end
    return nav_buffer
  end

  def is_universe_owner(story)
    if @authinfo[:user] && @authinfo[:user].has_universe_permission(story.universe.id,'owner')
      return true
    else
      return false
    end
  end

  def can_delete?(story)
    if @authinfo[:user] && (story && @authinfo[:user].has_universe_permission(@universe.id,'owner') || @authinfo[:user].has_story_permission(story.id,'author') )
      return true
    else
      return false
    end
  end

  def can_comment(chapter)
    if is_author(chapter.story) || is_beta_reader(chapter.story)
      return true
    end
    return false
  end

  def is_author(story)
    if @authinfo[:user] && @authinfo[:user].has_story_permission(story.id,'author')
      return true
    end
    return false
  end

  def is_beta_reader(story)
    if @authinfo[:user] && @authinfo[:user].has_story_permission(story.id,'beta-reader')
      return true
    end
    return false
  end

  def build_chapter_links(chapter)
    link_buffer = ""

    link_buffer += link_to "(Edit)", :controller => 'chapters', :action => 'edit', :id => chapter.id if is_author(chapter.story)
    link_buffer += " "

    if chapter.status == 'released' || can_comment(chapter)
      link_buffer += "<em><strong>" if chapter.status == 'draft'
      link_buffer += link_to "Part #{chapter.number}", chapter_url(:chapter => chapter.file.gsub(/.html/,''))
      link_buffer += " "
      link_buffer += "DRAFT</em></strong> " if chapter.status == 'draft'
      link_buffer += "<em>NEW!</em> " if (Date.today - chapter.date < 7)
    end

    link_buffer += link_to("Comment ", :controller => 'chapters', :action => 'show_draft', :id => chapter.id) if can_comment(chapter)

    link_buffer += "(#{chapter.date}, #{chapter.words} words" if chapter.status == 'released' || can_comment(chapter)

    comment_count = chapter.num_comments

    link_buffer += ", #{comment_count} comments" if can_comment(chapter)

    link_buffer += ", <strong>#{chapter.num_unread_comments(@authinfo[:user])} unread</strong>" if  can_comment(chapter) && chapter.num_unread_comments(@authinfo[:user]) > 0

    link_buffer += ", <span class=\"unacknowledged_count\">#{chapter.num_unacknowledged_comments} unacknowledged</span>" if is_author(chapter) && chapter.num_unacknowledged_comments > 0

    link_buffer += ") <br/>\n" if chapter.status == "released" || can_comment(chapter)

    return link_buffer
  end

  def breadcrumbs
    home_link = link_to 'Home', index_url(:host => StoryHost('playground'))

    unless params[:action] == 'new' || params[:action] == 'create' || params[:action] == 'list' || params[:action] == 'index'
      universe_link = link_to @story.universe.name, "#{index_url(:host => StoryHost('playground'))}universes/show/#{@story.universe.id}"
      if params[:action] == 'show'
        title_link = "#{@story.title}"
      else
        title_link = link_to @story.title, "#{index_url(:host => StoryHost('playground'))}stories/show/#{@story.id}"
        action_link = " &gt; #{@description}" if @description
      end
      return "#{home_link} &gt; #{universe_link} &gt; #{title_link}#{action_link}"
    else
      if params[:action] == 'list' || params[:action] == 'index'
        return "#{home_link} &gt; Story List"
      else
        universe_link = link_to @universe.name, "#{index_url(:host => StoryHost('playground'))}universes/show/#{@universe.id}"
        return "#{home_link} &gt; #{universe_link}"
      end

    end
  end

end
