class User < ActiveRecord::Base
  has_many :sessions

  has_many :credits
  has_many :stories, :through => :credits

  has_many :memberships
  has_many :groups, :through => :memberships

  has_many :user_permissions
  has_many :site_permissions

  def story_permissions(story)
    story_id = story_id if story is_a? Story
    self.user_permissions.collect {|p| p if p.permissionable_id == story_id}
  end

  set_primary_key "user_id"
end
