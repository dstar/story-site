class User_Group < ActiveRecord::Base
  establish_connection "authentication"
  has_many :groups
  belongs_to :user
  set_table_name "php_forum_user_group"

  def self.primary_key() "user_id"  end
end
