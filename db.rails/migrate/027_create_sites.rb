class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :sites
  end
end
