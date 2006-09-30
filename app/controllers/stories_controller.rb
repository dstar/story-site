class StoriesController < ApplicationController

  def setup_authorize_hash
    if params[:id] and ! @universe
      @universe = Story.find(params[:id]).universe
    end

    if @universe
      @universe_id = @universe.id
    else
      @universe_id = ''
    end

    if @story
      @story_id = @story.id
    else
      @story_id = ''
    end
    @authorization = {
      "destroy" => [ { 'permission_type'=>"StoryPermission", 'permission'=>"author", 'id'=> @story_id } ],
      "update"  => [ { 'permission_type'=>"StoryPermission", 'permission'=>"author", 'id'=> @story_id } ],
      "edit"    => [ { 'permission_type'=>"StoryPermission", 'permission'=>"author", 'id'=> @story_id } ],
      "create"  => [ {'permission_type'=>"UniversePermission", 'permission'=>"owner", 'id'=>@universe_id},],
      "new"     => [ {'permission_type'=>"UniversePermission", 'permission'=>"owner", 'id'=>@universe_id},],
    }

  end


  layout "stories"

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @stories = Story.OrderedList
  end

  def show
    if (request.subdomains(0).first == 'playground')
      list
      render :action => 'playground', :layout => 'playground'
    else
    @story = Story.find(params[:id])
      render :action => 'show'
    end
  end

  def showByName
    @story = Story.find_by_short_title(params[:story])
    render :action => 'show'
  end

  def showBySubD
    if (request.subdomains(0).first == 'playground')
      list
      render :action => 'playground', :layout => 'playground'
    else
      @story = story
      render :action => 'show'
    end
  end

  def new
    @story = Story.new
  end

  def create
    @story = Story.new(params[:story])
    @universes = Universe.find_all
    @story.description.gsub!(/\s+--/, "--")
     if @story.save
      flash[:notice] = 'Story was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @story = Story.find(params[:id])
    @universes = Universe.find_all
  end

  def update
    @story = Story.find(params[:id])
    params[:story][:description].gsub!(/\s+--/, "--")
    if @story.update_attributes(params[:story])
      logger.debug "QQQ: BBB Description: #{@story.description}\n"
      flash[:notice] = 'Story was successfully updated.'
      redirect_to :action => 'show', :id => @story.id
    else
      render :action => 'edit'
    end
  end

  def destroy
    @story = Story.find(params[:id])
    @story_title = @story.title
    if @story.destroy
      flash[:notice] = '#{@story_title} was successfully deleted.'      
    else
      flash[:notice] = '#{@story_title} was not deleted: .'
    end
    redirect_to :action => 'list'
  end

  def setup_page_vars
    unless (request.subdomains(0).first == 'playground')
      unless params[:action] == 'new' or params[:action] == 'create'
        @story = Story.find(params[:id])
      else
        if params[:universe_id]
          @universe = Universe.find(params[:universe_id])
        else
          @universe = Universe.find(params[:story][:universe_id])
        end
      end

      case params[:action]
      when /list/
        @page_title = 'Story List'
      when 'new'
        @page_title = 'New Story'
      when 'create'
        @page_title = 'New Story'
      else
        @page_title = @story.title
      end
    else
      @page_title = "Pele's Playground"
      if params[:universe_id]
        @universe = Universe.find(params[:universe_id])
      end
      if params[:story] 
        if params[:story][:universe_id]
          @universe = Universe.find(params[:story][:universe_id])
        end
      end
    end
  end

  def handle_url
    unless (request.subdomains(0).first == 'playground') or params[:action] == 'new' or params[:action] == 'create'
      params[:id] = Story.find_by_short_title(request.subdomains(0).first).id unless params[:id]
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
      universe_permissions=StoryPermission.new
      universe_permissions.permission_holder = permission_holder
      universe_permissions.permission=params[:permission]
      universe_permissions.story_id=params[:story_id]      
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
      universe_permissions=StoryPermission.new
      universe_permissions.permission_holder = permission_holder
      universe_permissions.permission=params[:permission]
      universe_permissions.story_id=params[:story_id]      
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
    
    permission = StoryPermission.find_by_permission_holder_type_and_permission_holder_id_and_permission_and_story_id(params[:type], permission_holder.id,params[:permission],params[:story_id])
    permission.destroy
    render :action => 'permissions'
  end


end
