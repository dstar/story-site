require 'rubygems'
Gem.clear_paths
Gem.path.unshift(File.join(File.dirname(__FILE__), "gems"))

require 'rake'
require 'rake/rdoctask'
require 'rake/testtask'
require 'spec/rake/spectask'
require 'fileutils'
require 'merb-core'
require 'rubigen'
include FileUtils

# Load the basic runtime dependencies; this will include
# any plugins and therefore plugin rake tasks.
init_env = ENV['MERB_ENV'] || 'rake'
Merb.load_dependencies(:environment => init_env)

# Get Merb plugins and dependencies
Merb::Plugins.rakefiles.each { |r| require r }

desc "start runner environment"
task :merb_env do
  Merb.start_environment(:environment => init_env, :adapter => 'runner')
end

##############################################################################
# ADD YOUR CUSTOM TASKS BELOW
##############################################################################

desc "Add new files to subversion"
task :svn_add do
   system "svn status | grep '^\?' | sed -e 's/? *//' | sed -e 's/ /\ /g' | xargs svn add"
end

desc "start test environment"
task :test_env do
  Merb.start_environment(:environment => 'test', :adapter => 'runner')
end

desc "Run all tests (TASK=regexp to run specific files only)"
task :test => :test_env do
  only = ENV['TASK']
  test_files = FileList[File.join('test', '**', '*_test.rb')]
  test_files = test_files.select { |path| path =~ Regexp.new(only) } if only
  test_files.each { |f| require f }
end
