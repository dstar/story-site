class CreateGroupPermissions < ActiveRecord::Migration
  def self.up
    create_table :group_permissions do |t|
      # t.column :name, :string
      t.column :group_id, :integer
      t.column :permissionable_id, :integer
      t.column :permissionable_type, :integer
      t.column :permission, :string
    end
  end

  def self.down
    drop_table :group_permissions
  end
end
