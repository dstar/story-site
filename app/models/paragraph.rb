class Paragraph < ActiveRecord::Base
  belongs_to :chapter
  has_many :pcomments, :order => 'id'

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
#    self.body.gsub!(/_(\w+)_/) { |m| m.gsub!(/_/,''); "<em>#{m}<\/em>"}
    self.body.gsub!(/_([-\\{}?*A-Za-z0-9 .,;#&:`'!\/"()]+)_/) { |m| m.gsub!(/_/,''); "<em>#{m}<\/em>"}
    self.body.gsub!(/--/,"&mdash;")
    self.body.gsub!(/^\*\*\*$/, '<hr/>')
  end

  def cache_key
    "show#paragraph_#{self.id}"
  end

  def total_comments
    Pcomment.count(:conditions => "paragraph_id = #{self.id} and flag < 2")
  end

  def unread_comments(user)
    Pcomment.count(:conditions => "paragraph_id = #{self.id} and id not in (select prb.pcomment_id from pcomments_read_by prb where prb.user_id = #{user.id})")
  end

  def unacknowledged_comments
    self.pcomments.inject(0) {|i, x| if x.flag < 2 and x.acknowledged.blank? then i += 1 else i += 0 end}
  end

  def move_comments(direction)
      logger.debug "QQQ: Paragraph#move_comments called with direction '#{direction}'"
    self.pcomments.each do |comment|
      logger.debug "QQQ: Paragraph#move_comments calling Pcomment#move with direction '#{direction}' for #{comment.id}"
      comment.move(direction)
    end
  end

end
