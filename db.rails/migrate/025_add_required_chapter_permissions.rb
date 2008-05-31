class AddRequiredChapterPermissions < ActiveRecord::Migration
  def self.up
    add_column :stories, :required_chapter_permissions, :string
  end

  def self.down
  end
end
