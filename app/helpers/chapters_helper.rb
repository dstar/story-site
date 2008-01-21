module ChaptersHelper
  def nextChapter(chapter)
    number = Chapter.count_by_sql(["select min(number) from chapters where story_id = ? and number > ?",chapter.story_id, chapter.number])
    Chapter.find(:first, :conditions => ["story_id = ? and number = ?",chapter.story_id, number])
  end
  def prevChapter(chapter)
    number = Chapter.count_by_sql(["select max(number) from chapters where story_id = ? and number < ?",chapter.story_id, chapter.number])
    Chapter.find(:first, :conditions => ["story_id = ? and number = ?",chapter.story_id, number])
  end

  def chapter_navigation(chapter)

    nav_buffer = '<p class="navigation">'
    if prevChapter(chapter) and can_see_chapter(prevChapter(chapter))
      if params[:action] == 'show_draft'
        nav_buffer += link_to "Prev", index_url + "chapters/show_draft/" + prevChapter(chapter).id.to_s
      else
        nav_buffer += link_to 'Prev', chapter_url(:chapter => prevChapter(chapter).file.gsub(/.html/,''))
      end
    else
      nav_buffer += "Prev"
    end
    nav_buffer += " | " + link_to('Index', index_url) + " | "
    if nextChapter(chapter) and can_see_chapter(nextChapter(chapter))
      if params[:action] == 'show_draft'
        nav_buffer += link_to "Next", index_url + "chapters/show_draft/" + nextChapter(chapter).id.to_s
      else
        nav_buffer += link_to 'Next', chapter_url(:chapter => nextChapter(chapter).file.gsub(/.html/,''))
      end
    else
      nav_buffer += "Next"
    end
    nav_buffer += "</p>"

    return nav_buffer
  end

  def edit_link(chapter)
    if @authinfo[:user] and @authinfo[:user].has_story_permission(chapter.story,'author')
      link_to 'Edit', :action => 'edit', :id => chapter.id
    end
  end

  def can_see_chapter(chapter)
    return true if chapter.status == "released"
    return true if (@authinfo[:user] and (@authinfo[:user].has_story_permission(chapter.story,'author') or @authinfo[:user].has_story_permission(chapter.story,'beta-reader')))
    return false
  end

  def breadcrumbs
    chapno = " &gt; Chapter #{ @chapter.number }" unless params[:action] =~ /list/
    home_link = link_to 'Home', index_url(:host => StoryHost('playground'))
    universe_link =  link_to @chapter.story.universe.name, "#{index_url(:host => StoryHost('playground'))}universes/show/#{@chapter.story.universe.id}"
    story_link = link_to @chapter.story.title, index_url(:host => StoryHost(@chapter.story))
    return "#{home_link} &gt; #{universe_link} &gt; #{story_link}#{chapno}"
  end

  def comment_denotation_class(paragraph)
    return 'unacknowledged_comments' if paragraph.total_comments > 0 and paragraph.unacknowledged_comments > 0 and @authinfo[:user] and @authinfo[:user].has_story_permission(paragraph.chapter.story,'author')
    return 'read_comments' if paragraph.total_comments > 0 and paragraph.unread_comments(@authinfo[:user]) < 1
    return 'unread_comments' if paragraph.unread_comments(@authinfo[:user]) > 0
  end

end
