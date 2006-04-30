# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  attr_writer :story
  attr_reader :story

  before_filter :authenticate
  before_filter do |c|
    c.story = Story.find_by_short_title(c.request.subdomains(0).first)
  end

  def authenticate
    @sdwtest = "testing"
    #We use @session[:key] to pass around the php session_id
    @sid = cookies[:phpbb2mysql_sid]
    cookies[:login_redirect_to] = url_for
    @authinfo = Hash.new
    if @sid
      begin
        @authinfo[:session] = Php_Session.find_by_session_id(@sid)
        if @authinfo[:session] then
          @authinfo[:user_id] = @authinfo[:session].session_user_id
          @authinfo[:username] = User.find(@authinfo[:user_id]).username
          #at this point, we've verified that the session is still live
          @authinfo[:sid] = @sid 

          @authinfo[:group_ids]=User_Group.find(:all, :conditions => ["user_id = ?", @authinfo[:user_id]]).collect {|g| g.group_id}
          @authinfo[:groups]=@authinfo[:group_ids].collect { |g| Group.find(g).group_name }

          $stderr.write("yup, got here")
          $stderr.write(@authinfo.inspect)

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
  end


end
