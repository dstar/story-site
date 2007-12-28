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
      nav_buffer += link_to 'Add Story', { :action => "new_story", :id => universe.id}
    end

    return nav_buffer
  end
  def breadcrumbs
    home_link = link_to 'Home', index_url(:host => StoryHost('playground')) 
    unless params[:action] =~ /list|index|create|new/ 
      return "#{home_link} &gt; #{@universe.name}"
    else 
      if params[:action] == 'list' or params[:action] == 'index' 
        return "#{home_link} &gt; Universe List"
      end 
    end 
  end

end
