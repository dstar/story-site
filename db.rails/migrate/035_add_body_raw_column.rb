class AddBodyRawColumn < ActiveRecord::Migration
  def self.up
    add_column :paragraphs, :body_raw, :text
    paragraphs = Paragraph.find(:all)
    paragraphs.each do |p|
      p.body_raw = p.body
      p.body.gsub!(/_(\w+)_/) { |m| m.gsub!(/_/,' '); "<em>#{m}<\/em>"} 
      p.body.gsub!(/_([-\\{}?*A-Za-z0-9 .,;:`'!\/"]+)_/) { |m| m.gsub!(/_/,' '); "<em>#{m}<\/em>"}
      p.save
    end
  end

  def self.down
    paragraphs = Paragraph.find(:all)
    paragraphs.each do |p|
      p.body.gsub!(/<em> /,'_')
      p.body.gsub!(/ <\/em>/,'_')
      p.save
    end
    remove_column :paragraphs, :body_raw
  end
end
