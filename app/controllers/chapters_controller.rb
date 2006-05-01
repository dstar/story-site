class ChaptersController < ApplicationController
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
    if @chapter.save
      process_file(params[:file],@chapter.id) if params[:file].size
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
    if @chapter.update_attributes(params[:chapter])
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

    logger.debug "#{params.inspect}"

    @chapter = Chapter.find_by_file(params[:chapter])

    home_link = %Q{<a href="http://#{request.host_with_port}/">Home</a>}
    universe_link =  %Q|<a href="#{url_for  :controller => 'universes', :action => 'show', :id => @chapter.story.universe.id  }">#{@chapter.story.universe.name}</a>|
    story_link = %Q|<a href="#{url_for  :controller => 'stories', :action => 'show', :id => @chapter.story.id  }">#{@chapter.story.title}</a>|

    @breadcrumbs = "#{home_link}"
    @breadcrumbs += " > #{universe_link }"
    @breadcrumbs += " > #{story_link }"

    if params[:action] =~ /list/
      @page_title = 'Chapter List'
    else
      @page_title = @chapter.story.title
      @breadcrumbs += " > Chapter #{@chapter.number }"
    end
  end

  def handle_url
      params[:id] = Chapter.find_by_file(params[:chapter]).id unless params[:id]
  end
    
end
