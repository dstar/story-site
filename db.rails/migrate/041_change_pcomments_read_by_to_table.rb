class ChangePcommentsReadByToTable < ActiveRecord::Migration
  def self.up
    create_table :pcomments_read_by, :id => false do |t|
      t.integer :pcomment_id, :user_id, :null => false
    end
    add_index :pcomments_read_by, :pcomment_id
    add_index :pcomments_read_by, :user_id
    Pcomment.find(:all).each do |pc|
      pc.read_by.each do |reader|
      pc.readers << User.find_by_username(reader)
      end
    end
  end

  def self.down
    drop_table :pcomments_read_by
  end
end
