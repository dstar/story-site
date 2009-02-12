class Universes < Application

  before :setup_everything

  def setup_authorize_hash
    if params[:id] and ! @universe
      @universe = Story.find(params[:id]).universe
      @universe_id = @universe.id
    end

    @authorization          = Universe.default_permissions

  end

  def check_authorization(user)
    if (! @universe)
      return true # If we don't have @universe, we're listing the universes, which is okay.
    end
    needed = @universe.required_permission(action_name)
    needed = @authorization[@universe.status][action_name] unless (needed and ! needed.empty?)
    if needed
      needed.each do |req|
        return true if req == "EVERYONE" # check for public action
        return true if user.has_universe_permission(@universe, req) # Else check that we have the required permission
      end
    end
    return false
  end

  def story_add_owner
    @story=Story.find(params[:story_id])
    render
  end

  def index
    list
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
#  verify :method => :post, :only => [ :destroy, :create, :update ],
#         :redirect_to => { :action => :list }

  def list
    @universes = Universe.find(:all)
    render :list
  end

  def show
    @universe = Universe.find(params[:id])
    @stories = Story.OrderedListByUniverse(@universe.id)
    render :show
  end

  def edit
    @universe = Universe.find(params[:id])
    render :edit
  end

  def update
    @universe = Universe.find(params[:id])
    if @universe.update_attributes(params[:universe])
      expire("universe_wstories#{@universe.id}")
      redirect "/universes/show/#{@universe.id}", :message => { :notice => 'Universe was successfully updated.'}
    else
      render :edit
    end
  end

  def destroy
    Universe.find(params[:id]).destroy
    redirect '/universes/list'
  end

  def setup_page_vars

    case action_name
    when /list|index/
      @page_title = 'Universe List'
    when /create|new/
      @page_title = 'New Universe'
    else
      begin
        @universe = Universe.find(params[:id])
        @page_title = @universe.name
      rescue ActiveRecord::RecordNotFound
        redirect "/", :message => { :error => 'Could not find requested Universe.'}
        throw :halt
      end
    end
  end

  def permissions_modify

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
      universe_permissions.universe_id=@universe.id
      unless universe_permissions.save
        message[:notice] = "Permission Add Failed"
      end
    else
      unless permission_holder
        msg = "Unknown User/Group."
      end
      unless params[:permission]
        msg = "No Permission Selected."
      end
      message[:notice]=msg
    end

    render :permissions
  end

  def permissions_destroy
    case params[:type]
    when /User/
      permission_holder = User.find_by_username(params[:permission_holder])
    when /Group/
      permission_holder = Group.find_by_group_name(params[:permission_holder])
    end

    permission = UniversePermission.find_by_permission_holder_type_and_permission_holder_id_and_permission_and_universe_id(params[:type], permission_holder.id,params[:permission],@universe.id)
    permission.destroy
    render :permissions
  end

 def story_add_owner_save

   msg = nil

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
        message[:notice] = "Permission Add Failed"
      end
    else
      unless permission_holder
        msg = "Unknown User/Group."
      end
      unless params[:permission]
        msg = "No Permission Selected."
      end
      message[:notice]=msg
    end

   render '/stories/permissions'
  end

 def add_story
   @stories = @authinfo[:user].stories
   render :add_story
 end

 def append_story
   @story = Story.find_by_title(params[:title])
   @story ||= Story.find_by_short_title(params[:short_title])
   if @story
     @story.universe = @universe
     @story.save
     redirect url(:controller => "universes", :action => "show", :id => @universe.id), :message => "#{@story.title} was successfully added."
   else
     search_text = params[:title]
     search_text = params[:short_title] if params[:title].blank?
     search_param = "title" unless params[:title].blank?
     search_param = "short title" unless search_param and params[:short_title].blank?
     @add_story_error = "Could not find story with #{search_param} '#{search_text}'."
     render :add_story
   end
 end

end
