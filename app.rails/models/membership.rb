class Membership < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  def self.primary_key() "user_id"  end
end
