class BlogpostsController < ApplicationController

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
    needed = @authorization[params[:action]]
    if needed 
      needed.each do |req|
        return true if req == "EVERYONE"
        return true if user.has_site_permission(req)
      end
    end
    return false #default deny
  end
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def archive
    @blogpost_pages, @blogposts = paginate :blogposts, :order => 'created_on desc', :per_page => 10
  end

  def list
    @blogposts = Blogpost.find(:all, :order => 'created_on desc')
  end

  def show
    @blogpost = Blogpost.find(params[:id])
  end

  def new
    @blogpost = Blogpost.new
  end

  def create
    @blogpost = Blogpost.new(params[:blogpost])
#    @blogpost.created_on = Time.now.strftime('%Y-%m-%d') unless @blogpost.created_on
    if @blogpost.save
      flash[:notice] = 'Blogpost was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @blogpost = Blogpost.find(params[:id])
  end

  def update
    @blogpost = Blogpost.find(params[:id])
    if @blogpost.update_attributes(params[:blogpost])
      flash[:notice] = 'Blogpost was successfully updated.'
      expire_fragment("blogpost_#{@blogpost.id}")
      redirect_to :action => 'show', :id => @blogpost
    else
      render :action => 'edit'
    end
  end

  def destroy
    Blogpost.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def setup_page_vars

    if params[:id]
      @blogpost = Blogpost.find(params[:id])
    end

    @description = {
      'edit'         => "Edit Blog Entry",
      'delete_story' => "Delete Blog Entry",
      'new'          => "New Blog Entry",
      'archive'      => "Older Entries",
      'list'         => "Blog Entries",
      'show'         => "Blog Entry"
    }
    

    if params[:action] =~ /archive/
      @page_title = "Blog Archive Page #{params[:page]}"
    else
      @page_title = "Blog"
    end
  end

end
