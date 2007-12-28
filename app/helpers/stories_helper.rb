module StoriesHelper
  def Wordcount(story_id)
    if @authinfo[:user] and ( StoryPermission.has_permission(@authinfo[:user], { 'id' => story_id, 'permission' => 'author'}) or StoryPermission.has_permission(@authinfo[:user], { 'id' => story_id, 'permission' => 'beta-reader'}) )
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
      nav_buffer +=  " | "
      nav_buffer += link_to 'Delete Story', :action => 'delete_story', :id => story
      nav_buffer +=  " | "
      nav_buffer += link_to 'Add Chapter', :controller => 'stories', :action => 'new_chapter', :id => story.id
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

    link_buffer += link_to "(Edit)", :controller => 'chapters', :action => 'edit', :id => chapter.id if is_author(chapter)
    link_buffer += " "
    
    if chapter.status == 'released' or can_comment(chapter)
      link_buffer += "<em><strong>" if chapter.status == 'draft'
      link_buffer += link_to "Part #{chapter.number}", chapter_url(:chapter => chapter)
      link_buffer += " "
      link_buffer += "DRAFT</em></strong> " if chapter.status == 'draft'
      link_buffer += "<em>NEW!</em> " if (Date.today - chapter.date < 7)
    end

    link_buffer += link_to("Comment ", :controller => 'chapters', :action => 'show_draft', :id => chapter.id) if can_comment(chapter)

    link_buffer += "(#{chapter.date}, #{chapter.words} words" if chapter.status == 'released' or can_comment(chapter)

    comment_count = Paragraph.count_by_sql(["select count(*) from paragraphs p, pcomments c where p.chapter_id=? and c.paragraph_id = p.id and c.flag != 2",chapter.id])
    link_buffer += ", #{comment_count} comments" if can_comment(chapter)

    link_buffer += ", <strong>#{chapter.get_num_comments_unread_by(@authinfo[:username])} unread</strong>" if chapter.get_num_comments_unread_by(@authinfo[:username]) > 0 and can_comment(chapter)

    link_buffer += ", <span class=\"unacknowledged_count\">#{chapter.get_num_unacknowledged_comments} unacknowledged</span>" if is_author(chapter) and chapter.get_num_unacknowledged_comments > 0

    link_buffer += ") <br/>\n" if chapter.status == "released" or can_comment(chapter)

    return link_buffer
  end

  def breadcrumbs
    home_link = link_to 'Home', index_url(:host => StoryHost('playground')) 

    unless params[:action] == 'new' or params[:action] == 'create' or params[:action] == 'list' or params[:action] == 'index' 
      universe_link = link_to @story.universe.name, "#{index_url(:host => StoryHost('playground'))}/universes/show#{@story.universe.id}" 
      if params[:action] == 'show' 
        title_link = "#{@story.title}"
      else 
        title_link = link_to @story.title, "#{StoryHost('playground')}/stories/show/#{@story.id}" 
        action_link = " &gt; #{@description[params[:action]]}" if @description[params[:action]] 
      end 
      return "#{home_link} &gt; #{universe_link} &gt; #{title_link}#{action_link}"
    else 
      if params[:action] == 'list' or params[:action] == 'index' 
        return "#{home_link} &gt; Story List"
      else 
        universe_link = link_to @universe.name, "#{index_url(:host => StoryHost('playground'))}/universes/show/#{@universe.id}"
        return "#{home_link} &gt; #{universe_link}"
      end 

    end
  end
  
end
