class PcommentsController < ApplicationController

  def setup_authorize_hash
    if ! @paragraph
      @paragraph = @pcomment.paragraph
    end
    @story_id = @paragraph.chapter.story.id

    @authorization = {
      "destroy"  => [ { 'permission_type'=>"StoryPermission", 'permission'=>"author",      'id'=> @story_id } ],
      "update"   => [ { 'permission_type'=>"StoryPermission", 'permission'=>"author",      'id'=> @story_id } ],
      "edit"     => [ { 'permission_type'=>"StoryPermission", 'permission'=>"author",      'id'=> @story_id } ],
      "create"   => [ { 'permission_type'=>"StoryPermission", 'permission'=>"beta-reader", 'id'=> @story_id },
                      { 'permission_type'=>"StoryPermission", 'permission'=>"author",      'id'=> @story_id } ],
      "new"      => [ { 'permission_type'=>"StoryPermission", 'permission'=>"author",      'id'=> @story_id },
                      { 'permission_type'=>"StoryPermission", 'permission'=>"beta-reader", 'id'=> @story_id } ],
      "markread" => [ { 'permission_type'=>"StoryPermission", 'permission'=>"author",      'id'=> @story_id } ],
    }
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def new
    @pcomment = Pcomment.new
    @pcomment.paragraph_id = params["paragraph_id"]
    if request.xml_http_request?
      render :partial => 'new_comment'
    end
  end

  def create
    @pcomment = Pcomment.new(params[:pcomment])
    @pcomment.username = @authinfo[:username]
    if request.xml_http_request?
      logger.info "QQQ: got _here_\n"
      if @pcomment.save
        logger.info "QQQ: Right Place\n"
        render :partial => 'chapters/comment_block', :controller => "chapter", :locals => {:para => @pcomment.paragraph} 
      else
        logger.info "QQQ: AAAA Wrong Place\n"
        render :action => 'new_comment'
      end
    else
      logger.info "QQQ: BBBB Wrong Place\n"
    if @pcomment.save
      flash[:notice] = 'Paragraph comment was successfully created.'
      redirect_to :controller => 'chapters', :action => 'show',
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
      redirect_to :action => 'show', :id => @pcomment
    else
      render :action => 'edit'
    end
  end

  def destroy
    if @authinfo[:username]
      foo = Pcomment.find(params[:id])
      bar = Pcomment.chapterID(foo.id)
      foo.update_attribute('flag',2)
      if request.xml_http_request?
        render :partial => 'chapters/pcomm', :collection => Pcomment.listForPara(@pcomment.paragraph_id)
      else
        redirect_to :controller => 'chapters',
        :action => 'show', :id => bar
      end
    end
  end

  def markread
    if @authinfo[:username]
      foo = Pcomment.find(params[:id])
      bar = Pcomment.chapterID(foo.id)
#      foo.update_attribute('flag',1)
      foo.read = 'yes'
      foo.save
      if request.xml_http_request?
        render :partial => 'chapters/pcomm', :collection => Pcomment.listForPara(@pcomment.paragraph_id)
      else
        redirect_to :controller => 'chapters',
        :action => 'show', :id => bar
      end
    end
  end

  def markunread
    if @authinfo[:username]
      foo = Pcomment.find(params[:id])
      bar = Pcomment.chapterID(foo.id)
#      foo.update_attribute('flag',1)
      foo.read = 'no'
      foo.save
      if request.xml_http_request?
        render :partial => 'chapters/pcomm', :collection => Pcomment.listForPara(@pcomment.paragraph_id)
      else
        redirect_to :controller => 'chapters',
        :action => 'show', :id => bar
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


end
