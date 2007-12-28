module BlogpostsHelper

#  def blogpost_markdown(text)
#    text.gsub(/\s*--\s*/,"&mdash; ")
##    logger.info("Marking down! #{text}\n")
#    markdown(text)
#  end

  def breadcrumbs
    return "#{link_to 'Home', index_url(:host => StoryHost('playground'))}\n&gt; #{@description[params[:action]] if @description[params[:action]]}"
  end
  
end
