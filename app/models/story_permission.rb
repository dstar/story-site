class StoryPermission < ActiveRecord::Base
  belongs_to :story
  belongs_to :permission_holder, :polymorphic => true

  def StoryPermission.has_permission(user, args_hash)
    if ! user.is_a?(User)
      user = User.find(user)
    end
    has_permission = false
    user.story_permissions.each {|p| has_permission = true if p.story_id == args_hash['id'] and p.permission == args_hash['permission'] }
    unless has_permission
      user.groups.each do |group|
        group.story_permissions.each {|p| has_permission = true if p.story_id == args_hash['id'] and p.permission == args_hash['permission'] }
      end
    end
    return has_permission
  end

end
