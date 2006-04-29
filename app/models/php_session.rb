class Php_Session < ActiveRecord::Base
  establish_connection "authentication"
  belongs_to :user
  set_table_name "php_forum_sessions"

  def self.primary_key() "session_id"  end
end
