class Group < ActiveRecord::Base
  establish_connection "authentication"
  set_table_name "php_forum_groups"

  def self.primary_key() "group_id"  end
end
