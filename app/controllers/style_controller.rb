class StyleController < ApplicationController

  def setup_authorize_hash
    @authorization = { 
      "customize"        => [ "LOGGED_IN", ],
      "save_style"       => [ "LOGGED_IN", ],
      "edit_theme"       => [ "admin", ],
      "save_theme_style" => [ "admin", ],
    }
  end

  def check_authorization(user)
    needed = @authorization[params[:action]]
    if needed
      needed.each do |req|
        return true if req == "EVERYONE" # check for public action
        return true if user.has_site_permission(req) # Else check that we have the required permission
      end
    end
    return false
  end
  end
  
  def style_dropdown
    render(:layout => false)
  end

  def style_links
    render(:layout => false)
  end

  def show
    @theme = params[:theme]
    @theme = 'default' unless @theme
    @default_styles = Style.find_all_by_theme_and_user(@theme,-1)
    @user_styles = Style.find_all_by_theme_and_user(@theme,@authinfo[:user_id])

    @styles = Array.new

    unless @user_styles.empty?
      @styles = @user_styles

      @user_styles_names = @user_styles.collect { |e| e.element}
      $stderr.write("\n\n#{@user_styles_names.inspect}\n\n")
      @default_styles.each do |element|
        @styles << element unless @user_styles_names.include?(element.element)
      end
    else
      @styles = @default_styles
    end



    @styles_by_bodies = Hash.new

    @styles.each do |style|     
      if @styles_by_bodies[style.definition]
        @styles_by_bodies[style.definition] = "#{@styles_by_bodies[style.definition]}, #{style.element}" 
      else
        @styles_by_bodies[style.definition] = "#{style.element}" 
      end
    end

    @stylesheet = String.new

    @styles_by_bodies.each do |style, element|
      @stylesheet = @stylesheet + "#{element} { #{style} }\n"
    end
    render(:layout => false)
  end

  def edit_theme
    @theme = cookies[:style]
    @theme = 'default' unless @theme
    @theme_styles = Style.find_all_by_theme_and_user(@theme,-1, :order => 'element ASC')
  end

  def customize
    @theme = cookies[:style]
    @theme = 'default' unless @theme
    @default_styles = Style.find_all_by_theme_and_user(@theme,-1)
    @user_styles = Style.find_all_by_theme_and_user(@theme,@authinfo[:user_id])
  end

  def save_style

    if @authinfo[:username]
      definition = params[:definition]
      element = params[:element]

      if element and definition
        
        @theme = cookies[:style]
        @theme = 'default' unless @theme
        @style = Style.find_by_theme_and_user_and_element(@theme,@authinfo[:user_id],element)

        @style = Style.new unless @style
        # if @style is null, this style doesn't exist, so create it

        #canonicalize definition
        definition.gsub!(/\s+/, " ")
        definition.gsub!(/ *: */, " : ")
        definition.gsub!(/ *; */, "; ")
        definition.gsub!(/^\s+/, "")
        definition.gsub!(/\s+$/, "")

        @style.element = element
        @style.definition = definition
        @style.theme = @theme
        @style.user = @authinfo[:user_id]

        if @style.save
          @result = "Saved Successfully"
          render :partial => "edit_style", :locals => { :edit_style => @style, :result => @result }
        else
          @result = "Save failed"
          render :partial => "edit_style", :locals => { :edit_style => @style, :result => @result }
        end
      else
        @style = Style.new unless @style
        @result = "Please enter both an element specifier and a style"
        render :partial => "edit_style", :locals => { :edit_style => @style, :result => @result }
      end
    end
  end

  def save_theme_style

    if @authinfo[:username]
      definition = params[:definition]
      element = params[:element]

      if element and definition
        
        @theme = cookies[:style]
        @theme = 'default' unless @theme
        @style = Style.find_by_theme_and_user_and_element(@theme,-1,element)

        @style = Style.new unless @style
        # if @style is null, this style doesn't exist, so create it

        #canonicalize definition
        definition.gsub!(/\s+/, " ")
        definition.gsub!(/ *: */, " : ")
        definition.gsub!(/ *; */, "; ")
        definition.gsub!(/^\s+/, "")
        definition.gsub!(/\s+$/, "")

        @style.element = element
        @style.definition = definition
        @style.theme = @theme
        @style.user = -1

        if @style.save
          @result = "Saved Successfully"
          render :partial => "edit_theme_style", :locals => { :edit_theme_style => @style, :result => @result }
        else
          @result = "Save failed"
          render :partial => "edit_theme_style", :locals => { :edit_theme_style => @style, :result => @result }
        end
      else
        @style = Style.new unless @style
        @result = "Please enter both an element specifier and a style"
        render :partial => "edit_theme_style", :locals => { :edit_theme_style => @style, :result => @result }
      end
    end
  end

  def setup_page_vars
    @breadcrumbs = 'Bleah! Bleah! Bleah!'
  end


end
