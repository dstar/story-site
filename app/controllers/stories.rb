class Stories < Application

  before :setup_everything

  def setup_authorize_hash
    @authorization = Story.default_permissions
  end

  def check_authorization(user)
#    Merb.logger.debug("QQQ3: [#{action_name}] params[:id] is #{params[:id]}")
#    Merb.logger.debug("QQQ3: [#{action_name}] @story is #{@story.inspect}")
#    Merb.logger.debug("QQQ3: [#{action_name}] @authorization is #{@authorization.inspect}")
    return false unless @story
    needed = @story.required_permission(action_name)
    needed = @authorization[@story.status][action_name] unless (needed and ! needed.empty?)
    if needed
      needed.each do |req|
#        Merb.logger.debug("QQQ4: [#{action_name}] Checking #{req}; #{user.username}.has_story_permission(#{@story.id},#{req}) == #{user.has_story_permission(@story,req)}")
        return true if req == "EVERYONE" # check for public action
        return true if user.has_story_permission(@story, req) # Else check that we have the required permission
      end
    end
#    Merb.logger.debug("QQQ3: [#{action_name}] returning false!")
    return false
  end

  def setup_page_vars
    if params[:id]
      @story = Story.find(params[:id])
    else
      @story = Story.find_by_short_title(params[:short_title])
    end
    params[:id] ||= @story.id
    @universe = @story.universe
  end

  def show
    @page_title = @story.title
    render :show
  end

  def edit
    @page_title = "Edit #{@story.title}"
    @description = @page_title
    @story = Story.find(params[:id])
    @universes = Universe.find(:all)
    render :edit
  end

  def update
    @story = Story.find(params[:id])
    params[:story][:description].gsub!(/\s+--/, "--")
    if @story.update_attributes(params[:story])
      redirect "/stories/show/#{@story.id}", :message => {:notice => 'Story was successfully updated.' }
    else
      render :edit
    end
  end

  def delete_story
    @page_title = "Delete #{@story.title}"
    @description = @page_title
    render :delete_story
  end

  def destroy
    @story_title = @story.title
    if @story.destroy
      msg = '#{@story_title} was successfully deleted.'
    else
      msg = '#{@story_title} was not deleted: .'
    end
    redirect "/universes/show/#{@universe.id}", :message => { :notice => msg }
  end

  def create_chapter
#    Merb.logger.debug "QQQ28: file field is #{@tempfile.inspect}"
#    Merb.logger.debug "QQQ28: file field methods are #{params[:file].methods.collect { |m| m.match /.*file.*/}.compact}"
    @chapter = Chapter.new(params[:chapter])
    @chapter.story = @story
    @chapter.date_uploaded = Time.now.strftime('%Y-%m-%d %H:%M:%S') unless @chapter.date_uploaded
    @chapter.file = "#{@chapter.story.short_title}_#{@chapter.number}.html"
    if @chapter.save
      @chapter.process_file(params[:file][:tempfile]) unless params[:file].blank?
      redirect "/stories/show/#{@chapter.story_id}", :message => { :notice => 'Chapter was successfully created.'}
    else
      render :new_chapter
    end
  end

  def new_chapter
    @chapter = Chapter.new
    @chapter.number = @story.chapters.length+1
    render :new_chapter
  end

  def permissions
    @page_title = "Change Permissions for #{@story.title}"
    @description = @page_title
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
        message[:notice] = "Permission Add Failed"
      end
    else
      unless permission_holder
        message[:notice] = "Unknown User/Group."
      end
      unless params[:permission]
        message[:notice] = "No Permission Selected."
      end
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

    permission = StoryPermission.find_by_permission_holder_type_and_permission_holder_id_and_permission_and_story_id(params[:type], permission_holder.id,params[:permission],params[:story_id])
    permission.destroy
    render :permissions
  end

end
