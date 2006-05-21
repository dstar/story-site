class UniversesController < ApplicationController

  def setup_authorize_hash
    if params[:id] and ! @universe
      @universe = Story.find(params[:id]).universe
    end

    @authorization = {
      "destroy"    => proc { check_universe_permission("owner") },
      "update"     => proc { check_universe_permission("owner") },
      "edit"       => proc { check_universe_permission("owner") },
      "create"     => proc { check_site_permission("administrator") },
      "new"        => proc { check_site_permission("administrator") },
      "show"       => proc { true },
      "list"       => proc { true },
      "showByName" => proc { true },
      "showBySubD" => proc { true },
      "index"      => proc { true }
    }
  end

  def check_site_permission(permission)
    if @authinfo[:user_id]
      user = User.find_by_user_id(@authinfo[:user_id])
      user.has_site_permission(permission) ? true : admonish("You are not authorized for this action!")
    else
      admonish("You are not authorized for this action!")
    end
  end

  def check_universe_permission(permission)
    if @authinfo[:user_id]
      user = User.find_by_user_id(@authinfo[:user_id])
      user.has_universe_permission(@universe.id,permission) ? true : admonish("You are not authorized for this action!")
    else
      admonish("You are not authorized for this action!")
    end
  end

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @universes = Universe.find_all
  end

  def show
    @universe = Universe.find(params[:id])
    @stories = Story.OrderedListByUniverse(@universe.id)
  end

  def new
    @universe = Universe.new
  end

  def create
    @universe = Universe.new(params[:universe])
    if @universe.save
      flash[:notice] = 'Universe was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @universe = Universe.find(params[:id])
  end

  def update
    @universe = Universe.find(params[:id])
    if @universe.update_attributes(params[:universe])
      flash[:notice] = 'Universe was successfully updated.'
      redirect_to :action => 'show', :id => @universe.id
    else
      render :action => 'edit'
    end
  end

  def destroy
    Universe.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def setup_page_vars

    logger.debug "#{params.inspect}"

    home_link = "#{link_to 'Home', index_url(:host => StoryHost('playground'}"

    @breadcrumbs = "#{home_link}"

    case params[:action]
    when /list|index/
      @page_title = 'Universe List'
    when /create|new/
      @page_title = 'New Universe'
    else
      @universe = Universe.find(params[:id])
      @page_title = @universe.name
      @breadcrumbs += " > #{@universe.name }"
    end
  end


end
