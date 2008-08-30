class Chapters < Application

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
    needed = @authorization[@chapter.status][action_name] unless (needed and ! needed.empty?)
    if needed
      needed.each do |req|
        return true if req == "EVERYONE" # check for public action
        return true if user.has_story_permission(@chapter.story, req) # Else check that we have the required permission
      end
    end
    return false
  end

  def show
    @chapter = Chapter.find(params[:id])
    render 'show'
  end

  def show_draft
    @chapter = Chapter.find(params[:id], :include => [{:paragraphs => :pcomments}], :order => "position")
    render 'show_draft'
  end

  def setup_page_vars

    if params[:id]

      @chapter = Chapter.find(params[:id])
      if action_name =~ /list/
        @page_title = 'Chapter List'
      else
        @page_title = @chapter.story.title
      end

    end

  end

  def handle_url
    #    breakpoint "test"
    unless params[:id] or action_name == 'index' or action_name == 'list' or action_name == 'new'
      if params[:chapter] and ! params[:chapter].blank?
        if params[:chapter].is_a? String
          chapter = Chapter.find_by_file(params[:chapter] + ".html")
          if chapter
            params[:id] = chapter.id
          else
            render :status => 404, :file => "#{Merb.root}/public/404.html"
            false
          end
        elsif params[:chapter].is_a? Hash and params[:chapter][:story_id]
          @story_id = params[:chapter][:story_id]
        else
          render :status => 404, :file => "#{Merb.root}/public/404.html"
          false
        end
      else
        render :status => 404, :file => "#{Merb.root}/public/404.html"
        false
      end
    end

    if action_name == 'new'
      if params[:story_id]
        @story_id = Story.find(params[:story_id]).id
        @story_id = @story_id.to_i if @story_id.is_a? String
      else
        render :status => 404, :file => "#{Merb.root}/public/404.html"
        false
      end
    end
  end


end