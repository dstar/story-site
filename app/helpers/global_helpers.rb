module Merb
  module GlobalHelpers
    # helpers defined here available to all views.

  def StoryHost(story)
    domain_length = request.subdomains.length
    unless story.is_a? String
      "#{story.short_title}.#{request.domain(domain_length)}:#{request.port}"
    else
      "#{story}.#{request.domain(domain_length)}:#{request.port}"
    end
  end

    def form_remote_tag(parameters, &block)
      buffer = %Q|<form onsubmit="new Ajax.Updater('#{parameters[:update]}', '#{parameters[:url]}', { asynchronous:true, evalScripts:true, parameters:Form.serialize(this)}); return false;" method="post" action="@parameters[:url]">|;
      buffer += yield
      buffer += "</form>"
    end

    def link_to_remote(text,options, html_opts)
      oncomplete = ""
      oncomplete = ", onComplete:function(request){#{options[:complete]}}" if options[:complete]
      %Q|<a href="#{ html_opts[:href]}" onclick="new Ajax.Updater('#{options[:update]}', '#{options[:url]}', { asynchronous:true, evalScripts:true #{oncomplete}}); return false;">#{text}</a>|;
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
      return %Q|<div class="userinfo">\nLogged in as #{@authinfo[:user].username} ; <a href="http://playground.pele.cx/forums/login.php?logout=true&amp;redirect=redirect_out.php&amp;sid=#{@sid}">Log Out</a>\n</div>\n|
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
    submit_button(text, attrs)
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

  end
end
