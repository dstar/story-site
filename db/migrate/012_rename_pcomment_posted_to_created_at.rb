class RenamePcommentPostedToCreatedAt < ActiveRecord::Migration
  def self.up
	rename_column('pcomments','posted','created_at')
  end

  def self.down
  end
end
