class Paragraph < ActiveRecord::Base
  belongs_to :chapter
  has_many :pcomments

  acts_as_list :scope => "chapter_id"

  before_save :format_body

  def self.paraList(chapter_id)
    find(:all,
        :conditions => ["chapter_id = ?",chapter_id],
        :order => "paragraphs.position asc")
  end
  def self.maxPara(chapter_id)
    count_by_sql ["select ifnull(max(paragraphs.position),0) from paragraphs where chapter_id = ?",chapter_id]
  end

  def format_body
    self.body = self.body_raw.dup
    self.body.gsub!(/_(\w+)_/) { |m| m.gsub!(/_/,' '); "<em>#{m}<\/em>"} 
    self.body.gsub!(/_([-\\{}?*A-Za-z0-9 .,;:`'!\/"]+)_/) { |m| m.gsub!(/_/,' '); "<em>#{m}<\/em>"}
  end

end
