class User < ActiveRecord::Base
  has_many :sessions

  has_many :credits
  has_many :stories, :through => :credits

  has_many :memberships
  has_many :groups, :through => :memberships

  has_many :story_permissions, :as => :permission_holder
  has_many :universe_permissions, :as => :permission_holder
  has_many :site_permissions, :as => :permission_holder
    
  def has_story_permission(story,permission)
    logger.debug "Permission is #{permission}\n"
    if story.is_a?(Story)
      story_id = story.id
    else
      story_id = story
    end
    @cache_story_permissions = [] unless @cache_story_permissions  
    @cache_story_permissions[story_id] = [] unless @cache_story_permissions[story_id]
    if @cache_story_permissions[story_id].empty?
      temp_holder = [].push(self.story_permissions.find(:all, :conditions => "story_id = #{story_id}"))
      logger.debug "QQQ: Temp holder is #{temp_holder.inspect} with class #{temp_holder.class}"
      @cache_story_permissions[story_id].push(temp_holder)
      logger.debug "QQQ: @cache_story_permissions[story_id] is @cache_#{@cache_story_permissions[story_id].inspect} with class #{@cache_story_permissions[story_id].class}"
      @cache_story_permissions[story_id].flatten!
      logger.debug "QQQ_AFTER_FLATTEN: @cache_story_permissions[story_id] is @cache_#{@cache_story_permissions[story_id].inspect} with class #{@cache_story_permissions[story_id].class}"
    end
    obtained_permisson = @cache_story_permissions[story_id].any? { |sp| sp.permission == permission}
    unless obtained_permisson
      self.groups.each do |group|
        @cache_group_story_permissions = {} unless @cache_group_story_permissions
        @cache_group_story_permissions[group] = [] unless @cache_group_story_permissions[group]
        @cache_group_story_permissions[group][story_id] = [] unless @cache_group_story_permissions[group][story_id]
        @cache_group_story_permissions[group][story_id] << group.story_permissions.find(:all,:conditions => "story_id = #{story_id}") if @cache_group_story_permissions[group][story_id].empty?
        @cache_group_story_permissions[group][story_id].flatten!
        obtained_permisson = @cache_group_story_permissions[group][story_id].any? { |sp| sp.permission==permission}
        break if obtained_permisson
      end
    end
    return obtained_permisson
  end

  def has_universe_permission(universe,permission)
    if universe.is_a?(Universe)
      universe_id = universe.id
    else
      universe_id = universe
    end
    @cache_universe_permissions = [] unless @cache_universe_permissions
    @cache_universe_permissions[universe_id] = [] unless @cache_universe_permissions[universe_id]
    @cache_universe_permissions[universe_id] << self.universe_permissions.find(:all, :conditions => "universe_id = #{universe_id}") if @cache_universe_permissions[universe_id].empty?
    @cache_universe_permissions[universe_id].flatten!
    obtained_permisson = @cache_universe_permissions[universe].any? { |up|  up.permission==permission}
    unless obtained_permisson
      self.groups.each do |group|
        @cache_group_universe_permissions = {} unless @cache_group_universe_permissions
        @cache_group_universe_permissions[group] = [] unless @cache_group_universe_permissions[group]
        @cache_group_universe_permissions[group][universe_id] = [] unless @cache_group_universe_permissions[group][universe_id]
        @cache_group_universe_permissions[group][universe_id] << group.universe_permissions.find(:all, :conditions => "universe_id = #{universe_id}") if @cache_group_universe_permissions[group][universe_id].empty?
        @cache_group_universe_permissions[group][universe_id].flatten!
        obtained_permisson = @cache_group_universe_permissions[group][universe_id].any? { |up| up.permission==permission}
        break if obtained_permisson
      end
    end
    return obtained_permisson
  end

  def has_site_permission(permission)
    has_permission = false
    if permission == "LOGGED_IN"
      has_permission = self.id != -1 # if our id is -1, we're anonymous
    else
      self.site_permissions.each {|p| has_permission = true if p.permission == permission }
    end
    return has_permission
  end

  #  def User.has_permission(user, permission)
  #    if user and user.id != -1
  #      return true
  #    end
  #  end

  set_primary_key "user_id"
end
