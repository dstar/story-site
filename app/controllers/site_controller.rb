class SiteController < ApplicationController
  def setup_authorize_hash
    
    @authorization          = {
      "universe_owner_add_save" => ["admin"],
      "universe_add_owner" => ["admin"],
      "new_universe" => ["admin"],
      "create_universe" => ["admin"]
    }

  end

  def check_authorization(user)
    needed = @authorization[@universe.status][params[:action]]
    if needed
      needed.each do |req|
        return true if req == "EVERYONE" # check for public action
        return true if user.has_site_permission(req) # Else check that we have the required permission
      end
    end
    return false
  end
  
  def new_universe
    @universe = Universe.new
  end

  def create_universe
    @universe = Universe.new(params[:universe])
    if @universe.save
      flash[:notice] = 'Universe was successfully created.'
      redirect_to :action => 'show', :controller => 'universe', :id => @universe.id
    else
      render :action => 'new_universe'
    end
  end
  
  def universe_add_owner
    @universe = Universe.find(params[:id])
  end
  
  def universe_owner_add_save

    case params[:type]
    when /user/
      permission_holder = User.find_by_username(params[:permission_holder])
    when /group/
      permission_holder = Group.find_by_group_name(params[:permission_holder])
    end
    
    if permission_holder and params[:permission]
      universe_permissions=UniversePermission.new
      universe_permissions.permission_holder = permission_holder
      universe_permissions.permission=params[:permission]
      universe_permissions.universe_id=params[:universe_id]      
      unless universe_permissions.save
        flash[:notice] = "Permission Add Failed"
      end
    else
      unless permission_holder
        message = "Unknown User/Group."
      end
      unless params[:permission]
        message = "No Permission Selected."
      end
      flash[:notice]=message
      render :action => 'permissions'
    end
    
    render :action => 'permissions'
  end
  
end
