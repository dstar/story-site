class Users < Application

  before :setup_everything

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
    Merb.logger.debug("QQQ12: _session_secret_key is #{request._session_secret_key}")
    render :show
  end

end
