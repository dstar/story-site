module BlogpostsHelper

  def blogpost_markdown(text)
    text.gsub(/\s*--\s*/,"&mdash; ")
#    logger.info("Marking down! #{text}\n")
    markdown(text)
  end

end
