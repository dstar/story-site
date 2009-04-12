module Merb
  module UsersHelper
    def new_story_link
      link_to 'New Story', url(:controller => "users", :action => "new_story", :id => @user.id) if @authinfo[:user] == @user && @user.has_site_permission("author")
    end

    # Returns an array of <li> entries for the user's stories
    #
    #Only shows stories with released chapters if the visitor is not
    # the user. (Needs to be changed to check for chapters the visitor
    # can see).
    #
    # The update date is the date of the latest _released_ chapter if
    # the user is not the author (Needs to be changed to 'latest
    # visible chapter')

    def stories_list
#      Merb.logger.debug "QQQ26: @user.stories == #{@user.stories.inspect}"
      stories_list = []
      stories = @user.stories.collect { |s| [s,s.chapters.find(:first, :order => "date_released desc"), s.chapters.find(:first, :order => "date_released desc", :conditions => "status = 'released'")]}

      stories.each do |s|
        title_link = "<a href='/stories/show/#{s[0].id}'>#{s[0].title}</a>"
        if @authinfo[:user] == @user
          entry = "<li> #{title_link} (#{s[0].chapters.length} chapters, #{s[0].chapters.inject(0) { |i,k| i = i + k.words}} words"
          entry += ", last updated on #{s[1].date_released})" if s[1]
          entry += "</li>\n"
          stories_list << entry
        elsif s[2]
          stories_list << "<li> #{title_link} (#{s[0].chapters.length} chapters, #{s[0].chapters.inject(0) { |i,k| i = i + k.words}} words, last updated on #{s[2].date_released}) </li>\n"
        end
      end


#      Merb.logger.debug "QQQ27: stories_list for #{@authinfo[:user].username} == #{stories_list.inspect}"
      return stories_list

    end

  end
end
