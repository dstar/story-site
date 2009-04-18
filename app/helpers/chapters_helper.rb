module Merb
  module ChaptersHelper
    def nextChapter(chapter)
      Chapter.find(:first, :conditions => ["story_id = ? and number > ?",chapter.story_id, chapter.number], :order => "number")
    end
    def prevChapter(chapter)
      Chapter.find(:first, :conditions => ["story_id = ? and number < ?",chapter.story_id, chapter.number],:order => "number DESC")
    end

    def chapter_navigation(chapter)

      nav_buffer = '<p class="navigation">'
      if prevChapter(chapter) and can_see_chapter(prevChapter(chapter))
        if action_name == 'show_draft'
          nav_buffer += link_to "Prev", index_url(StoryHost(chapter.story)) + "chapters/show_draft/" + prevChapter(chapter).id.to_s
        else
          nav_buffer += link_to 'Prev', url(:chapter,:chapter => prevChapter(chapter).file.gsub(/.html/,''))
        end
      else
        nav_buffer += "Prev"
      end
      nav_buffer += " | " + link_to('Index', index_url(StoryHost(chapter.story))) + " | "
      if nextChapter(chapter) and can_see_chapter(nextChapter(chapter))
        if action_name == 'show_draft'
          nav_buffer += link_to "Next", index_url(StoryHost(chapter.story)) + "chapters/show_draft/" + nextChapter(chapter).id.to_s
        else
          nav_buffer += link_to 'Next', url(:chapter, :chapter => nextChapter(chapter).file.gsub(/.html/,''))
        end
      else
        nav_buffer += "Next"
      end
      nav_buffer += "</p>"

      return nav_buffer
    end

    def breadcrumbs
      base_url = "http://#{StoryHost('playground')}"
      chapno = " &gt; Chapter #{ @chapter.number }" unless action_name =~ /list/
        home_link = link_to 'Home', "#{base_url}/"
      author_link =  link_to @chapter.story.authors.first.username, "#{base_url}/users/show/#{@chapter.story.authors.first.id}"
      story_link = link_to @chapter.story.title, "http://#{StoryHost(@chapter.story)}/"
      return "#{home_link} &gt; #{author_link} &gt; #{story_link}#{chapno}"
    end

  end
end
