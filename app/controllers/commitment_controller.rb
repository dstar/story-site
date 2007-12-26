class CommitmentController < ApplicationController
  def setup_authorize_hash
    @authorization = {
      "destroy" => [ { 'permission_type'=>"SitePermission", 'permission'=>"admin", } ],
      "update"  => [ { 'permission_type'=>"SitePermission", 'permission'=>"admin", } ],
      "edit"    => [ { 'permission_type'=>"SitePermission", 'permission'=>"admin", } ],
      "create"  => [ {'permission_type'=>"SitePermission", 'permission'=>"admin", },],
      "new"     => [ {'permission_type'=>"SitePermission", 'permission'=>"admin", },],
      "list"     => [ {'permission_type'=>"SitePermission", 'permission'=>"admin", },],
    }

  end

  def destroy
    @commitment = Commitment.find(params[:id])
    if @commitment.destroy
      flash[:notice] = 'Commitment was successfully deleted.'
    else
      flash[:notice] = 'Commitment was not deleted: .'
    end
    redirect_to :action => 'list'
  end

  def update
    @commitment = Commitment.find(params[:id])
    params[:commitment][:commitment_date] = params[:date]
    if @commitment.update_attributes(params[:commitment])
      flash[:notice] = 'Commitment was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def edit
    @commitment = Commitment.find(params[:id])
  end

  def new
    @commitment = Commitment.new
  end

  def create
    params[:commitment][:commitment_date] = params[:date]
    @commitment = Commitment.new(params[:commitment])
    if @commitment.save
      flash[:notice] = 'Commitment was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end


end
