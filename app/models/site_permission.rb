class SitePermission < ActiveRecord::Base
  belongs_to :permission_holder, :polymorphic => true

  def SitePermission.has_permission(user, args_hash)
    if ! user.is_a?(User)
      user = User.find(user)
    end
    has_permission = false
    user.site_permissions.each {|p| has_permission = true if p.permission == args_hash['permission'] }
    unless has_permission
      user.groups.each do |group|
        group.site_permissions.each {|p| has_permission = true if p.permission == args_hash['permission'] }
      end
    end
    return has_permission
  end

end
