class Blogposts < Application

  before :setup_everything

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
    @blogposts = Blogpost.find(:all, :order => 'created_on desc')
    render :list
  end

  def list
    @blogposts = Blogpost.find(:all, :order => 'created_on desc')
    Merb.logger.debug "QQQ16: @blogposts is #{@blogposts.inspect}"
    render :list
  end

  def show
    @blogpost = Blogpost.find(params[:id])
    Merb.logger.debug "QQQ18: @blogpost is #{@blogpost.inspect}"
    render
  end

  def new
    @blogpost = Blogpost.new
    render :new
  end

  def create
    @blogpost = Blogpost.new(params[:blogpost])
    @blogpost.user = @authinfo[:user].username
    if @blogpost.save
      redirect "/blogposts/list", :message => {:notice => 'Blogpost was successfully created.' }
    else
      render :action => 'new'
    end
  end

  def edit
    @blogpost = Blogpost.find(params[:id])
    render :edit
  end

  def update
    @blogpost = Blogpost.find(params[:id])
    if @blogpost.update_attributes(params[:blogpost])
      expire("blogpost_#{@blogpost.id}")
      redirect "/blogposts/show/#{@blogpost.id}", :message => {:notice => 'Blogpost was successfully updated.' }
    else
      render :action => 'edit'
    end
  end

  def destroy
    Blogpost.find(params[:id]).destroy
    redirect '/list'
  end

end
