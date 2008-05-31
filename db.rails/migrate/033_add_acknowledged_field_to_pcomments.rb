class AddAcknowledgedFieldToPcomments < ActiveRecord::Migration
  def self.up
    add_column :pcomments, :acknowledged, :string
  end

  def self.down
    remove_column :pcomments, :acknowledged
  end
end
