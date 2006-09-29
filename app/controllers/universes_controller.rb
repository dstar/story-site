class UniversesController < ApplicationController

  def setup_authorize_hash
    if params[:id] and ! @universe
      @universe = Story.find(params[:id]).universe
      @universe_id = @universe.id
    elsif @universe
      @universe_id = @universe.id
    else
      @universe_id = ""
    end

    @authorization          = {
      "destroy"             => [ {'permission_type'=>"UniversePermission", 'permission'=>"owner", 'id'=>@universe_id},],
      "update"              => [ {'permission_type'=>"UniversePermission", 'permission'=>"owner", 'id'=>@universe_id},],
      "edit"                => [ {'permission_type'=>"UniversePermission", 'permission'=>"owner", 'id'=>@universe_id},],
      "permissions"         => [ {'permission_type'=>"UniversePermission", 'permission'=>"owner", 'id'=>@universe_id},],
      "permissions_modify"  => [ {'permission_type'=>"UniversePermission", 'permission'=>"owner", 'id'=>@universe_id},],
      "permissions_destroy" => [ {'permission_type'=>"UniversePermission", 'permission'=>"owner", 'id'=>@universe_id},],
      "owner_add"           => [ {'permission_type'=>"SitePermission", 'permission'=>"admin", },],
      "owner_add_save"      => [ {'permission_type'=>"SitePermission", 'permission'=>"admin", },],
      "create"              => [ {'permission_type'=>"SitePermission", 'permission'=>"admin", },],
      "new"                 => [ {'permission_type'=>"SitePermission", 'permission'=>"admin", },],
    }

  end

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @universes = Universe.find_all
  end

  def show
    @universe = Universe.find(params[:id])
    @stories = Story.OrderedListByUniverse(@universe.id)
  end

  def new
    @universe = Universe.new
  end

  def create
    @universe = Universe.new(params[:universe])
    if @universe.save
      flash[:notice] = 'Universe was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @universe = Universe.find(params[:id])
  end

  def update
    @universe = Universe.find(params[:id])
    if @universe.update_attributes(params[:universe])
      flash[:notice] = 'Universe was successfully updated.'
      redirect_to :action => 'show', :id => @universe.id
    else
      render :action => 'edit'
    end
  end

  def destroy
    Universe.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def setup_page_vars

    case params[:action]
    when /list|index/
      @page_title = 'Universe List'
    when /create|new/
      @page_title = 'New Universe'
    else
      @universe = Universe.find(params[:id])
      @page_title = @universe.name
    end
  end

  def permissions_modify

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

  def owner_add_save

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

  def permissions_destroy
    case params[:type]
    when /User/
      permission_holder = User.find_by_username(params[:permission_holder])
    when /Group/
      permission_holder = Group.find_by_group_name(params[:permission_holder])
    end
    
    permission = UniversePermission.find_by_permission_holder_type_and_permission_holder_id_and_permission_and_universe_id(params[:type], permission_holder.id,params[:permission],params[:universe_id])
    permission.destroy
    render :action => 'permissions'
  end


end
