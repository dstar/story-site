class CreateRequiredPermissions < ActiveRecord::Migration
  def self.up
    create_table :required_permissions do |t|
      t.column :permissionable_id, :integer
      t.column :permissionable_type, :string
      t.column :status, :string
      t.column :action, :string
      t.column :permission, :string
    end
  end

  def self.down
    drop_table :required_permissions
  end
end
