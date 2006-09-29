class UniversePermission < ActiveRecord::Base
  belongs_to :universe
  belongs_to :permission_holder, :polymorphic => true

  def UniversePermission.has_permission(user, args_hash)
    if ! user.is_a?(User)
      user = User.find(user)
    end
    has_permission = false
    user.universe_permissions.each do |p| 
      has_permission = true if p.universe_id == args_hash['id'] and p.permission == args_hash['permission']
    end
    unless has_permission
      user.groups.each do |group|
        group.universe_permissions.each {|p| has_permission = true if p.universe_id == args_hash['id'] and p.permission == args_hash['permission'] }
      end
    end
    return has_permission
  end


end
