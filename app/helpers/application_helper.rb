# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def StoryHost(story)
    domain_length = request.subdomains.length
    unless story.is_a? String
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

end
