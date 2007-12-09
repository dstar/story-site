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
    obtained_permisson = self.story_permissions.find(:first, :conditions => "story_id=#{story_id} and permission='#{permission}'")
    unless obtained_permisson
      self.groups.each do |group|
        obtained_permisson = group.story_permissions.find(:first, :conditions => "story_id=#{story_id} and permission='#{permission}'")
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
    obtained_permisson = self.universe_permissions.find(:first, :conditions => "universe_id=#{universe_id} and permission='#{permission}'")
    unless obtained_permisson
      self.groups.each do |group|
        obtained_permisson = group.universe_permissions.find(:first, :conditions => "universe_id=#{universe_id} and permission='#{permission}'")
        break if obtained_permisson
      end
    end
    return obtained_permisson
  end

  def has_site_permission(permission)
    has_permission = false
    self.site_permissions.each {|p| has_permission = true if p.permission == permission }
    return has_permission
  end

  def User.has_permission(user, permission)
    if user and user.id != -1
      return true
    end
  end

  set_primary_key "user_id"
end
