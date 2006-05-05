class CreateSitePermissions < ActiveRecord::Migration
  def self.up
    create_table :site_permissions do |t|
      # t.column :name, :string
	t.column :user_id, :integer
	t.column :permission, :string
    end
  end

  def self.down
    drop_table :site_permissions
  end
end
