class StoryPermission < ActiveRecord::Base
  belongs_to :story
  belongs_to :permission_holder, :polymorphic => true
end
