class ChangeBlogpostsPostedToPostedOn < ActiveRecord::Migration
  def self.up
	change_column('blogposts','posted',:date)
	rename_column('blogposts','posted','posted_on')
  end

  def self.down
  end
end
