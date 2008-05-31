class RequiredPermission < ActiveRecord::Base
  belongs_to :permissionable, :polymorphic => true 
end