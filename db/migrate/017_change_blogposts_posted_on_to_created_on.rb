class ChangeBlogpostsPostedOnToCreatedOn < ActiveRecord::Migration
  def self.up
	rename_column('blogposts','posted_on','created_on')
	add_column('blogposts','updated_on',:date)
  end

  def self.down
  end
end
