class AddRequiredPermissionToStory < ActiveRecord::Migration
  def self.up
    add_column :stories, :required_permission, :string
  end

  def self.down
    remove_column :stories, :required_permission
  end
end
