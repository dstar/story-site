# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  attr_writer :story
  attr_reader :story

  before_filter do |controller|
    controller.handle_url if controller.respond_to? :handle_url
  end

  before_filter :setup_page_vars

  before_filter :setup_auth_structures
  before_filter :setup_authorize_hash 
  before_filter :authenticate


  before_filter do |c|
    c.story = Story.find_by_short_title(c.request.subdomains(0).first)
  end

  def setup_auth_structures
    @sdwtest = "testing"
    #We use @session[:key] to pass around the php session_id
    @sid = cookies[:phpbb2mysql_sid]
    cookies[:login_redirect_to] = { :value => url_for, :domain => "pele.cx" }
    @authinfo = Hash.new
    if @sid
      begin
        @authinfo[:session] = Php_Session.find_by_session_id(@sid)
        if @authinfo[:session] then
          user = User.find(@authinfo[:session].session_user_id)
          @authinfo[:user_id] = user.user_id
          @authinfo[:username] = user.username
          #at this point, we've verified that the session is still live
          @authinfo[:sid] = @sid 

          groups = user.groups
          @authinfo[:group_ids]=groups.collect {|g| g.group_id}
          @authinfo[:groups]=groups.collect {|g| g.group_name}

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

  def authenticate
    $stderr.write("\n\n\nparams are #{params[:action]}\n\n\n")
    @authorization[params[:action]].call
  end
  
  def admonish(message)
    flash[:notice] = message
    redirect_to :back
    false
  end

end
