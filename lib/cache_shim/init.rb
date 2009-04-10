$:.unshift "#{File.dirname(__FILE__)}/lib"
require 'cache_shim'
ActiveRecord::Base.class_eval { include CacheShim }
Merb::Controller.class_eval { include CacheShim }
