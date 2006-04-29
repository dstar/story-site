class PhpSessionController < ActionController::Base
#  uses_component_template_root

  def has_session()
    #We use @session[:key] to pass around the php session_id
    @sid = cookies[:phpbb2mysql_sid]
    cookies[:login_redirect_to] = url_for
    if @sid
      begin
        @php_session = Php_Session.find_by_session_id(@sid)
        if @php_session then
          @php_user_id = @php_session.session_user_id
          @php_username = User.find(@php_user_id).username
          #at this point, we've verified that the session is still live
          session[:sid] = @sid 
          session[:user_id] = @php_user_id
          session[:username] = @php_username

          session[:group_ids]=User_Group.find(:all, :conditions => ["user_id = ?", @php_user_id]).collect {|g| g.group_id}
          session[:groups]=session[:group_ids].collect { |g| Group.find(g).group_name }

        else
          @php_username = nil
          reset_session          
        end

      rescue ActiveRecord::RecordNotFound
        #means we don't have a live session,
        @php_username = nil
        reset_session
      end
    else
      @php_username = nil
      reset_session
    end
  end


end
