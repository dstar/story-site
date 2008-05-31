class AddReleased < ActiveRecord::Migration
  def self.up
	add_column :chapters, :released, :string
  end

  def self.down
	remove_column :chapters, :released
  end
end
