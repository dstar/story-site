module CacheShim
  def self.included(base)
    base.class_eval { include(InstanceMethods)}
  end

  module InstanceMethods

    def expire(key)
      if key.respond_to? 'cache_key'
        key = key.cache_key
      end
      Merb::Cache[:default].delete(key)
    end

    def cache(key, opts = {}, conditions = {}, &block)
      if key.respond_to? 'cache_key'
        key = key.cache_key
      end
      opts[:cache_key] = key
      fetch_fragment opts, conditions, &block
    end

  end
end
