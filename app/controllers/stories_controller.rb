class StoriesController < ApplicationController
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
    @story = Story.find(params[:id])
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
      redirect_to :action => 'show', :id => @story
    else
      render :action => 'edit'
    end
  end

  def destroy
    Story.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
