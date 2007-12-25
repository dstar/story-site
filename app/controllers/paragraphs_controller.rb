class ParagraphsController < ApplicationController

  cache_sweeper :paragraph_sweeper, :only => [:create, :update, :destroy]

  def setup_authorize_hash
    @authorization = {
      "destroy" => [ "author",  ],
      "confirm_delete" => [ "author",  ],
      "update"  => [ "author",  ],
      "edit"    => [ "author",  ],
      "create"  => [ "author",  ],
      "new"     => [ "author",  ],
    }
  end

  def check_authorization(user)
    needed = @authorization[params[:action]]
    story = Chapter.find(params["chapter_id"]).story
    if needed
      needed.each do |req|
        return true if req == "EVERYONE" # check for public action
        return true if user.has_story_permission(story,req) # Else check that we have the required permission
      end
    end
    return false
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
    @paragraphs.body_raw.gsub!(/\r/,'')
    body = @paragraphs.body_raw.split("\n\n")

    for i in 0...body.length
      para = Paragraph.new(params[:paragraphs])
      para.position = para.position + i
      para.body_raw = body[i]
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
      @editbody = @paragraphs.body_raw
      render :partial => 'paraedit'
    end
  end

  def update
    @paragraph = Paragraph.find(params[:id])
    @orig = @paragraph

    saved_successfully = true

    need_page_reload = false

    begin
      @paragraph.transaction do
        paras = params[:paragraphs][:body_raw].gsub(/\r/,"").split(/^\s*$/).collect {|p| p.gsub(/^\r?\n/,"")}

        @paragraph.body_raw = paras.shift
        @paragraph.save!

        insert_at = @paragraph.position + 1

        paras.each do |body| 
          para = Paragraph.new(:chapter_id => @paragraph.chapter_id, :body_raw => body);
          para.save
          para.insert_at(insert_at)
          insert_at += 1
          need_page_reload = true
        end
      end
    rescue ActiveRecord::RecordNotSaved
      saved_successfully = false
    end

    if request.xml_http_request? and not need_page_reload
      if saved_successfully

        word_count = 0
        @paragraph.chapter.paragraphs.each { |p| word_count += p.body_raw.scan(/\w+/).length }
        @paragraph.chapter.update_attribute("words",word_count)

        dump_to_file(@paragraph.chapter)

        expire_fragment( :action => "show", :action_suffix => "paragraph_#{@paragraph.id}", :controller => "chapters")
        render :partial => 'chapters/parabody', :locals => { :parabody => @paragraph }

      else
        @paragraph = Paragraph.find(params[:id])
        @editbody = params[:paragraphs]['body_raw']
        render :action => 'paraedit'
      end
    else
      if saved_successfully
        flash[:notice] = 'Paragraph was successfully updated.'
        word_count = 0
        @paragraph.chapter.paragraphs.each { |p| word_count += p.body_raw.scan(/\w+/).length }
        @paragraph.chapter.update_attribute("words",word_count)
        dump_to_file(@paragraph.chapter)
        expire_fragment( :action => "show", :action_suffix => "paragraph_#{@paragraph.id}", :controller => "chapters" )
        redirect_to :controller => 'chapters', :action => 'show_draft', :id => @paragraph.chapter.id, :anchor => "p#{@paragraph.id}"
      else
        render :action => 'edit'
      end
    end
  end

  def confirm_delete
    if request.xml_http_request?
      render :partial => 'confirm_delete'
    end
  end


  def destroy
    paragraph = Paragraph.find(params[:id])
    next_paragraph = paragraph.lower_item

    expire_fragment( :action => "show", :action_suffix => "paragraph_#{paragraph.id}", :controller => "chapters")
    paragraph.destroy

    dump_to_file(next_paragraph.chapter)

    redirect_to :controller => 'chapters', :action => 'show_draft', :id => next_paragraph.chapter.id, :anchor => "p#{next_paragraph.id}"
  end

  def setup_page_vars
    if params[:id] 
      @paragraph = Paragraph.find(params[:id])
      @chapter_id = @paragraph.chapter.id
      @story_id = @paragraph.chapter.story.id
    elsif params["chapter_id"] or params[:paragraphs]
      @chapter_id = params["chapter_id"] if params["chapter_id"]
      @chapter_id = params[:paragraphs]['chapter_id'] if params[:paragraphs] and params[:paragraphs]['chapter_id']
      @story_id = Chapter.find(@chapter_id).story.id
    end
  end
end
