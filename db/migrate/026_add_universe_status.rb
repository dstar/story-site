class AddUniverseStatus < ActiveRecord::Migration
  def self.up
    add_column :universes, :status, :string
  end

  def self.down
  end
end
