class Stories < Application
  def setup_authorize_hash
    @authorization = Story.default_permissions
  end

  def check_authorization(user)
    Merb.logger.debug("QQQ3: [#{action_name}] params[:id] is #{params[:id]}")
    Merb.logger.debug("QQQ3: [#{action_name}] @story is #{@story.inspect}")
    Merb.logger.debug("QQQ3: [#{action_name}] @authorization is #{@authorization.inspect}")
    return false unless @story
    needed = @story.required_permission(action_name)
    needed = @authorization[@story.status][action_name] unless (needed and ! needed.empty?)
    if needed
      needed.each do |req|
        Merb.logger.debug("QQQ4: [#{action_name}] Checking #{req}; #{user.username}.has_story_permission(#{@story.id},#{req}) == #{user.has_story_permission(@story,req)}")
        return true if req == "EVERYONE" # check for public action
        return true if user.has_story_permission(@story, req) # Else check that we have the required permission
      end
    end
    Merb.logger.debug("QQQ3: [#{action_name}] returning false!")
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
    render 'edit'
  end

  def update
    @story = Story.find(params[:id])
    params[:story][:description].gsub!(/\s+--/, "--")
    if @story.update_attributes(params[:story])
      expire("story_#{@story.id}")
      expire("story_list#{@story.id}#true")
      expire("story_list#{@story.id}#false")
      expire("stories_for_universe#{@story.id}")
      cache_set("storylist_last_updated", Date.today)
      flash[:notice] = 'Story was successfully updated.'
      redirect "/stories/show/#{@story.id}"
    else
      render 'edit'
    end
  end

  def delete_story
    @page_title = "Delete #{@story.title}"
    @description = @page_title
    render 'delete_story'
  end

  def destroy
    @story_title = @story.title
    if @story.destroy
      flash[:notice] = '#{@story_title} was successfully deleted.'
    else
      flash[:notice] = '#{@story_title} was not deleted: .'
    end
    redirect "/universes/show/#{@universe.id}"
  end


end
