class FooMigration < ActiveRecord::Migration
  def self.up
    create_table :foos do |t|
      t.string      :body 

      t.timestamps
    end 
  end

  def self.down
    drop_table :foos
  end
end
