class CreateUniversePermissions < ActiveRecord::Migration
  def self.up
    create_table :universe_permissions do |t|
      # t.column :name, :string
      t.column :permission_holder_id, :integer
      t.column :permission_holder_type, :string
      t.column :universe_id, :integer
      t.column :permission, :string
    end
  end

  def self.down
    drop_table :universe_permissions
  end
end
