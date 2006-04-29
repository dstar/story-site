class ParagraphsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @paragraphs = Paragraph.find_all
  end

  def show
    @paragraphs = Paragraph.find(params[:id])
  end

  def new
    @paragraphs = Paragraph.new
    @paragraphs.chapter_id = Chapter.find(params["chapter_id"]).id
    @paragraphs.order = 1+ Paragraph.maxPara(@paragraphs.chapter_id)
    @story = Story.find(Chapter.find(@paragraphs.chapter_id).story_id)
  end

  def tempcreate
    @paracollect = []
    @paragraphs = Paragraph.new(params[:paragraphs])
    @body = @paragraphs.body.split("\r\n\r\n")
    for i in 0...@body.length
      @para = Paragraph.new(params[:paragraphs])
      @para.order = @para.order + i
      @para.body = @body[i]
      @paracollect.push(@para)
    end
  end

  def create
    @paragraphs = Paragraph.new(params[:paragraphs])
    @paracollect = []
    saved = 0
    body = @paragraphs.body.split("\r\n\r\n")
    for i in 0...body.length
      para = Paragraph.new(params[:paragraphs])
      para.order = para.order + i
      para.body = body[i]
      @paracollect.push(para)
      if para.save
        saved = saved + 1
        flash[:notice] = "#{saved} paragraph(s) successfully created."
      else
        render :action => 'new', :chapter_id => @paragraphs.chapter_id
      end
    end
    redirect_to :action => 'list'
  end

  def edit
    @paragraphs = Paragraph.find(params[:id])
  end

  def update
    @paragraphs = Paragraph.find(params[:id])
    if @paragraphs.update_attributes(params[:paragraphs])
      flash[:notice] = 'Paragraph was successfully updated.'
      redirect_to :controller => 'chapters', :action => 'showByFile', :chapter => @paragraphs.chapter
    else
      render :action => 'edit'
    end
  end

  def destroy
    Paragraph.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
