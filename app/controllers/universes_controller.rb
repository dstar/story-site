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
end
