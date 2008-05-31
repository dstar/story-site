class CreateStoryPermissions < ActiveRecord::Migration
  def self.up
    create_table :story_permissions do |t|
      # t.column :name, :string
      t.column :permission_holder_id, :integer
      t.column :permission_holder_type, :string
      t.column :story_id, :integer
      t.column :permission, :string
    end
  end

  def self.down
    drop_table :story_permissions
  end
end
