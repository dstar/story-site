class MemCache
  
  def read(key,options=nil)    
    begin
      get(key)
    rescue 
      ActiveRecord::Base.logger.error("MemCache Error: #{$!}")      
    end
  end
  
  def write(key,content,options=nil)
    expiry = options && options[:expire] || 0
    begin
      set(key,content,expiry)
    rescue 
      ActiveRecord::Base.logger.error("MemCache Error: #{$!}")      
    end
  end
end

module ActionView
  module Helpers
    # See ActionController::Caching::Fragments for usage instructions.
    module CacheHelper
      def cache(name = {}, options=nil, &block)
        @controller.cache_erb_fragment(block, name, options)
      end
    end
  end
end