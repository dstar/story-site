class Site < Application

  before :setup_everything

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
    needed = @authorization[action_name]
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
    render :new_universe
  end

  def create_universe
    @universe = Universe.new(params[:universe])
    if @universe.save
      redirect "/universes/show/#{@universe.id}", :message => {:notice => 'Universe was successfully created.' }
    else
      Merb::logger.debug("QQQ: did not create universe with params = #{params[:universe]}")
      render :new_universe
    end
  end

  def universe_add_owner
    @universe = Universe.find(params[:id])
    render :universe_add_owner
  end

  def universe_owner_add_save

    msg = nil

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
        msg = "Permission Add Failed"
      end
    else
      unless permission_holder
        msg = "Unknown User/Group."
      end
      unless params[:permission]
        msg = "No Permission Selected."
      end
      message[:notice]=msg
      render :universe_add_owner
    end

    redirect url(:controller => :universes, :action => :permissions, :id => params[:universe_id]), :message => {:notice => msg }

  end

  def expire_cache
    #    expire_fragment(/.*/)
    Merb::Cache[:default].delete_all
    redirect "http://#{request.host}/"
  end

  def setup_page_vars
    @page_title = "Pele's Playground"
  end

  def show
    @stories = Story.OrderedList
    Merb.logger.debug "QQQ4: About to call Blogposts.frontpagelist"
    @blogposts_to_show = Blogpost.frontpagelist
    Merb.logger.debug "QQQ4: About to call render"
    Merb.logger.debug "QQQ21: message[:notice] is #{message.inspect}"
    render :show
  end

end
