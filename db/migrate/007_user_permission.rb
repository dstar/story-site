class DropUserPermission < ActiveRecord::Migration
  def self.up
	drop_table :user_permissions
  end

  def self.down
  end
end
