class AddBodyRawToPcomments < ActiveRecord::Migration
  def self.up
    add_column :pcomments, :body_raw, :text
    Pcomments.find(:all).each do |pc|
      pc.body_raw = pc.body.dup
      pc.save
    end
  end

  def self.down
    Pcomments.find(:all).each do |pc|
      pc.body = pc.body_raw.dup
      pc.save
    end
  end
end
