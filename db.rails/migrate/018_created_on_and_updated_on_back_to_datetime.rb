class CreatedOnAndUpdatedOnBackToDatetime < ActiveRecord::Migration
  def self.up
	change_column('blogposts','created_on',:datetime)
	change_column('blogposts','updated_on',:datetime)
  end

  def self.down
  end
end
