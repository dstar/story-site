class SitePermission < ActiveRecord::Base
  belongs_to :permission_holder, :polymorphic => true
end
