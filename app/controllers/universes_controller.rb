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

    @authorization          = Universe.default_permissions

  end

  def check_authorization(user)
    if (! @universe) 
      return true # If we don't have @universe, we're listing the universes, which is okay.
    end
    needed = @universe.required_permission(params[:action])
    needed = @authorization[@universe.status][params[:action]] unless (needed and ! needed.empty?)
    if needed
      needed.each do |req|
        return true if req == "EVERYONE" # check for public action
        return true if user.has_universe_permission(@universe, req) # Else check that we have the required permission
      end
    end
    return false
  end
  
  def story_add_owner
    @story=Story.find(params[:id])
  end
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @universes = Universe.find(:all)
  end

  def show
    @universe = Universe.find(params[:id])
    @stories = Story.OrderedListByUniverse(@universe.id)
  end

  
def new_story
    @story = Story.new
    @universe = Universe.find(params[:id])
  end

  def create_story
    @story = Story.new(params[:story])
    @story.file_prefix = @story.short_title unless @story.file_prefix
    @story.description.gsub!(/\s+--/, "--")
     if @story.save
      flash[:notice] = 'Story was successfully created.'
      redirect_to :action => 'show', :controller => 'stories', :id => @story.id
    else
      render :action => 'new_story'
    end
  end
  
  def edit
    @universe = Universe.find(params[:id])
  end

  def update
    @universe = Universe.find(params[:id])
    if @universe.update_attributes(params[:universe])
      expire_fragment("universe_wstories#{@universe.id}")
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

 def story_owner_add_save

    case params[:type]
    when /user/
      permission_holder = User.find_by_username(params[:permission_holder])
    when /group/
      permission_holder = Group.find_by_group_name(params[:permission_holder])
    end

    if permission_holder and params[:permission]
      story_permission=StoryPermission.new
      story_permission.permission_holder = permission_holder
      story_permission.permission=params[:permission]
      story_permission.story_id=params[:story_id]
      unless story_permission.save
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
      render :action => 'permissions', :controller => 'story'
    end

    render :action => 'permissions', :controller => 'story'
  end
end
