class StoriesController < ApplicationController

  def setup_authorize_hash
    if params[:id] and ! @universe
      @universe = Story.find(params[:id]).universe
    end

    @authorization = {
      "destroy" => proc { if @authinfo[:user_id] then  user = User.find_by_user_id(@authinfo[:user_id])
            user.has_story_permission(@story.id,"author") ? true :  admonish("You are not authorized for this action!") else admonish("You are not authorized for this action!") end },
      "update"  => proc { if @authinfo[:user_id] then  user = User.find_by_user_id(@authinfo[:user_id])
              user.has_story_permission(@story.id,"author") ? true :  admonish("You are not authorized for this action!") else admonish("You are not authorized for this action!") end },
      "edit"    => proc { if @authinfo[:user_id] then  user = User.find_by_user_id(@authinfo[:user_id])
                user.has_story_permission(@story.id,"author") ? true :  admonish("You are not authorized for this action!") else admonish("You are not authorized for this action!") end },
      "create"  => proc { if @authinfo[:user_id] then  user = User.find_by_user_id(@authinfo[:user_id])
                  user.has_universe_permission(@universe.id,"owner") ? true :  admonish("You are not authorized for this action!") else admonish("You are not authorized for this action!") end },
      "new"     => proc {if @authinfo[:user_id] then  user = User.find_by_user_id(@authinfo[:user_id])
                    user.has_universe_permission(@universe.id,"owner") ? true :  admonish("You are not authorized for this action!") else admonish("You are not authorized for this action!") end },
      "show"    => proc { true },
      "list"    => proc { true },
      "showByName" => proc { true },
      "showBySubD" => proc { true },
      "index"   => proc { true }
    }
  end


  layout "stories"

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @stories = Story.OrderedList
  end

  def show
    if (request.subdomains(0).first == 'playground')
      list
      render :action => 'playground', :layout => 'playground'
    else
    @story = Story.find(params[:id])
      render :action => 'show'
    end
  end

  def showByName
    @story = Story.find_by_short_title(params[:story])
    render :action => 'show'
  end

  def showBySubD
    if (request.subdomains(0).first == 'playground')
      list
      render :action => 'playground', :layout => 'playground'
    else
      @story = story
      render :action => 'show'
    end
  end

  def new
    @story = Story.new
  end

  def create
    @story = Story.new(params[:story])
    @universes = Universe.find_all
     if @story.save
      flash[:notice] = 'Story was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @story = Story.find(params[:id])
    @universes = Universe.find_all
  end

  def update
    @story = Story.find(params[:id])
    if @story.update_attributes(params[:story])
      flash[:notice] = 'Story was successfully updated.'
      redirect_to :action => 'show', :id => @story.id
    else
      render :action => 'edit'
    end
  end

  def destroy
    Story.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def setup_page_vars

    logger.debug "#{params.inspect}"

    unless (request.subdomains(0).first == 'playground')


      home_link = link_to 'Home', index_url(:host => StoryHost('playground'))

      unless params[:action] == 'new' or params[:action] == 'create'
        @story = Story.find(params[:id])
        universe_link =  link_to @story.universe.name, url_for(:host => StoryHost('playground'), :controller => 'universes', :action => 'show', :id => @story.universe.id)
      else
        @universe = Universe.find(params[:universe_id])
        universe_link =  link_to @universe.name, url_for(:host => StoryHost('playground'), :controller => 'universes', :action => 'show', :id => @universe.id)
      end
        @breadcrumbs = "#{home_link}"
      @breadcrumbs += " &gt; #{universe_link }"

      case params[:action]
      when /list/
        @page_title = 'Story List'
      when 'new'
        @page_title = 'New Story'
      when 'create'
        @page_title = 'New Story'
      else
        @page_title = @story.title
        @breadcrumbs += " &gt; #{@story.title }"
      end
    else
      home_link = link_to 'Home', index_url(:host => StoryHost('playground'))
      @breadcrumbs = "#{home_link}"
      @page_title = "Pele's Playground"
    end
  end

  def handle_url
    unless (request.subdomains(0).first == 'playground') or params[:action] == 'new' or params[:action] == 'create'
      params[:id] = Story.find_by_short_title(request.subdomains(0).first).id unless params[:id]
    end
  end

end
