class Group < ActiveRecord::Base
  has_many :memberships
  has_many :users, :through => :memberships

  has_many :story_permissions, :as => :permission_holder
  has_many :universe_permissions, :as => :permission_holder
  has_many :site_permissions, :as => :permission_holder

  def has_story_permission(story,permission)
    story_id = story.id if story is_a?(Story)
    has_permission = false
    self.story_permissions.each {|p| has_permission = true if p.story_id == story_id and p.permission == permission }
    return has_permission
  end

  def has_universe_permission(universe,permission)
    universe_id = universe.id if universe is_a?(Universe)
    has_permission = false
    self.universe_permissions.each {|p| has_permission = true if p.universe_id == universe_id and p.permission == permission }
    return has_permission
  end

  def has_site_permission(permission)
    has_permission = false
    self.site_permissions.each {|p| has_permission = true if p.permission == permission }
    return has_permission
  end


  def self.primary_key() "group_id"  end
end
