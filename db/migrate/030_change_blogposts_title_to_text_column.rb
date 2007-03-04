class ChangeBlogpostsTitleToTextColumn < ActiveRecord::Migration
  def self.up
 	change_column('blogposts','title',:text)
  end

  def self.down
  end
end
