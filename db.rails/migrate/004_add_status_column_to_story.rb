class AddStatusColumnToStory < ActiveRecord::Migration
  def self.up
    add_column :stories, :status, :string, :default => 'draft'
  end

  def self.down
  end
end
