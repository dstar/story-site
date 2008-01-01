# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def StoryHost(story)
    domain_length = request.subdomains.length
    unless story.is_a? String
      logger.error "Story #{story.id} doesn't have a short_title!\n Attributes are:\n" unless story.attributes['short_title']
      story.attributes.each do |att|
          puts "#{att} : #{attributes[att]}" unless att == 'chapters'
          puts "#{att} : <skipped>" if att == 'chapters'
      end
      "#{story.short_title}.#{request.domain(domain_length)}#{request.port_string}"
    else
      "#{story}.#{request.domain(domain_length)}#{request.port_string}"
    end
  end

  def our_markdown(text)
    text.gsub(/\s*--\s*/,"&mdash; ")
  end

  #  def blogpost_markdown(text)
  #    text.gsub(/\s*--\s*/,"&mdash; ")
  #    markdown(text)
  #  end
  #
  #  def comment_markdown(text)
  #    text.gsub(/\s*--\s*/,"&mdash; ")
  #    text.gsub(/(.*?)(\n)+/, '<p>\1</p>\2')
  #    text.gsub(/(\n)([^\n]+)$/, '\1<p>\2</p>\1')
  #  end


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
      return %Q|<div class="userinfo">\nLogged in as #{@authinfo[:user].username} ; <a href="http://playground.pele.cx/forums/login.php?logout=true&amp;redirect=redirect_out.php&amp;sid=<%= @sid %>">Log Out</a>\n</div>\n|
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
  
end
