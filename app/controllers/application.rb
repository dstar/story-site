class Application < Merb::Controller

  before :setup_page_vars

  before :setup_auth_structures
  before :setup_authorize_hash
  before :authenticate

  def setup_auth_structures
    #We use @authinfo[:key] to pass around the php session_id

    @sid = cookies[:phpbb2mysql_sid]

    Merb.logger.debug "QQQ8: Sid is #{@sid}"

    unless controller_name == "style" and action_name == "show"
      cookies[:login_redirect_to] = { :value => request.path, :domain => "pele.cx" }
    end

    @authinfo = Hash.new

    if @sid
      begin
        @authinfo[:session] = PhpSession.find_by_session_id(@sid)
        if @authinfo[:session] then
          user = User.find(@authinfo[:session].session_user_id)
          @authinfo[:user] = user
          # stick the user object itself in, so we don't have to look it up later
          #at this point, we've verified that the session is still live
          @authinfo[:sid] = @sid
        else
          #no session
          @authinfo = Hash.new
        end

      rescue ActiveRecord::RecordNotFound
        #means we don't have a live session,
        @authinfo = Hash.new
      end
    else
      @authinfo = Hash.new
    end
    @authinfo[:user] ||= User.find(-1)
  end

  def authenticate
    if check_authorization(@authinfo[:user])
      Merb.logger.debug("QQQ2: #{ @authinfo[:user].id } is authorized for #{action_name}")
      true
    else
      Merb.logger.debug("QQQ2: #{ @authinfo[:user].id } is NOT authorized for #{action_name}")
      admonish("You are not authorized for this action!")
    end

  end

  def admonish(message)
    flash[:notice] = message
#    Merb.logger.debug("Request is #{request.inspect}")
    redirect request.referer
    throw :halt
  end

end
