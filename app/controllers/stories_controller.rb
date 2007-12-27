class StoriesController < ApplicationController

  def setup_authorize_hash
    if params[:id] and ! @universe
      @universe = Story.find(params[:id]).universe
    end
    if params[:id] and ! @story
      @story = Story.find(params[:id])
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
    @authorization = Story.default_permissions
  end

  def check_authorization(user)
    if request.subdomains(0).first == 'playground' and params[:action] == 'show'
      return true
    end
    return false unless @story
    logger.debug "SubD is #{request.subdomains(0).first}, action is #{params[:action]}"
    needed = @story.required_permission(params[:action])
    needed = @authorization[@story.status][params[:action]] unless (needed and ! needed.empty?)
    if needed
      needed.each do |req|
        return true if req == "EVERYONE" # check for public action
        return true if user.has_story_permission(@story, req) # Else check that we have the required permission
      end
    end
    return false
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

  def playground
    list
    render :action => 'playground', :layout => 'playground' 
  end

  def edit
    @story = Story.find(params[:id])
    @universes = Universe.find(:all)
  end

  def update
    @story = Story.find(params[:id])
    params[:story][:description].gsub!(/\s+--/, "--")
    if @story.update_attributes(params[:story])
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

    @description = {
      'permissions'  => "Edit Permissions",
      'edit'         => "Edit Story",
      'delete_story' => "Delete Story",
    }

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

  def new_chapter
    @story = Story.find(params[:id])
    @chapter = Chapter.new
    @chapter.story_id = @story.id
    @chapter.number = Chapter.count_by_sql ["Select max(number) from chapters where story_id = ?", @story.id]
    @chapter.number = @chapter.number + 1
  end

  def create_chapter
    @chapter = Chapter.new(params[:chapter])
    @chapter.date_uploaded = Time.now.strftime('%Y-%m-%d %H:%M:%S') unless @chapter.date_uploaded
    if @chapter.save
      release_chapter(@chapter) if @chapter.status == 'released'
      process_file(params[:file],@chapter.id) unless params[:file].blank?
      flash[:notice] = 'Chapter was successfully created.'
      redirect_to :controller => 'stories', :action => 'show', :id => @chapter.story_id
    else
      render :action => 'new'
    end
  end


end
