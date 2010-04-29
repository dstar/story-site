module Merb
  module GlobalHelpers
    # helpers defined here available to all views.

    def StoryHost(story)
      domain_length = request.subdomains.length
      port_string = ":#{request.port}" if request.port != 80
#      Merb.logger.debug "QQQ19: Subdomains => #{request.subdomains.inspect}, domain=> #{request.domain.inspect}"
      unless story.is_a? String
        "#{story.short_title}.#{request.domain(domain_length)}#{port_string}"
      else
        "#{story}.#{request.domain(domain_length)}#{port_string}"
      end
    end

    def remote_form_attrs(parameters)
      oncomplete = ""
      oncomplete = "onComplete:function(request){#{parameters[:complete]}}, " if parameters[:complete]

      submit_str = "new Ajax.Updater('#{parameters[:update]}', '#{parameters[:url]}', { asynchronous:true, evalScripts:true, #{oncomplete}parameters:Form.serialize(this)}); return false;"

      remote_hash = {  :onsubmit => submit_str , :action => parameters[:url] }
      remote_hash.merge parameters
    end

    def link_to_remote(text,options, html_opts)
      oncomplete = ""
      oncomplete = ", onComplete:function(request){#{options[:complete]}}" if options[:complete]
      opts = ""
      html_opts.keys.each { |k| opts += "#{k}=#{html_opts[k]} "}
      %Q|<a #{opts}onclick="new Ajax.Updater('#{options[:update]}', '#{options[:url]}', { asynchronous:true, evalScripts:true #{oncomplete}}); return false;">#{text}</a>|;
    end

    def format_time(time, format)
      if time.is_a?(String)
        Time.parse(time).strftime(format)
      elsif time.is_a?(Time) || time.is_a?(DateTime) || time.is_a?(Date)
        time.strftime(format)
      end
    end

    def style_links
      style_links_buffer = ""
      Style.find(:all, :select => 'theme', :conditions => ['user=-1'], :group => 'theme').collect { |s| [s.theme, s.theme] }.each do |theme|
        style_links_buffer += %Q|<link rel="stylesheet" type="text/css" href="http://styles.playground.pele.cx/style/show/#{theme[0]}.css" title="#{theme[0]}" />|
      end
      return style_links_buffer
    end

    def php_session_header
      if @authinfo[:user] and @authinfo[:user].user_id != -1
        return %Q|<div class="userinfo">\nLogged in as <a href="#{url(:controller => "users", :action => "show", :id => @authinfo[:user].id)}">#{@authinfo[:user].username}</a> ; <a href="http://playground.pele.cx/forums/login.php?logout=true&amp;redirect=redirect_out.php&amp;sid=#{@sid}">Log Out</a>\n</div>\n| #"
      else
        return %Q|<div class="userinfo">\n<a href="http://playground.pele.cx/forums/login.php?redirect=redirect_in.php">Log In</a>\n</div>\n|
      end
    end

    def style_dropdown
      options_string = ""
      Style.find(:all, :select => 'theme', :conditions => ['user=-1'], :group => 'theme').each {|s| options_string += "<option value='#{s.theme}'>#{s.theme}</option>\n"}
      return <<EOS
<div>
<form action="">
<select id="styleselect" onchange="setActiveStyleSheet(Form.Element.getValue('styleselect'));">
#{options_string}
</select>
</form>
</div>
EOS
    end

    def javascript_include_tag(name)
      js_include_tag(name)
    end

    def submit_tag(text, attrs ={ })
      txt = submit(text, attrs)
#      Merb.logger.debug "QQQ36: submit button code is |#{txt}"
      txt
    end

    def calendar_date_select_includes(name)
      javascript = %Q|  <script src="/javascripts/calendar_date_select/calendar_date_select.js" type="text/javascript"></script>|;
      stylesheet = %Q|<link href="/stylesheets/calendar_date_select/#{name}.css" media="screen" rel="stylesheet" type="text/css" />|;

      javascript + stylesheet

    end

    def index_url(server)
      "http://#{server}/"
    end

    def our_markdown(text)
      text.gsub(/\s*--\s*/,"&mdash; ")
    end

    def show_messages
      buffer = ""
      if message && ! message.empty?
        message.keys.each do |key|
          buffer += "<div class='#{key}'>#{h(message[key].inspect)}</div>"
        end
      end
      buffer
    end

    # Needed by both chapters and comments

    def edit_link(chapter)
#      Merb.logger.debug "QQQ14 @authinfo is #{@authinfo.inspect}"
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
