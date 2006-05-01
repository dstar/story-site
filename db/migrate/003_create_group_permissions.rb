class CreateGroupPermissions < ActiveRecord::Migration
  def self.up
    create_table :group_permissions do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :group_permissions
  end
end
