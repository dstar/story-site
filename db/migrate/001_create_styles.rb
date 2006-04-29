class CreateStyles < ActiveRecord::Migration
  def self.up
    create_table :styles do |t|
      # t.column :name, :string
      t.column :name, :string
    end
  end

  def self.down
    drop_table :styles
  end
end
