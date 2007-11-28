class AddReleaseOnFieldToChapters < ActiveRecord::Migration
  def self.up
    add_column :chapters, :release_on, :datetime
  end

  def self.down
    remove_column :chapters, :release_on
  end
end
