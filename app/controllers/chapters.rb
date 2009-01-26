class Chapters < Application

  before :setup_everything
  
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
    Merb.logger.debug "QQQ13: request input is #{request.env.inspect}"
    Merb.logger.debug "QQQ13: cookies are #{cookies.inspect}"
    return false unless @chapter
    needed = @authorization[@chapter.status][action_name] unless (needed and ! needed.empty?)
    Merb.logger.debug "QQQ14: needed is #{needed.inspect}"
    if needed
      needed.each do |req|
        return true if req == "EVERYONE" # check for public action
        return true if user.has_story_permission(@chapter.story, req) # Else check that we have the required permission
      end
    end
    return false
  end

  def show
    provides :text

    Merb.logger.debug "QQQ8: content_type is #{content_type}"

    case content_type
    when :text
      filename = "#{Merb.root}/text_files/#{params[:short_title]}/#{params[:short_title]}#{@chapter.number}.txt"
      raise NotFound unless File.exists? filename
      @file = File.read(filename)
    end
    render :show
  end

  def show_draft
#    @chapter = Chapter.find(params[:id], :include => [{:paragraphs => :pcomments}], :order => "position")
    @chapter = Chapter.find(params[:id], :include => [{:paragraphs => :pcomments}])
    render :show_draft
  end

  def setup_page_vars

    if params[:id]

      @chapter = Chapter.find(params[:id])
      if action_name =~ /list/
        @page_title = 'Chapter List'
      else
        @page_title = @chapter.story.title
      end
    else

      if params[:chapter].is_a? String
        chapter = Chapter.find_by_file(params[:chapter] + ".html")
        if chapter
          params[:id] = chapter.id
        else
          raise NotFound
        end
      end
    end
  Merb.logger.debug "QQQ14: Setting up variables"
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
            raise NotFound
          end
        elsif params[:chapter].is_a? Hash and params[:chapter][:story_id]
          @story_id = params[:chapter][:story_id]
        else
          raise NotFound
        end
      else
        raise NotFound
      end
    end

    if action_name == 'new'
      if params[:story_id]
        @story_id = Story.find(params[:story_id]).id
        @story_id = @story_id.to_i if @story_id.is_a? String
      else
        raise NotFound
      end
    end
  end


end
