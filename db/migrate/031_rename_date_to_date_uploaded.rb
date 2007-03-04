class RenameDateToDateUploaded < ActiveRecord::Migration
  def self.up
	rename_column('chapters','date','date_uploaded')
  end

  def self.down
	rename_column('chapters','date_uploaded','date')
  end
end
