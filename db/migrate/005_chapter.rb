class Chapter < ActiveRecord::Migration
  def self.up
    add_column :chapters, :status, :string, :default => 'draft'
  end

  def self.down
  end
end
