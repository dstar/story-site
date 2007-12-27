class AddBodyRawToPcomments < ActiveRecord::Migration
  def self.up
    add_column :pcomments, :body_raw, :text
    Pcomment.find(:all).each do |pc|
      pc.body_raw = pc.body.dup
      pc.save
    end
  end

  def self.down
    Pcomment.find(:all).each do |pc|
      pc.body = pc.body_raw.dup
      pc.save
    end
  end
end
