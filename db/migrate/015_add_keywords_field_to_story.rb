class AddKeywordsFieldToStory < ActiveRecord::Migration
  def self.up
    add_column :stories, :keywords, :string
  end

  def self.down
  end
end
