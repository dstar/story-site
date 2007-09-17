class ParagraphSweeper < ActionController::Caching::Sweeper
  observe Paragraph # This sweeper is going to keep an eye on the Post model

  # If our sweeper detects that a Paragraph was saved
  def after_save(para)
          expire_cache_for(para)
  end
    
  # If our sweeper detects that a Paragraph was deleted call this
  def after_destroy(para)
          expire_cache_for(para)
  end
          
  private
  def expire_cache_for(record)
    expire_fragment("show#paragraph_#{self.id}") #expire the fragment
    self.chapter.contents_changed if self.chapter.respond_to? "contents_changed"
  end
end
