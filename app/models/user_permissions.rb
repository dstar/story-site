class UserPermissions < ActiveRecord::Base
  belongs_to :user
  belongs_to :permissionable, :polymorphic => true
end
