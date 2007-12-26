module UniversesHelper

  def nav_links(universe)
    nav_buffer = ""
    if @authinfo[:user] and @authinfo[:user].has_universe_permission(universe,'owner')
      nav_buffer += link_to 'Edit Universe', :action => 'edit', :id => universe
      nav_buffer +=  " | "
      nav_buffer += link_to 'Edit Permissions', :action => 'permissions', :id => universe
      nav_buffer +=  " | "
    elsif @authinfo[:user] and @authinfo[:user].has_site_permission(universe,'admin')
      nav_buffer += link_to 'Edit Universe Permissions', :controller => 'universes', :action => 'add_owner', :id => @universe.id
      nav_buffer +=  " | "
    end
    nav_buffer += link_to 'Universe List', :action => 'list'
    if @authinfo[:user] and @authinfo[:user].has_universe_permission(universe,'owner')
      nav_buffer += " | "
      nav_buffer += link_to 'Add Story', { :action => "new_story", :universe_id => universe.id}
    end

    return nav_buffer
  end

end
