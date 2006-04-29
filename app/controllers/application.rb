# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  attr_writer :story
  attr_reader :story
  before_filter do |c|
    c.story = Story.find_by_short_title(c.request.subdomains(0).first)
  end
end
