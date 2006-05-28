class UniversesController < ApplicationController

  def setup_authorize_hash
    if params[:id] and ! @universe
      @universe = Story.find(params[:id]).universe
      @universe_id = @universe.id
    elsif @universe
      @universe_id = @universe.id
    else
      @universe_id = ""
    end

    @authorization = {
      "destroy"    => [ {'permission_type'=>"UniversePermission", 'permission'=>"owner", 'id'=>@universe_id},],
      "update"     => [ {'permission_type'=>"UniversePermission", 'permission'=>"owner", 'id'=>@universe_id},],
      "edit"       => [ {'permission_type'=>"UniversePermission", 'permission'=>"owner", 'id'=>@universe_id},],
      "create"     => [ {'permission_type'=>"SitePermission", 'permission'=>"administrator", },],
      "new"        => [ {'permission_type'=>"SitePermission", 'permission'=>"administrator", },],
    }

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

    case params[:action]
    when /list|index/
      @page_title = 'Universe List'
    when /create|new/
      @page_title = 'New Universe'
    else
      @universe = Universe.find(params[:id])
      @page_title = @universe.name
    end
  end


end
