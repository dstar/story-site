class ParagraphsController < ApplicationController

  def setup_authorize_hash
    @authorization = {
      "destroy" => [ { 'permission_type'=>"StoryPermission", 'permission'=>"author", 'id'=> @story_id } ],
      "update"  => [ { 'permission_type'=>"StoryPermission", 'permission'=>"author", 'id'=> @story_id } ],
      "edit"    => [ { 'permission_type'=>"StoryPermission", 'permission'=>"author", 'id'=> @story_id } ],
      "create"  => [ { 'permission_type'=>"StoryPermission", 'permission'=>"author", 'id'=> @story_id } ],
      "new"     => [ { 'permission_type'=>"StoryPermission", 'permission'=>"author", 'id'=> @story_id } ],
    }
  end


  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def new
    @paragraphs = Paragraph.new
    @paragraphs.chapter_id = Chapter.find(params["chapter_id"]).id
    @paragraphs.position = 1+ Paragraph.maxPara(@paragraphs.chapter_id)
    @story = Story.find(Chapter.find(@paragraphs.chapter_id).story_id)
  end

  def create
    @paragraphs = Paragraph.new(params[:paragraphs])
    @paracollect = []
    saved = 0
    @paragraphs.body.gsub!(/\r/,'')
    body = @paragraphs.body.split("\n\n")

    for i in 0...body.length
      para = Paragraph.new(params[:paragraphs])
      para.position = para.position + i
      para.body = body[i]
      @paracollect.push(para)
      if para.save
        saved = saved + 1
        flash[:notice] = "#{saved} paragraph(s) successfully created."
      else
        render :action => 'new', :chapter_id => @paragraphs.chapter_id
      end
    end
    dump_to_file(@paragraphs.chapter)
    redirect_to :action => 'list'
  end

  def edit
    @paragraphs = Paragraph.find(params[:id])
    if request.xml_http_request?
      @editbody = @paragraphs.body
      render :partial => 'paraedit'
    end
  end

  def update
    @paragraph = Paragraph.find(params[:id])
    @orig = @paragraph
    if request.xml_http_request?
      if @paragraph.update_attributes(params[:paragraphs])
        dump_to_file(@paragraph.chapter)
        expire_fragment(:controller => "chapters", :action => "show", :action_suffix => "paragraph_#{@paragraph.id}")
        render :partial => 'parabody'
      else
        @paragraph = Paragraph.find(params[:id])
        @editbody = params[:paragraphs]['body']
        render :action => 'paraedit'
      end
    else
      if @paragraph.update_attributes(params[:paragraphs])
        flash[:notice] = 'Paragraph was successfully updated.'
        word_count = 0
        @paragraph.chapter.paragraphs.each { |p| word_count += p.body.scan(/\w+/).length }
        @paragraph.chapter.update_attribute("words",word_count)
        dump_to_file(@paragraph.chapter)
        logger.info "expiring...\n"
        expire_fragment({:controller => "chapters", :action => "show", :action_suffix => "paragraph_#{@paragraph.id}"})
        redirect_to :controller => 'chapters', :action => 'showByFile', :chapter => @paragraph.chapter
      else
        render :action => 'edit'
      end
    end
  end

  def destroy
    Paragraph.find(params[:id]).destroy
        dump_to_file(@paragraph.chapter)
        expire_fragment(:controller => "chapters", :action => "show", :action_suffix => "paragraph_#{@paragraph.id}")
    redirect_to :action => 'list'
  end

  def setup_page_vars
    if params[:id] 
      @chapter_id = Paragraph.find(params[:id]).chapter.id
      @story_id = Paragraph.find(params[:id]).chapter.story.id
    elsif params["chapter_id"] or params[:paragraphs]
      @chapter_id = params["chapter_id"] if params["chapter_id"]
      @chapter_id = params[:paragraphs]['chapter_id'] if params[:paragraphs] and params[:paragraphs]['chapter_id']
      @story_id = Chapter.find(@chapter_id).story.id
    end
  end
end
