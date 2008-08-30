class Users < Application

  def setup_authorize_hash
  end

  def check_authorization(user)
    return true if action_name == "show"
    return false
  end

  def setup_page_vars
    @user = User.find(params[:id])
  end

  def show
    render 'show'
  end

end
