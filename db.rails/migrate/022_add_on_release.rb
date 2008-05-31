class AddOnRelease < ActiveRecord::Migration
  def self.up
	add_column :stories, :on_release, :string
  end

  def self.down
	remove_column :stories, :on_release
  end
end
