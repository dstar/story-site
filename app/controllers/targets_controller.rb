class TargetsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @targets = Target.OrderedList
  end

  def show
    @target = Target.find(params[:id])
    @month = Month.find(@target.month_id)
    @story = Story.find(@target.story_id)
  end

  def new
    @target = Target.new
  end

  def create
    @target = Target.new(params[:target])
    if @target.save
      flash[:notice] = 'Target was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @target = Target.find(params[:id])
    @month = Month.find(@target.month_id)
    @story = Story.find(@target.story_id)
  end

  def update
    @target = Target.find(params[:id])
    if @target.update_attributes(params[:target])
      flash[:notice] = 'Target was successfully updated.'
      redirect_to :action => 'show', :id => @target
    else
      render :action => 'edit'
    end
  end

  def destroy
    Target.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
