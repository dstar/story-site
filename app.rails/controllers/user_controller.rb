class UserController < ApplicationController

  def setup_authorize_hash
  end

  def check_authorization(user)
    return true if params[:action] == "show"
    return false
  end

  def setup_page_vars
    @user = User.find(params[:id])
  end
end
