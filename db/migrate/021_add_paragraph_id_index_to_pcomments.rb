class AddParagraphIdIndexToPcomments < ActiveRecord::Migration
  def self.up
	add_index('pcomments', 'paragraph_id')
  end

  def self.down
  end
end
