class PcommentsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @pcomment = Pcomment.find(:all, :conditions => 'flag = 0')
  end

  def show
    @pcomment = Pcomment.find(params[:id])
  end

  def new
    @pcomment = Pcomment.new
    @pcomment.paragraph_id = params["paragraph_id"]
  end

  def create
    @pcomment = Pcomment.new(params[:pcomment])
    if @pcomment.save
      flash[:notice] = 'Paragraph comment was successfully created.'
      redirect_to :controller => 'chapters', :action => 'show',
        :id => Pcomment.chapterID(@pcomment.id)
    else
      render :action => 'new'
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
      redirect_to :controller => 'chapters',
      :action => 'show', :id => bar
    end
  end
  def markread
    if @authinfo[:username]
      foo = Pcomment.find(params[:id])
      bar = Pcomment.chapterID(foo.id)
      foo.update_attribute('flag',1)
      redirect_to :controller => 'chapters',
      :action => 'show', :id => bar
    end
  end

  def setup_page_vars

    logger.debug "#{params.inspect}"

    if params[:id]

      @pcomment = Pcomment.find(params[:id])

      home_link = %Q{<a href="http://#{request.host_with_port}/">Home</a>}
      universe_link =  %Q|<a href="#{url_for  :controller => 'universes', :action => 'show', :id => @pcomment.paragraph.chapter.story.universe.id  }">#{@pcomment.paragraph.chapter.story.universe.name}</a>|
      story_link = %Q|<a href="#{url_for  :controller => 'stories', :action => 'show', :id => @pcomment.paragraph.chapter.story.id  }">#{@pcomment.paragraph.chapter.story.title}</a>|
      chapter_link =   %Q|<a href="#{url_for  :controller => 'chapters', :action => 'show', :id => @pcomment.paragraph.chapter.id  }">Chapter #{@pcomment.paragraph.chapter.number}</a>|
    else
      @paragraph = Paragraph.find(params[:paragraph_id])

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
