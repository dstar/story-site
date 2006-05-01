class CreateUserPermissions < ActiveRecord::Migration
  def self.up
    create_table :user_permissions do |t|
      # t.column :name, :string
      t.column :author_id, :integer
      t.column :permissionable_id, :integer
      t.column :permissionable_type, :integer
      t.column :permission, :string
    end
  end

  def self.down
    drop_table :user_permissions
  end
end
