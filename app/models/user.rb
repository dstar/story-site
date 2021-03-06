class User < ActiveRecord::Base
  has_many :sessions

  has_many :credits
  has_many :stories, :through => :credits

  has_many :memberships
  has_many :groups, :through => :memberships

  has_many :story_permissions, :as => :permission_holder
  has_many :universe_permissions, :as => :permission_holder
  has_many :site_permissions, :as => :permission_holder

  has_and_belongs_to_many :read_comments, :join_table => 'pcomments_read_by', :class_name => 'Pcomment'

  def has_story_permission(story,permission)
    if story.is_a?(Story)
      story_id = story.id
    else
      story_id = story
    end
    obtained_permission = self.story_permissions.any? { |sp| sp.story_id==story_id && sp.permission==permission}
    unless obtained_permission
      self.groups.each do |group|
        obtained_permission = group.story_permissions.any? { |sp| sp.story_id==story_id && sp.permission==permission}
        break if obtained_permission
      end
    end
    return obtained_permission
  end

  def has_universe_permission(universe,permission)
    if universe.is_a?(Universe)
      universe_id = universe.id
    else
      universe_id = universe
    end
    obtained_permission = self.universe_permissions.any? { |up| up.universe_id==universe_id && up.permission==permission}
    unless obtained_permission
      self.groups.each do |group|
        obtained_permission = group.universe_permissions.any? { |up| up.universe_id==universe_id && up.permission==permission}
        break if obtained_permission
      end
    end
    return obtained_permission
  end

  def has_site_permission(permission)
    has_permission = false
    if permission == "LOGGED_IN"
#      logger.error "ID is #{self.id}"
      has_permission = self.id != -1 # if our id is -1, we're anonymous
    else
      self.site_permissions.each {|p| has_permission = true if p.permission == permission }
    end
#    logger.error "Returning #{has_permission}"
    return has_permission
  end

  #  def User.has_permission(user, permission)
  #    if user and user.id != -1
  #      return true
  #    end
  #  end

  set_primary_key "user_id"
end
