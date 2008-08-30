class Blogposts < Application

  def setup_authorize_hash
    @authorization = {
      "destroy" => [ "blogger", ],
      "update"  => [ "blogger", ],
      "edit"    => [ "blogger", ],
      "create"  => [ "blogger", ],
      "new"     => [ "blogger", ],
      "archive" => [ "EVERYONE" ],
      "index"   => [ "EVERYONE" ],
      "list"    => [ "EVERYONE" ],
      "show"    => [ "EVERYONE" ],
    }
  end

  def check_authorization(user)
    Merb.logger.debug("QQQ: #{ action_name} => User: #{user.id}, #{self.request.cookies.inspect}")
    needed = @authorization[action_name]
    if needed
      needed.each do |req|
        return true if req == "EVERYONE"
        Merb.logger.debug("QQQ: User #{user.id}has #{req}") if user.has_site_permission(req)
        return true if user.has_site_permission(req)
      end
    end
    return false #default deny
  end

  def setup_page_vars
    @description = {
      'edit'         => "Edit Blog Entry",
      'delete_story' => "Delete Blog Entry",
      'new'          => "New Blog Entry",
      'archive'      => "Older Entries",
      'list'         => "Blog Entries",
      'show'         => "Blog Entry"
    }


    if action_name =~ /archive/
      @page_title = "Blog Archive Page #{params[:page]}"
    else
      @page_title = "Blog"
    end
  end

  def index
    list
  end

  def list
    @blogposts = Blogpost.find(:all, :order => 'created_on desc')
    render 'list'
  end

  def show
    @blogpost = Blogpost.find(params[:id])
    render
  end

  def new
    @blogpost = Blogpost.new
    render 'new'
  end

  def create
    @blogpost = Blogpost.new(params[:blogpost])
    @blogpost.user = @authinfo[:user].username
    if @blogpost.save
      flash[:notice] = 'Blogpost was successfully created.'
      redirect("/site/show")
    else
      render 'new'
    end
  end

  def edit
    @blogpost = Blogpost.find(params[:id])
    render 'edit'
  end

  def update
    @blogpost = Blogpost.find(params[:id])
    if @blogpost.update_attributes(params[:blogpost])
      flash[:notice] = 'Blogpost was successfully updated.'
      expire("blogpost_#{@blogpost.id}")
      redirect "/show/#{@blogpost.id}"
    else
      render :action => 'edit'
    end
  end

  def destroy
    Blogpost.find(params[:id]).destroy
    redirect '/list'
  end

end
