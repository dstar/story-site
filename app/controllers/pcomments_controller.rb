class PcommentsController < ApplicationController

  cache_sweeper :paragraph_sweeper, :only => [:create, :update, :destroy]

  def setup_authorize_hash
    if ! @paragraph
      @paragraph = @pcomment.paragraph
    end
    @story_id = @paragraph.chapter.story.id

    @authorization = {
      "destroy"       => ["author",],
      "update"        => ["author",],
      "edit"          => ["author",],
      "create"        => ["beta-reader","author",],
      "new"           => ["author","beta-reader",],
      "markread"      => ["author","beta-reader",],
      "markunread"    => ["author","beta-reader",],
      "acknowledge"   => ["author",],
      "unacknowledge" => ["author",],
      "move_next"     => ["author",],
      "move_prev"     => ["author",],
    }
  end

  def check_authorization(user)
    needed = @authorization[params[:action]]
    if needed
      needed.each do |req|
        return true if req == "EVERYONE" # check for public action
        return true if user.has_story_permission(@paragraph.chapter.story,req) # Else check that we have the required permission
      end
    end
    return false
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
    :redirect_to => { :action => :list }

  def new
    @pcomment = Pcomment.new
    @pcomment.paragraph_id = params["paragraph_id"]
    if request.xml_http_request?
      @chapter = @paragraph.chapter
      render :partial => 'new_comment'
    end
  end

  def create
    @pcomment = Pcomment.new(params[:pcomment])
    @pcomment.username = @authinfo[:user].username
    if request.xml_http_request?
      if @pcomment.save
        @chapter = @paragraph.chapter
        render :partial => 'chapters/comment_block', :controller => "chapter", :locals => {:para => @pcomment.paragraph, :display => "block"}
      else
        render :action => 'new_comment'
      end
    else
      if @pcomment.save
        flash[:notice] = 'Paragraph comment was successfully created.'
        redirect_to :controller => 'chapters', :action => 'show_draft',
          :id => Pcomment.chapterID(@pcomment.id)
      else
        render :action => 'new'
      end
    end
  end

  def edit
    @pcomment = Pcomment.find(params[:id])
  end

  def update
    @pcomment = Pcomment.find(params[:id])
    if @pcomment.update_attributes(params[:pcomment])
      flash[:notice] = 'Pcomment was successfully updated.'
      redirect_to :controller => 'chapters', :action => 'show_draft', :id => @pcomment.id
    else
      render :action => 'edit'
    end
  end

  def destroy
    if @authinfo[:user]
      @pcomment = Pcomment.find(params[:id])
      @chapter_id = Pcomment.chapterID(@pcomment.id)
      @pcomment.update_attribute('flag',2)
      expire_fragment( :action => "show", :action_suffix => "pcomment_#{@pcomment.id}", :controller => "chapters")
      if request.xml_http_request?
        @chapter = @paragraph.chapter
        render :partial => 'chapters/comment_block', :controller => "chapter", :locals => {:para => @pcomment.paragraph, :display => "block"}
      else
        redirect_to :controller => 'chapters',
          :action => 'show_draft', :id => @chapter_id
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
      expire_fragment("show_pcomment_#{@pcomment.id}")
      if request.xml_http_request?
        @chapter = @paragraph.chapter
        render :partial => 'chapters/comment_block', :controller => "chapter", :locals => {:para => @pcomment.paragraph, :display => "block"}
      else
        redirect_to :controller => 'chapters',
          :action => 'show_draft', :id => @chapter_id
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
      expire_fragment("show_pcomment_#{@pcomment.id}")
      if request.xml_http_request?
        @chapter = @paragraph.chapter
        render :partial => 'chapters/comment_block', :controller => "chapter", :locals => {:para => @pcomment.paragraph}
      else
        redirect_to :controller => 'chapters',
          :action => 'show_draft', :id => @chapter_id
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
      expire_fragment("show_pcomment_#{@pcomment.id}")
      if request.xml_http_request?
        @chapter = @paragraph.chapter
        render :partial => 'chapters/comment_block', :controller => "chapter", :locals => {:para => @pcomment.paragraph, :display => "block"}
      else
        redirect_to :controller => 'chapters', :action => 'show_draft', :id => @chapter_id
      end
    end
  end

  def unacknowledge
    if @authinfo[:user]
      @pcomment = Pcomment.find(params[:id])
      @chapter_id = Pcomment.chapterID(@pcomment.id)
      @pcomment.acknowledged = ""
      @pcomment.readers.delete(@authinfo[:user])
      @pcomment.save
      expire_fragment("show_pcomment_#{@pcomment.id}")
      if request.xml_http_request?
        @chapter = @paragraph.chapter
        render :partial => 'chapters/comment_block', :controller => "chapter", :locals => {:para => @pcomment.paragraph, :display => "block"}
      else
        redirect_to :controller => 'chapters',
          :action => 'show_draft', :id => @chapter_id
      end
    end
  end

  def setup_page_vars
    if params[:id]

      @pcomment = Pcomment.find(params[:id])

      universe_link =  %Q|<a href="#{url_for  :controller => 'universes', :action => 'show', :id => @pcomment.paragraph.chapter.story.universe.id  }">#{@pcomment.paragraph.chapter.story.universe.name}</a>|
      story_link = %Q|<a href="#{url_for  :controller => 'stories', :action => 'show', :id => @pcomment.paragraph.chapter.story.id  }">#{@pcomment.paragraph.chapter.story.title}</a>|
      chapter_link =   %Q|<a href="#{url_for  :controller => 'chapters', :action => 'show', :id => @pcomment.paragraph.chapter.id  }">Chapter #{@pcomment.paragraph.chapter.number}</a>|
    else
      if params[:paragraph_id]
        @paragraph = Paragraph.find(params[:paragraph_id])
      else
        @paragraph = Paragraph.find(params[:pcomment]['paragraph_id'])
      end

      home_link = %Q{<a href="http://#{request.host_with_port}/">Home</a>}
      universe_link =  %Q|<a href="#{url_for  :controller => 'universes', :action => 'show', :id => @paragraph.chapter.story.universe.id  }">#{@paragraph.chapter.story.universe.name}</a>|
      story_link = %Q|<a href="#{url_for  :controller => 'stories', :action => 'show', :id => @paragraph.chapter.story.id  }">#{@paragraph.chapter.story.title}</a>|
      chapter_link =   %Q|<a href="#{url_for  :controller => 'chapters', :action => 'show', :id => @paragraph.chapter.id  }">Chapter #{@paragraph.chapter.number}</a>|
    end

    @breadcrumbs = "#{home_link}"
    @breadcrumbs += " > #{universe_link }"
    @breadcrumbs += " > #{story_link }"
    @breadcrumbs += " > #{chapter_link }"

    @page_title = 'Pcomments: #{params[:action]}'
    @breadcrumbs += " > Pcomments: #{params[:action]}"
  end

  def move_next
    comment = Pcomment.find(params[:id])
    comment.move('next')
    redirect_to "#{index_url}chapters/show_draft/#{comment.paragraph.chapter.id}#pcomment#{comment.paragraph.id}"
  end

  def move_prev
    comment = Pcomment.find(params[:id])
    comment.move('prev')
    redirect_to "#{index_url}chapters/show_draft/#{comment.paragraph.chapter.id}#pcomment#{comment.paragraph.id}"
  end


end
