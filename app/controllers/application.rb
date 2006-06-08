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
    unless controller_name == "style" and params[:action] == "show"
      cookies[:login_redirect_to] = { :value => url_for, :domain => "pele.cx" }
    end
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
    if @authinfo[:user_id]
      user = User.find(@authinfo[:user_id])
    else
      user = User.find(-1)
    end

    is_permitted = false
    
    if @authorization[params[:action]]
      @authorization[params[:action]].each do |perm_tuple|
        is_permitted = perm_tuple['permission_type'].constantize.has_permission(user, perm_tuple)
      end
    else
      is_permitted = true
    end

#    breakpoint "testauth"

    if is_permitted
      true
    else
      admonish("You are not authorized for this action!")
    end

  end
  
  def admonish(message)
    flash[:notice] = message
    redirect_to :back
    false
  end

  def dump_to_file(chapter)
    @chapter_to_save = chapter
    text = render_to_string :template => 'chapters/dump', :layout => false
    out = File.new("#{RAILS_ROOT}/text_files/#{chapter.story.file_prefix}/#{chapter.story.file_prefix}#{chapter.number}.txt",File::CREAT|File::TRUNC|File::RDWR, 0644)
    out.write(text)
    out.close
  end

  def release_chapter(chapter)
    story = chapter.story
    filename = "#{RAILS_ROOT}/text_files/#{story.file_prefix}/#{story.file_prefix}#{chapter.number}.txt"
    title = story.title
    keywords = story.keywords
    number = "#{chapter.number}"
    succeeded = system("/home/dstar/projects/playground_utils/queue.pl", "/home/dstar/bin/#{story.file_prefix}_sendchaptercli_test.sh", title, number, keywords, "chapters/.disclaimer", filename, "chapters/.blurb")
    if succeeded
      logger.debug "Queued queue #{title} chapter #{number} for ASSM."
      else
      logger.error "Failed to queue #{title} chapter #{number} for ASSM: #{$?}"
    end
  end

end
