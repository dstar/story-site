# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def StoryHost(story_id)
    domain_length = request.subdomains.length
    unless story_id == "playground"
      Story.find(story_id).short_title.concat('.').concat(request.domain(domain_length)).concat(request.port_string)
    else
      story_id.concat('.').concat(request.domain(domain_length)).concat(request.port_string)
    end
  end

  def our_markdown(text)
    text.gsub(/\s*--\s*/,"&mdash; ")
#    logger.info("Marking down! #{text}\n")
#    markdown(text)
  end

  def blogpost_markdown(text)
    text.gsub(/\s*--\s*/,"&mdash; ")
#    logger.info("Marking down! #{text}\n")
    markdown(text)
  end

  def format_time(time, format)
    if time.is_a?(String)
      Time.parse(time).strftime(format)
    elsif time.is_a?(Time) || time.is_a?(DateTime) || time.is_a?(Date)
      time.strftime(format)
    end
  end

end
