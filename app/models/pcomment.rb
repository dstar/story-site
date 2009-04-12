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
#    logger.debug "QQQ: Pcomment#move called with direction '#{direction}'"

#    logger.debug "QQQ: Pcomment#move: position currently '#{self.paragraph.position}', paragraph currently '#{self.paragraph.id}'"

    if direction == 'next'
      new_parent = self.paragraph.lower_item
    else
      new_parent = self.paragraph.higher_item
    end

#    logger.debug "QQQ: Pcomment#move: new_parent is '#{new_parent.id}'"

    if new_parent
      self.paragraph = new_parent
      self.save
#      logger.debug "QQQ: Pcomment#move: position NOW '#{self.paragraph.position}', paragraph currently '#{self.paragraph.id}'"
    end
  end

  def self.default_permissions
    return {
      "destroy"       => ["author",],
      "update"        => ["author",],
      "edit"          => ["author",],
      "create"        => ["beta-reader","author",],
      "new"           => ["author","beta-reader",],
      "markread"      => ["author","beta-reader",],
      "markunread"    => ["author","beta-reader",],
      "acknowledge"   => ["author",],
      "unacknowledge" => ["author",],
      "move_next"     => ["author",],
      "move_prev"     => ["author",],
    }
  end

end
