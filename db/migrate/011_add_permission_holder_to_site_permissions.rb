class AddPermissionHolderToSitePermissions < ActiveRecord::Migration
  def self.up
    add_column :site_permissions, :permission_holder_id, :integer
    add_column :site_permissions, :permission_holder_type, :string
  end

  def self.down
  end
end
