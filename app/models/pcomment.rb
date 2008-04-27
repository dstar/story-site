class Pcomment < ActiveRecord::Base
  belongs_to :paragraph
  belongs_to :user

  has_and_belongs_to_many :readers, :join_table => 'pcomments_read_by', :class_name => 'User'

  serialize :read_by

  before_save :format_body

  def test_catching
    return "caught"
  end

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

  def cache_key
    "pcomment_#{self.id}"
  end

  def format_body
    self.body = self.body_raw.dup
    #    self.body.gsub!(/_(\w+)_/) { |m| m.gsub!(/_/,''); "<em>#{m}<\/em>"}
    self.body.gsub!(/_([-\\{}?*A-Za-z0-9 .,;&:`'!\/"()]+)_/) { |m| m.gsub!(/_/,''); "<em>#{m}<\/em>"}
    self.body.gsub!(/--/,"&mdash;")
    self.body.gsub!(/\n+/,"</p><p class='comment_body_paragraph'>")
    self.body.gsub!(/^/,"<p class='comment_body_paragraph'>")
    self.body.gsub!(/$/,"</p>")
    self.body.gsub!(/<p class='comment_body_paragraph'><\/p>/, "")
  end

  def move(direction)
    if direction == 'next'
      new_parent = self.lower_item
    else
      new_parent = self.higher_item
    end

    if new_parent
      self.paragraph_id = new_parent.id
      self.save
    end
  end

end
