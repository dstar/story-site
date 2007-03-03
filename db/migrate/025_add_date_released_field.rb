class AddDateReleasedField < ActiveRecord::Migration
  def self.up
    add_column :chapters, :date_released, :date, { :default => "0000-00-00" }
  end

  def self.down
	remove_column :chapters, :date_released
  end
end
