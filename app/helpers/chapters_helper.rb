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

    def edit_link(chapter)
      Merb.logger.debug "QQQ14 @authinfo is #{@authinfo.inspect}"
      if @authinfo[:user] and @authinfo[:user].has_story_permission(chapter.story,'author')
        link_to 'Edit', url(:action => 'edit', :id => chapter.id)
      end
    end

    def can_see_chapter(chapter)
      return true if chapter.status == "released"
      return true if (@authinfo[:user] and (@authinfo[:user].has_story_permission(chapter.story,'author') or @authinfo[:user].has_story_permission(chapter.story,'beta-reader')))
      return false
    end

    def can_comment(chapter)
      return true if (@authinfo[:user] and (@authinfo[:user].has_story_permission(chapter.story,'author') or @authinfo[:user].has_story_permission(chapter.story,'beta-reader')))
      return false
    end

    def breadcrumbs
      base_url = "http://#{StoryHost('playground')}"
      chapno = " &gt; Chapter #{ @chapter.number }" unless action_name =~ /list/
        home_link = link_to 'Home', "#{base_url}/"
      author_link =  link_to @chapter.story.authors.first.username, "#{base_url}/users/show/#{@chapter.story.authors.first.id}"
      story_link = link_to @chapter.story.title, "http://#{StoryHost(@chapter.story)}/"
      return "#{home_link} &gt; #{author_link} &gt; #{story_link}#{chapno}"
    end

    def comment_denotation_class(paragraph)
      return 'unacknowledged_comments' if paragraph.total_comments > 0 and paragraph.unacknowledged_comments > 0 and @authinfo[:user] and @authinfo[:user].has_story_permission(paragraph.chapter.story,'author')
      return 'read_comments' if paragraph.total_comments > 0 and paragraph.unread_comments(@authinfo[:user]) < 1
      return 'unread_comments' if paragraph.unread_comments(@authinfo[:user]) > 0
    end

    def is_author?
      local_user = @authinfo[:user] if @authinfo[:user]
      local_user and local_user.has_story_permission(@chapter.story,'author')
    end

    def is_read?(comment)
      comment.readers.include?(@authinfo[:user])
    end

    def make_remote_link(text,options)
      link_to_remote text, options, {:href => options[:url]}
    end

    def destroy_link(comment, base_url, base_options)
      return unless is_author?
      destroy_url = base_url + "pcomments/destroy/#{comment.id}"
      make_remote_link '(Delete comment)', base_options.merge({ :url => destroy_url, :confirm => 'Are you sure?', })
    end

    def movement_links(comment)

      return unless is_author?

      up_anchor = "<a href='/pcomments/move_prev/#{comment.id}' class='comments_up'>&uarr;</a>"
      pre_buffer = "<span class='comments_up' title='Move comment to previous paragraph'>#{up_anchor}</span>"

      down_anchor = "<a href='/pcomments/move_next/#{comment.id}' class='comments_down'>&darr;</a>"
      pre_buffer += "<span class='comments_down' title='Move comment to next paragraph'>#{down_anchor}</span>"
    end

    def acknowledgement_links(comment, base_url, base_options)

      return unless is_author?

      acknowledgement_url = base_url + "pcomments/acknowledge/#{comment.id}"
      unacknowledgement_url = base_url + "pcomments/unacknowledge/#{comment.id}"

      if comment.acknowledged.blank?
        make_remote_link '(Acknowledge)', base_options.merge({ :url => acknowledgement_url})
      else
        make_remote_link '(Un-acknowledge)', base_options.merge({ :url => unacknowledgement_url})
      end
    end

    def read_unread_links(comment, base_url, base_options)
      markread_url = base_url + "pcomments/markread/#{comment.id}"
      markunread_url = base_url + "pcomments/markunread/#{comment.id}"

      if is_read? comment
        make_remote_link '(Mark comment as unread)', base_options.merge({ :url => markunread_url})
      else
        make_remote_link '(Mark comment as read)', base_options.merge({ :url => markread_url})
      end
    end

    def comment_actions(comment)

      base_url = "/"
      complete_function = "handle_acknowledgement('#{comment.paragraph_id}')"
      update_element = "comment_block_#{comment.paragraph_id}"
      base_options = { :update => update_element, :complete => complete_function}

      buffer = ""

      buffer += movement_links(comment)
      buffer += destroy_link(comment,base_url, base_options)
      buffer += read_unread_links(comment,base_url, base_options)
      buffer += acknowledgement_links(comment,base_url,base_options)

      return buffer
    end

    def markup_comment(comment)
      if is_read? comment
        comment_class = "comment_body_paragraph comment_read"
      else
        comment_class = "comment_body_paragraph"
      end

      comment_body = comment.body
      comment_body.gsub!(/\n+/,"</p><p class=#{comment_class}>")
      comment_body.gsub!(/^/,"<p class=#{comment_class}>")
      comment_body.gsub!(/$/,"</p>")
      comment_body.gsub!(/<p class=#{comment_class}><\/p>/, "")
      return comment_body
    end

    def add_comment_link(paragraph)
      para_id = paragraph.id
      base_url = "/pcomments/new/?paragraph_id=#{para_id}"
      options = { :url => base_url, :update => "comments_body#{para_id}"}
      link_to_remote 'Comment on this paragraph', options, {:href => base_url, :id => "comment_on_paragraph_#{para_id}"} if can_comment(paragraph.chapter)
    end

    def paragraph_edit_link(paragraph)
      url = "/paragraphs/edit/#{paragraph.id}"
      options = { :url => url, :update => "parabody#{paragraph.id}" }
      link_to_remote 'Edit this paragraph', options, {:href => url} if is_author?
    end

    def all_comment_movement_links(paragraph)
      if is_author? and paragraph.total_comments > 0
           buffer = %Q|<span class="comments_up" title="Move comments to previous paragraph"><a href="/paragraphs/move_comments_prev/#{paragraph.id}" class="comments_up">&uarr;</a></span>\n|
           buffer += %Q|<span class="comments_down" title="Move comments to next paragraph"><a href="/paragraphs/move_comments_next/#{paragraph.id}" class="comments_down">&darr;</a></span>|
      end
    end

    def comments_toggle(paragraph)
      anchor_name = ["pcomment",paragraph.id]
      tc = paragraph.total_comments
      uc = paragraph.unread_comments(@authinfo[:user])
      %Q|<a name="#{anchor_name}" onclick="Element.toggle('comments#{paragraph.id}')">&#182; (#{tc} comments, #{uc} unread)</a>|
    end

  end
end
