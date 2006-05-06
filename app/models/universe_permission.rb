class UniversePermission < ActiveRecord::Base
  belongs_to :universe
  belongs_to :permission_holder, :polymorphic => true
end
