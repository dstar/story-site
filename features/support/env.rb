# Sets up the Merb environment for Cucumber (thanks to krzys and roman)
require "rubygems"

# Add the local gems dir if found within the app root; any dependencies loaded
# hereafter will try to load from the local gems before loading system gems.
if (local_gem_dir = File.join(File.dirname(__FILE__), '..', 'gems')) && $BUNDLE.nil?
  $BUNDLE = true; Gem.clear_paths; Gem.path.unshift(local_gem_dir)
end

require "merb-core"
require 'spec/ruby'
#require 'spec/matchers'
require 'spec/expectations'
#require 'spec/example'
#require 'spec/version'
#require 'spec/dsl'
require "merb_cucumber/world/webrat"
require "merb_cucumber/helpers/activerecord"

# Uncomment if you want transactional fixtures
# Merb::Test::World::Base.use_transactional_fixtures

# Quick fix for post features running Rspec error, see
# http://gist.github.com/37930
#def Spec.run? ; true; end

Merb.start_environment(:testing => true, :adapter => 'runner', :environment => ENV['MERB_ENV'] || 'test')

ActiveRecord::Base.logger = Logger.new("/dev/null")

module MiscHelpers
  def xpath_search(xpath,node=nil)
    node ||= @_webrat_session.dom
    node.xpath(xpath)
    #Webrat::XML.xpath_search(node, xpath)
  end
end

World do |world|
  world.extend MiscHelpers
  world
end
