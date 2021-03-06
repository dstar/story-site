class ChaptersController < ApplicationController

  def setup_authorize_hash
    if params[:id] and ! @story_id
      @story_id = Chapter.find(params[:id]).story.id
    end
    if params[:id] and ! @chapter
      @chapter = Chapter.find(params[:id])
    end

    @authorization = Chapter.default_permissions
  end

  def check_authorization(user)
    return false unless @chapter
    needed = @authorization[@chapter.status][params[:action]] unless (needed and ! needed.empty?)
    if needed
      needed.each do |req|
        return true if req == "EVERYONE" # check for public action
        return true if user.has_story_permission(@chapter.story, req) # Else check that we have the required permission
      end
    end
    return false
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
    :redirect_to => { :action => :list }

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

  def show_draft
    @chapter = Chapter.find(params[:id], :include => [{:paragraphs => :pcomments}], :order => "position")
  end

  def dumpByFile
    ch = params[:chapter] + ".txt"
    @chapter = Chapter.find_by_file(ch)
    @headers["Content-Type"] = "text/plain"
    @chapter_to_save = @chapter
    render :template => 'chapters/dump', :layout => false
  end

  def showByName
    story = Story.find_by_short_title(params[:story])
    @chapter = Chapter.find_by_number(params[:chapter], :conditions => ["story_id = ?", story.id])
    render :action => 'show'
  end

   def edit
    @chapter = Chapter.find(params[:id])
  end

  def update
    @chapter = Chapter.find(params[:id])

    if params[:file]
      unless params[:file].size <= 0
        Paragraph.delete_all ["chapter_id = ?", @chapter.id]
        process_file(params[:file],@chapter.id)
      end
    end

    oldstatus = @chapter.status
    c=params[:chapter]
    @chapter.status = c[:status] if c[:status]
    @chapter.release_on = params[:release_on] if params[:release_on]
    logger.error "set release_on to #{params[:release_on]}: #{@chapter.release_on}"
    if @chapter.save
      flash[:notice] = 'Chapter was successfully updated.'
      expire_fragment( :action => "show", :action_suffix => "chapter_#{@chapter.id}", :controller => "chapters")
      expire_fragment("story_list#{@chapter.story.id}true" )
      expire_fragment("story_list#{@chapter.story.id}false" )
      CACHE.set("storylist_last_updated", Date.today)
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
    file_string.gsub!(/\r/,'')
    lines = file_string.split(/\n\n/)
    lines.each { |line|
      line.gsub!(/^\n/,' ')
      line.gsub!(/(\w)\n(\w)/,'\1 \2')
      line.gsub!(/\n/,' ')
      line.gsub!(/^\s*|\s*$/,'')
      line.gsub!(/#/,'***') if line == "#"
      line.gsub!(/\s+--/, "--")
      word_count += line.scan(/\w+/).length

      para = Paragraph.new()
      para.body_raw = line
      para.position = para_count
      para.chapter_id = chapter_id

      para.save

      para_count += 1
    }

    @chapter.words = word_count
    @chapter.save
    dump_to_file(@chapter)
  end

  def setup_page_vars

    if params[:id]

      @chapter = Chapter.find(params[:id])
      if params[:action] =~ /list/
        @page_title = 'Chapter List'
      else
        @page_title = @chapter.story.title
      end

    end

  end

  def handle_url
    #    breakpoint "test"
    unless params[:id] or params[:action] == 'index' or params[:action] == 'list' or params[:action] == 'new'
      if params[:chapter] and ! params[:chapter].blank?
        if params[:chapter].is_a? String
          chapter = Chapter.find_by_file(params[:chapter] + ".html")
          if chapter
            params[:id] = chapter.id
          else
            render :status => 404, :file => "#{RAILS_ROOT}/public/404.html"
            false
          end
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
        @story_id = Story.find(params[:story_id]).id
        @story_id = @story_id.to_i if @story_id.is_a? String
      else
        render :status => 404, :file => "#{RAILS_ROOT}/public/404.html"
        false
      end
    end
  end
end
