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
      redirect_to :action => 'show', :id => @story
    else
      render :action => 'edit'
    end
  end

  def destroy
    Story.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def setup_page_vars

    logger.debug "#{params.inspect}"

    unless (request.subdomains(0).first == 'playground')

      @story = Story.find(params[:id])

      home_link = %Q{<a href="http://#{request.host_with_port}/">Home</a>}
      universe_link =  %Q|<a href="#{url_for  :controller => 'universes', :action => 'show', :id => @story.universe.id  }">#{@story.universe.name}</a>|

        @breadcrumbs = "#{home_link}"
      @breadcrumbs += " > #{universe_link }"

      if params[:action] =~ /list/
        @page_title = 'Story List'
      else
        @page_title = @story.title
        @breadcrumbs += " > #{@story.title }"
      end
    else
      home_link = %Q{<a href="http://#{request.host_with_port}/">Home</a>}
      @breadcrumbs = "#{home_link}"
      @page_title = "Pele's Playground"
    end
  end

  def handle_url
    unless (request.subdomains(0).first == 'playground')
      params[:id] = Story.find_by_title(request.subdomains.first).id unless params[:id]
    end
  end

end
