class BlogpostsController < ApplicationController

  def setup_authorize_hash
    @authorization = { 
      "destroy" => [ {'permission_type'=>"SitePermission", 'permission'=>"blogger", },],
      "update"  => [ {'permission_type'=>"SitePermission", 'permission'=>"blogger", },],
      "edit"    => [ {'permission_type'=>"SitePermission", 'permission'=>"blogger", },],
      "create"  => [ {'permission_type'=>"SitePermission", 'permission'=>"blogger", },],
      "new"     => [ {'permission_type'=>"SitePermission", 'permission'=>"blogger", },],
    }
  end

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def archive
    @blogpost_pages, @blogposts = paginate :blogposts, :order => 'posted desc', :per_page => 10
  end

  def list
    @blogposts = Blogpost.find(:all, :order => 'posted desc')
  end

  def show
    @blogpost = Blogpost.find(params[:id])
  end

  def new
    @blogpost = Blogpost.new
  end

  def create
    @blogpost = Blogpost.new(params[:blogpost])
#    @blogpost.posted = Time.now.strftime('%Y-%m-%d') unless @blogpost.posted
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
    if params[:action] =~ /archive/
      @page_title = "Blog Archive Page #{params[:page]}"
    else
      @page_title = "Blog"
    end
  end

end
