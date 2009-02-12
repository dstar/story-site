class Users < Application

  before :setup_everything

  def setup_authorize_hash
    @authorization          = User.default_permissions
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

  def setup_page_vars
    @user = User.find(params[:id])
  end

  def show
    Merb.logger.debug("QQQ12: _session_secret_key is #{request._session_secret_key}")
    render :show
  end

  def new_story
    @story = Story.new
    render :new_story
  end

  def create_story
    @story = Story.new(params[:story])
    @story.file_prefix = @story.short_title unless @story.file_prefix
    @story.description.gsub!(/\s+--/, "--")
     if @story.save

       story_permission=StoryPermission.new
       story_permission.permission_holder = @authinfo[:user]
       story_permission.permission = "author"
       story_permission.story_id = @story.id
       story_permission.save

       redirect "/stories/show/#{@story.id}", :message => { :notice => 'Story was successfully created.'}
    else
       Merb.logger.debug("QQQ26: errors: #{@story.errors.inspect}")
       render :new_story
    end
  end

end
