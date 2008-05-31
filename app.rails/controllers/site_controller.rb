class SiteController < ApplicationController
  def setup_authorize_hash

    @authorization          = {
      "universe_owner_add_save" => ["admin"],
      "universe_add_owner" => ["admin"],
      "new_universe" => ["admin"],
      "create_universe" => ["admin"],
      "expire_cache" => ["admin"],
      "show" => ["EVERYONE"]
    }

  end

  def check_authorization(user)
    needed = @authorization[params[:action]]
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
      redirect_to :action => 'show', :controller => 'universes', :id => @universe.id
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

  def expire_cache
    #    expire_fragment(/.*/)
    CACHE.flush_all
    domain_length = request.subdomains.length
    hostname = request.subdomains[0]
    redirect_to index_url(:host => hostname.concat('.').concat(request.domain(domain_length)).concat(request.port_string))
  end

  def setup_page_vars
    @page_title = "Pele's Playground"
  end

  def show
    last_updated = CACHE.get("storylist_last_updated")
    last_updated = Date.new(0) unless last_updated.is_a? Date
    if (Date.today - last_updated) >= 1
      Story.find(:all).each do |story|
        expire_fragment("story_list#{story.id}#true")
        expire_fragment("story_list#{story.id}#false")
      end
      CACHE.set("storylist_last_updated", Date.today)
    end
    @stories = Story.OrderedList
  end

end
