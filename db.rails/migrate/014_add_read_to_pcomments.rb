class AddReadToPcomments < ActiveRecord::Migration
  def self.up
    add_column :pcomments, :read, :string
  end

  def self.down
  end
end
