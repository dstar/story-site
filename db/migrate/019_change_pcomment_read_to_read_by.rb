class ChangePcommentReadToReadBy < ActiveRecord::Migration
  def self.up
	remove_column('pcomments','read')
	add_column('pcomments','read_by',:text)
  end

  def self.down
  end
end
