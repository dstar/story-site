class Group < ActiveRecord::Base
  has_many :memberships
  has_many :users, :through => :memberships

  def self.primary_key() "group_id"  end
end
