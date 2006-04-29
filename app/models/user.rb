class User < ActiveRecord::Base
  establish_connection "authentication"
  has_many :sessions
  set_table_name "php_forum_users"
  set_primary_key "user_id"
end
