module Merb
  module UsersHelper
    def new_story_link
      link_to 'New Story', url(:controller => "users", :action => "new_story", :id => @user.id) if @authinfo[:user] == @user && @user.has_site_permission("author")
    end
  end
end
