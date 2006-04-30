class User < ActiveRecord::Base
  establish_connection "authentication"
  has_many :sessions
  has_many :credits
  has_many :stories, :through => :credits

  set_table_name "php_forum_users"
  set_primary_key "user_id"
end
