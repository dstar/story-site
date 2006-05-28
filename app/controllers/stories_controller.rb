class StoriesController < ApplicationController

  def setup_authorize_hash
    if params[:id] and ! @universe
      @universe = Story.find(params[:id]).universe
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

    @authorization = {
      "destroy" => [ { 'permission_type'=>"StoryPermission", 'permission'=>"author", 'id'=> @story_id } ],
      "update"  => [ { 'permission_type'=>"StoryPermission", 'permission'=>"author", 'id'=> @story_id } ],
      "edit"    => [ { 'permission_type'=>"StoryPermission", 'permission'=>"author", 'id'=> @story_id } ],
      "create"  => [ {'permission_type'=>"UniversePermission", 'permission'=>"owner", 'id'=>@universe_id},],
      "new"     => [ {'permission_type'=>"UniversePermission", 'permission'=>"owner", 'id'=>@universe_id},],
    }
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

  def new
    @story = Story.new
  end

  def create
    @story = Story.new(params[:story])
    @universes = Universe.find_all
     if @story.save
      flash[:notice] = 'Story was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @story = Story.find(params[:id])
    @universes = Universe.find_all
  end

  def update
    @story = Story.find(params[:id])
    if @story.update_attributes(params[:story])
      flash[:notice] = 'Story was successfully updated.'
      redirect_to :action => 'show', :id => @story.id
    else
      render :action => 'edit'
    end
  end

  def destroy
    Story.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def setup_page_vars
    unless (request.subdomains(0).first == 'playground')
      unless params[:action] == 'new' or params[:action] == 'create'
        @story = Story.find(params[:id])
      else
        @universe = Universe.find(params[:universe_id])
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
    end
  end

  def handle_url
    unless (request.subdomains(0).first == 'playground') or params[:action] == 'new' or params[:action] == 'create'
      params[:id] = Story.find_by_short_title(request.subdomains(0).first).id unless params[:id]
    end
  end

end
