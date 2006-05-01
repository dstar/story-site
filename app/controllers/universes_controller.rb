class UniversesController < ApplicationController
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
      redirect_to :action => 'show', :id => @universe
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

    home_link = %Q{<a href="http://#{request.host_with_port}/">Home</a>}


    @breadcrumbs = "#{home_link}"

    if params[:action] =~ /list|index/
      @page_title = 'Universe List'
    else
      @universe = Universe.find(params[:id])
      @page_title = @universe.name
      @breadcrumbs += " > #{@universe.name }"
    end
  end


end
