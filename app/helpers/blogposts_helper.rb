module Merb
module BlogpostsHelper

#  def blogpost_markdown(text)
#    text.gsub(/\s*--\s*/,"&mdash; ")
##    logger.info("Marking down! #{text}\n")
#    markdown(text)
#  end

  def breadcrumbs
    home_link = link_to 'Home', "http://#{StoryHost('playground')}/"
    home_link = "#{home_link} &gt; #{@description[action_name]}" if @description[action_name]
  end

end
end
