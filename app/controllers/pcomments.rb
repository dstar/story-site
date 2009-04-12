class Pcomments < Application

  before :setup_everything

  def setup_authorize_hash
    if ! @paragraph
      @paragraph = @pcomment.paragraph
    end
    @story_id = @paragraph.chapter.story.id
    @authorization = Pcomment.default_permissions
  end

  def check_authorization(user)
    needed = @authorization[action_name]
    if needed
      needed.each do |req|
        return true if req == "EVERYONE" # check for public action
        return true if user.has_story_permission(@paragraph.chapter.story,req) # Else check that we have the required permission
      end
    end
    return false
  end

  def setup_page_vars
    if params[:id]

      @pcomment = Pcomment.find(params[:id])

#      Merb::logger.debug("QQQ: [#{action_name}] params[:id] is #{params[:id]}")
#      Merb::logger.debug("QQQ: [#{action_name}] @pcomment is #{@pcomment.inspect}")
#     Merb::logger.debug("QQQ: [#{action_name}] @pcomment.paragraph is #{@pcomment.paragraph.inspect}")

      author_link =  %Q|<a href="/users/show/#{@pcomment.paragraph.chapter.story.authors.first.id}">#{@pcomment.paragraph.chapter.story.authors.first.username}</a>|
      story_link = %Q|<a href="/stories/show/#{@pcomment.paragraph.chapter.story.id}">#{@pcomment.paragraph.chapter.story.title}</a>|
      chapter_link =   %Q|<a href="/chapters/show/#{@pcomment.paragraph.chapter.id}">Chapter #{@pcomment.paragraph.chapter.number}</a>|
    else
      if params[:paragraph_id]
        @paragraph = Paragraph.find(params[:paragraph_id])
      else
        @paragraph = Paragraph.find(params[:pcomment]['paragraph_id'])
      end

      home_link = %Q{<a href="http://#{request.host}/">Home</a>}
      author_link =  %Q|<a href="/users/show/#{@paragraph.chapter.story.authors.first.id}">#{@paragraph.chapter.story.authors.first.username}</a>|
      story_link = %Q|<a href="/stories/show/#{@paragraph.chapter.story.id}">#{@paragraph.chapter.story.title}</a>|
      chapter_link =   %Q|<a href="/chapters/show/#{@paragraph.chapter.id}">Chapter #{@paragraph.chapter.number}</a>|
    end

    @breadcrumbs = "#{home_link}"
    @breadcrumbs += " > #{author_link }"
    @breadcrumbs += " > #{story_link }"
    @breadcrumbs += " > #{chapter_link }"

    @page_title = 'Pcomments: #{action_name}'
    @breadcrumbs += " > Pcomments: #{action_name}"
  end

  def move_next
    comment = Pcomment.find(params[:id])
    comment.move('next')
    redirect "/chapters/show_draft/#{comment.paragraph.chapter.id}#pcomment#{comment.paragraph.id}"
  end

  def move_prev
    comment = Pcomment.find(params[:id])
    comment.move('prev')
    redirect "/chapters/show_draft/#{comment.paragraph.chapter.id}#pcomment#{comment.paragraph.id}"
  end

  def new
    @pcomment = Pcomment.new
    @pcomment.paragraph_id = params["paragraph_id"]
    if request.xml_http_request?
      @chapter = @paragraph.chapter
      partial 'new_comment'
    end
    render :new
  end

  def create
    @pcomment = Pcomment.new(params[:pcomment])
    @pcomment.username = @authinfo[:user].username
    if request.xml_http_request?
      if @pcomment.save
        @chapter = @paragraph.chapter
        partial 'chapters/comment_block', :controller => "chapter", :para => @pcomment.paragraph, :display_style => "block"
      else
        partial 'new_comment'
      end
    else
      if @pcomment.save
        redirect "/chapters/show_draft/#{@pcomment.paragraph.chapter.id}#pcomment#{@pcomment.paragraph.id}", :message => {:notice => 'Paragraph comment was successfully created.' }
      else
        render :new
      end
    end
  end

  def edit
    @pcomment = Pcomment.find(params[:id])
    render :edit
  end

  def update
    @pcomment = Pcomment.find(params[:id])
    if @pcomment.update_attributes(params[:pcomment])
      redirect "/chapters/show_draft/#{@pcomment.paragraph.chapter.id}#pcomment#{@pcomment.paragraph.id}", :message => {:notice => 'Pcomment was successfully updated.' }
    else
      render :edit
    end
  end

  def destroy
    if @authinfo[:user]
      @pcomment = Pcomment.find(params[:id])
      chapter_id = Pcomment.chapterID(@pcomment.id)
      paragraph_id = @pcomment.paragraph.id
      @pcomment.destroy
      expire("chapters#show#pcomment_#{@pcomment.id}")
      if request.xml_http_request?
        @chapter = @paragraph.chapter
        partial 'chapters/comment_block', :controller => "chapter",:para => @pcomment.paragraph, :display_style => "block"
      else
        redirect "/chapters/show_draft/#{chapter_id}#pcomment#{paragraph_id}"
      end
    end
  end

  def markread
    if @authinfo[:user]
      @pcomment = Pcomment.find(params[:id])
      @chapter_id = Pcomment.chapterID(@pcomment.id)
      #      @pcomment.update_attribute('flag',1)
      @pcomment.readers << @authinfo[:user] unless @pcomment.readers.include?(@authinfo[:user])
      @pcomment.save
      expire("show_pcomment_#{@pcomment.id}")
      if request.xml_http_request?
        @chapter = @paragraph.chapter
        partial 'chapters/comment_block', :controller => "chapter",:para => @pcomment.paragraph, :display_style => "block"
      else
        redirect "/chapters/show_draft/#{@chapter_id}#pcomment#{@pcomment.paragraph.id}"
      end
    end
  end

  def markunread
    if @authinfo[:user]
      @pcomment = Pcomment.find(params[:id])
      @chapter_id = Pcomment.chapterID(@pcomment.id)
      #      @pcomment.update_attribute('flag',1)
      @pcomment.readers.delete(@authinfo[:user])
      @pcomment.save
      expire("show_pcomment_#{@pcomment.id}")
      if request.xml_http_request?
        @chapter = @paragraph.chapter
        partial 'chapters/comment_block', :controller => "chapter",:para => @pcomment.paragraph, :display_style => "block"
      else
        redirect "/chapters/show_draft/#{@chapter_id}#pcomment#{@pcomment.paragraph.id}"
      end
    end
  end

  def acknowledge
    if @authinfo[:user]
      @pcomment = Pcomment.find(params[:id])
      @chapter_id = Pcomment.chapterID(@pcomment.id)
      @pcomment.acknowledged = @authinfo[:user].username
      @pcomment.readers.push(@authinfo[:user])
      @pcomment.save
      expire("show_pcomment_#{@pcomment.id}")
      if request.xml_http_request?
        @chapter = @paragraph.chapter
        partial 'chapters/comment_block', :controller => "chapter",:para => @pcomment.paragraph, :display_style => "block"
      else
        redirect "/chapters/show_draft/#{@chapter_id}#pcomment#{@pcomment.paragraph.id}"
      end
    end
  end

  def unacknowledge
    if @authinfo[:user]
      @pcomment = Pcomment.find(params[:id])
      @chapter_id = Pcomment.chapterID(@pcomment.id)
      @pcomment.acknowledged = nil
      @pcomment.readers.delete(@authinfo[:user])
      @pcomment.save
      expire("show_pcomment_#{@pcomment.id}")
      if request.xml_http_request?
        @chapter = @paragraph.chapter
        partial 'chapters/comment_block', :controller => "chapter",:para => @pcomment.paragraph, :display_style => "block"
      else
        redirect "/chapters/show_draft/#{@chapter_id}#pcomment#{@pcomment.paragraph.id}"
      end
    end
  end


end
