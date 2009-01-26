class Application < Merb::Controller

#     before :setup_page_vars
#     before :setup_auth_structures
#     before :setup_authorize_hash
#     before :authorize

  def setup_everything
    setup_page_vars
    setup_auth_structures
    setup_authorize_hash
    authorize
  end

#   def setup_page_vars
#     # do nothing -- controller overrides
#   end

#   def setup_authorize_hash
#     # do nothing -- controller overrides
#   end

#   def check_authorization(user)
#     #do nothing -- controller overrides
#   end

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
          #@authinfo[:sid] = @sid
        else
          #no session
          @authinfo = Hash.new
        end

      rescue ActiveRecord::RecordNotFound
        #means we don't have a live session,
        @authinfo = Hash.new
      end
    elsif session.user
      @authinfo = Hash.new
      @authinfo[:user] = session.user
    end
    @authinfo[:user] ||= User.find(-1)
  end

  def authorize
    Merb.logger.debug("QQQ12: #{request._session_secret_key }")
    if check_authorization(@authinfo[:user])
      Merb.logger.debug("QQQ2: #{ @authinfo[:user].id } is authorized for #{action_name}")
      true
    else
      Merb.logger.debug("QQQ2: #{ @authinfo[:user].id } is NOT authorized for #{action_name}")
      admonish("You are not authorized for this action!")
    end

  end

  def admonish(msg)
    message[:notice] = msg
    #    Merb.logger.debug("Request is #{request.inspect}")
    destination = request.referer
    destination ||= "http://" + StoryHost("playground") + "/"
    redirect destination
    throw :halt
  end

  def expire(key)
    Merb::Cache[:default].delete(key)
  end

  def cache(key, opts = {}, conditions = {}, &block)
    opts[:cache_key] = key
    fetch_fragment opts, conditions, &block
  end

end
