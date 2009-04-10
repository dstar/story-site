class Paragraphs < Application

  before :setup_everything

  def setup_authorize_hash
    @authorization = {
      "destroy" => [ "author",  ],
      "confirm_delete" => [ "author",  ],
      "update"  => [ "author",  ],
      "edit"    => [ "author",  ],
      "create"  => [ "author",  ],
      "new"     => [ "author",  ],
      "move_comments_prev"   => ["author",],
      "move_comments_next" => ["author",],
    }
  end

  def check_authorization(user)
    needed = @authorization[action_name]
    story = Chapter.find(@chapter_id).story
    if needed
      needed.each do |req|
        return true if req == "EVERYONE" # check for public action
        return true if user.has_story_permission(story,req) # Else check that we have the required permission
      end
    end
    return false
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

  def edit
    @paragraphs = Paragraph.find(params[:id])
    if request.xml_http_request?
      @editbody = @paragraphs.body_raw
      partial 'paraedit'
    end
    render :edit
  end

  def update
    @paragraph = Paragraph.find(params[:id])

    saved_successfully = true
    need_page_reload = false

    begin
      @paragraph.transaction do
        paras = params[:paragraph][:body_raw].gsub(/\r/,"").split(/^\s*$/).collect {|p| p.gsub(/^\r?\n/,"")}

        @paragraph.body_raw = paras.shift
        @paragraph.save!

        insert_at = @paragraph.position + 1

        paras.each do |body|
          para = Paragraph.new(:chapter_id => @paragraph.chapter_id, :body_raw => body);
          para.save
          para.insert_at(insert_at)
          para.save
          insert_at += 1
          need_page_reload = true
        end
      end
    rescue ActiveRecord::RecordNotSaved
      saved_successfully = false
    end

    if saved_successfully

      word_count = 0

      @paragraph.chapter.paragraphs.each { |p| word_count += p.body_raw.scan(/\w+/).length }
      @paragraph.chapter.update_attribute("words",word_count)
      @paragraph.chapter.dump_to_file

      # need to expire the cache for the full chapter page as well as the cache
      # for the paragraph.


      if request.xml_http_request? and not need_page_reload
        partial 'chapters/parabody', :parabody => @paragraph
      else
        redirect "/chapters/show_draft/#{@paragraph.chapter.id}#pcomment#{@paragraph.id}", :message => {:notice => 'Paragraph was successfully updated.' }
      end
    else
      if request.xml_http_request?
        @paragraph = Paragraph.find(params[:id])
        @editbody = params[:paragraphs]['body_raw']
        render :paraedit
      else
        render :edit
      end
    end
  end

  def confirm_delete
    if request.xml_http_request?
      partial :confirm_delete
    end
    render :confirm_delete
  end

  def destroy
    paragraph = Paragraph.find(params[:id])
    next_paragraph = paragraph.lower_item

    paragraph.destroy

    next_paragraph.chapter.dump_to_file

    redirect "/chapters/show_draft/#{next_paragraph.chapter.id}#pcomment#{next_paragraph.id}"
  end

  def move_comments_next
    paragraph = Paragraph.find(params[:id])
    paragraph.move_comments('next')
    redirect "/chapters/show_draft/#{paragraph.chapter.id}#pcomment#{paragraph.id}"
  end

  def move_comments_prev
    paragraph = Paragraph.find(params[:id])
    paragraph.move_comments('prev')
    redirect "/chapters/show_draft/#{paragraph.chapter.id}#pcomment#{paragraph.id}"
  end

end
