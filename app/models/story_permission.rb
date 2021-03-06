class StoryPermission < ActiveRecord::Base
  belongs_to :story
  belongs_to :permission_holder, :polymorphic => true

  def StoryPermission.has_permission(user, args_hash)
    if ! user.is_a?(User)
      user = User.find(user)
    end
    has_permission = false

    logger.debug "DBG: #{args_hash.inspect}, args_hash['id']\n"

    s_id = args_hash['id']

    if s_id.is_a?(String)
      s_id = s_id.to_i
    end
    user.story_permissions.each do |p| 
      has_permission = true if p.story_id == s_id and p.permission == args_hash['permission'] 
    end
    unless has_permission
      user.groups.each do |group|
        group.story_permissions.each do |p| 
          has_permission = true if p.story_id == s_id and p.permission == args_hash['permission'] 
        end
      end
    end
    return has_permission
  end

end
