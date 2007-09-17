class ParagraphSweeper < ActionController::Caching::Sweeper
  observe Paragraph, Pcomment # This sweeper is going to keep an eye on the Post model

  # If our sweeper detects that a Paragraph was saved
  def after_save(record)
          expire_cache_for(record)
  end
    
  # If our sweeper detects that a Paragraph was deleted call this
  def after_destroy(record)
          expire_cache_for(record)
  end
          
  private
  def expire_cache_for(record)
    logger.error "Expiring key #{record.cache_key}"
    expire_fragment(record.cache_key) #expire the fragment
  end
end
