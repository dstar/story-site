class Paragraph < ActiveRecord::Base
  belongs_to :chapter
  has_many :pcomments

  acts_as_list :scope => "chapter_id"

  def self.paraList(chapter_id)
    find(:all,
        :conditions => ["chapter_id = ?",chapter_id],
        :order => "paragraphs.position asc")
  end
  def self.maxPara(chapter_id)
    count_by_sql ["select ifnull(max(paragraphs.position),0) from paragraphs where chapter_id = ?",chapter_id]
  end
end
