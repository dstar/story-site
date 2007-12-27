class AddBodyRawToBlogposts < ActiveRecord::Migration
  def self.up
    add_column :blogposts, :body_raw, :text
    Blogpost.find(:all).each do |b|
      b.body_raw = b.body.dup
      b.save
    end
  end

  def self.down
    Blogpost.find(:all).each do |b|
      b.body = b.body_raw.dup
      b.save
    end
  end
end
