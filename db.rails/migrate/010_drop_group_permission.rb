class DropGroupPermission < ActiveRecord::Migration
  def self.up
	drop_table :group_permissions
  end

  def self.down
  end
end
