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
    c.story = Story.find_by_short_title(c.request.subdomains(0).first) unless c.story
  end

  def setup_auth_structures
    @sdwtest = "testing"
    #We use @session[:key] to pass around the php session_id
    @sid = cookies[:phpbb2mysql_sid]
    unless controller_name == "style" and params[:action] == "show"
      cookies[:login_redirect_to] = { :value => request.url, :domain => "pele.cx" }
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
  end

  def authenticate
    if @authinfo[:user]
      user = @authinfo[:user]
    else
      user = User.find(-1)
    end

    if check_authorization(user)
      true
    else
      admonish("You are not authorized for this action!")
    end

  end
  
  def admonish(message)
    flash[:notice] = message
    request.env["HTTP_REFERER"] = index_url(:host => StoryHost('playground')) unless request.env["HTTP_REFERER"]
    redirect_to :back
    false
  end

  def dump_to_file(chapter)
    @chapter_to_save = chapter
    text = render_to_string :template => 'chapters/dump', :layout => false
    dirname = "#{RAILS_ROOT}/text_files/#{chapter.story.file_prefix}"
    Dir.mkdir(dirname) unless File.exist?(dirname)
    out = File.new("#{dirname}/#{chapter.story.file_prefix}#{chapter.number}.txt",File::CREAT|File::TRUNC|File::RDWR, 0644)
    out.write(text)
    out.close
  end

  def StoryHost(story_id)
    domain_length = request.subdomains.length
    unless story_id == "playground"
      Story.find(story_id).short_title.concat('.').concat(request.domain(domain_length)).concat(request.port_string)
    else
      story_id.concat('.').concat(request.domain(domain_length)).concat(request.port_string)
    end
  end

end
