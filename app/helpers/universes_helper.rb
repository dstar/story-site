module Merb
module UniversesHelper

  def nav_links(universe)
    nav_buffer = ""
    if @authinfo[:user] and @authinfo[:user].has_universe_permission(universe,'owner')
      nav_buffer += link_to 'Edit Universe', url(:action => 'edit', :id => universe)
      nav_buffer +=  " | "
      nav_buffer += link_to 'Edit Permissions', url(:action => 'permissions', :id => universe)
      nav_buffer +=  " | "
    elsif @authinfo[:user] and @authinfo[:user].has_site_permission('admin')
      nav_buffer += link_to 'Edit Universe Permissions', url(:controller => 'universes', :action => 'add_owner', :id => @universe.id)
      nav_buffer +=  " | "
    end
    nav_buffer += link_to 'Universe List', url(:action => 'list')
    if @authinfo[:user] and @authinfo[:user].has_universe_permission(universe,'owner')
      nav_buffer += " | "
      nav_buffer += link_to 'Add Story', url( :action => "add_story", :id => universe.id)
    end

    return nav_buffer
  end

  def breadcrumbs
    home_link = link_to 'Home', "#{StoryHost('playground')}/"
    unless action_name =~ /list|index|create|new/
      return "#{home_link} &gt; #{@universe.name}"
    else
      if action_name == 'list' or action_name == 'index'
        return "#{home_link} &gt; Universe List"
      end
    end
  end

end
end
