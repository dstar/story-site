class AddLastState < ActiveRecord::Migration
  def self.up
	add_column :chapters, :last_status, :string
  end

  def self.down
	remove_column :chapters, :last_status
  end
end
