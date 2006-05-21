class ChaptersController < ApplicationController

  def setup_authorize_hash
    if params[:id] and ! @story_id
      @story_id = Chapter.find(params[:id]).story.id
    end
    @authorization = {
      "destroy" => proc { if @authinfo[:user_id] then  user = User.find_by_user_id(@authinfo[:user_id])
            user.has_story_permission(@story_id,"author") ? true :  admonish("You are not authorized for this action!") else admonish("You are not authorized for this action!") end },
      "update"  => proc { if @authinfo[:user_id] then  user = User.find_by_user_id(@authinfo[:user_id])
              user.has_story_permission(@story_id,"author") ? true :  admonish("You are not authorized for this action!") else admonish("You are not authorized for this action!") end },
      "edit"    => proc { if @authinfo[:user_id] then  user = User.find_by_user_id(@authinfo[:user_id])
                user.has_story_permission(@story_id,"author") ? true :  admonish("You are not authorized for this action!") else admonish("You are not authorized for this action!") end },
      "create"  => proc { if @authinfo[:user_id] then  user = User.find_by_user_id(@authinfo[:user_id])
                  user.has_story_permission(@story_id,"author") ? true :  admonish("You are not authorized for this action!") else admonish("You are not authorized for this action!") end },
      "new"     => proc {if @authinfo[:user_id] then  user = User.find_by_user_id(@authinfo[:user_id])
                    user.has_story_permission(@story_id,"author") ? true :  admonish("You are not authorized for this action!") else admonish("You are not authorized for this action!") end },
      "show"    => proc { true },
      "list"    => proc { true },
      "archive" => proc { true },
      "index"   => proc { true }
    }
  end


  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @chapters = Chapter.orderedList
  end

  def listdump
    @chapters = Chapter.orderedListByDate
  end

  def dump
    @chapter = Chapter.find(params[:id])
    @headers["Content-Type"] = "text/plain"
    render(:layout => false)
  end

  def show
    @chapter = Chapter.find(params[:id])
  end

  def showByFile
    @chapter = Chapter.find_by_file(params[:chapter])
    render :action => 'show'
  end

  def dumpByFile
    ch = params[:chapter].gsub(/txt/,"html")
    @chapter = Chapter.find_by_file(ch)
    @headers["Content-Type"] = "text/plain"
    render :template => 'chapters/dump', :layout => false
  end

  def showByName
    story = Story.find_by_short_title(params[:story])
    @chapter = Chapter.find_by_number(params[:chapter], :conditions => ["story_id = ?", story.id])
    render :action => 'show'
  end

  def new
    @story = Story.find(params["story_id"])
    @chapter = Chapter.new
    @chapter.story_id = @story.id
    @chapter.number = Chapter.count_by_sql ["Select max(number) from chapters where story_id = ?", @story.id]
    @chapter.number = @chapter.number + 1
  end

  def create
    @chapter = Chapter.new(params[:chapter])
    @chapter.date = Time.now.strftime('%Y-%m-%d %H:%M:%S') unless @chapter.date
    if @chapter.save
      process_file(params[:file],@chapter.id) unless params[:file].blank?
      flash[:notice] = 'Chapter was successfully created.'
      redirect_to :controller => 'stories', :action => 'show', :id => @chapter.story_id
    else
      render :action => 'new'
    end
  end

  def edit
    @chapter = Chapter.find(params[:id])
  end

  def update
    @chapter = Chapter.find(params[:id])

    unless params[:file].blank?
      process_file(params[:file],@chapter.id)
      Paragraph.delete_all ["chapter_id = ?", chapter.id]
    end

    c=params[:chapter]
    @chapter.status = c[:status] if c[:status]
    if @chapter.save
      flash[:notice] = 'Chapter was successfully updated.'
      redirect_to :controller => 'stories', :action => 'show', :id => @chapter.story_id
    else
      render :action => 'edit'
    end

  end

  def destroy
    Chapter.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def process_file(file, chapter_id)
    paragraph_buffer = String.new
    para_count = 1
    word_count = 0
    file_string = file.read
    lines = file_string.split(/\n\n/)
    lines.each { |line|
      line.gsub!(/^\n/,' ')
      line.gsub!(/^\s*|\s*$/,'')
      line.gsub!(/#/,'***') if line == "#"
      line.gsub(/\s+--/, "--")
      $stderr.write("line is #{line.inspect}\n")
      word_count += line.split.length

      para = Paragraph.new()
      para.body = line
      para.order = para_count
      para.chapter_id = chapter_id

      para.save

      para_count += 1
    }

    @chapter.words = word_count
    @chapter.file = file.original_filename
    @chapter.save
    end

  def setup_page_vars

    if params[:id]

      @chapter = Chapter.find(params[:id])

      home_link = link_to 'Home', index_url(:host => StoryHost('playground')
      universe_link =  link_to @chapter.story.universe.name, url_for( :host => StoryHost('playground'), :controller => 'universes', :action => 'show', :id => @chapter.story.universe.id)
      story_link = link_to @chapter.story.title, index_url(:host => StoryHost(@chapter.story.id))

      @breadcrumbs = "#{home_link}"
      @breadcrumbs += " &gt; #{universe_link }"
      @breadcrumbs += " &gt; #{story_link }"

      if params[:action] =~ /list/
        @page_title = 'Chapter List'
      else
        @page_title = @chapter.story.title
        @breadcrumbs += " > Chapter #{@chapter.number }"
      end

    end

  end

  def handle_url
#    breakpoint "test"
    unless params[:id] or params[:action] == 'index' or params[:action] == 'list' or params[:action] == 'new'
      if params[:chapter] and ! params[:chapter].blank?
        if params[:chapter].is_a? String
          params[:id] = Chapter.find_by_file(params[:chapter]).id unless params[:id]
        elsif params[:chapter].is_a? Hash and params[:chapter][:story_id]
          @story_id = params[:chapter][:story_id]
        else
          render :status => 404, :file => "#{RAILS_ROOT}/public/404.html"
          false
        end
      else
        render :status => 404, :file => "#{RAILS_ROOT}/public/404.html"
        false
      end
    end

    if params[:action] == 'new'
      if params[:story_id]
        @story_id = params[:story_id]
        @story_id = @story_id.to_i if @story_id.is_a? String
      else
        render :status => 404, :file => "#{RAILS_ROOT}/public/404.html"
        false
      end
    end
  end
end
