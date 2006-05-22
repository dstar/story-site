class Pcomment < ActiveRecord::Base
  belongs_to :paragraph
  belongs_to :user
  def self.listForPara(para_id)
    find(:all,
      :conditions => ["paragraph_id = ? and flag < 2", para_id],
      :order => "created_at asc")
  end
  def self.chapterID(pcomment_id)
    temp = find(:first,
      :select => "p.id, p.chapter_id, pcomments.id as comment_id",
      :joins => "left join paragraphs p on pcomments.paragraph_id = p.id",
      :conditions => ["pcomments.id = ?", pcomment_id])
    temp.chapter_id
  end
end
