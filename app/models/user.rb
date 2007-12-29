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
    @story_permissions = [] unless @story_permissions  
    @story_permissions[story_id] = [] unless @story_permissions[story_id]
    @story_permissions[story_id] = self.story_permissions.find(:conditions => "story_id = #{story_id}") unless @story_permissions[story_id].empty?
    logger.debug "@story_permissions[story_id] is #{@story_permissions[story_id]}"
    obtained_permisson = @story_permissions[story_id].any? { |sp| sp.permission == permission}
logger.debug "obtained_permisson is #{obtained_permisson}"
    unless obtained_permisson
      self.groups.each do |group|
        @group_story_permissions = {} unless @group_story_permissions
        @group_story_permissions[group][story_id] = [] unless @group_story_permissions[group][story_id]
        @group_story_permissions[group][story_id] = group.story_permissions.find(:conditions => "story_id = #{story_id}") unless @group_story_permissions[group][story_id].empty?
        obtained_permisson = @group_story_permissions[group][story_id].any? { |sp| sp.permission==permission}
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
    @universe_permissions = [] unless @universe_permissions
    @universe_permissions[universe_id] = [] unless @universe_permissions[universe_id]
    @universe_permissions[universe_id] = self.universe_permissions.find(:conditions => "universe_id = #{universe_id}") unless @universe_permissions[universe_id].empty?
    obtained_permisson = @universe_permissions[universe].any? { |up|  up.permission==permission}
    unless obtained_permisson
      self.groups.each do |group|
        @group_universe_permissions = {} unless @group_universe_permissions
        @group_universe_permissions[group][universe_id] = [] unless @group_universe_permissions[group][universe_id]
        @group_universe_permissions[group][universe_id] = group.universe_permissions.find(:conditions => "universe_id = #{universe_id}") unless @group_universe_permissions[group][universe_id].empty?
        obtained_permisson = @group_universe_permissions[group][universe_id].any? { |up| up.permission==permission}
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
