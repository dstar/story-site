class Chapter < ActiveRecord::Base
  belongs_to :story
  has_many :paragraphs

  before_save :check_release_status

  def self.orderedListByStory(story_id)
    find(:all,
            :conditions => ["story_id = ?", story_id],
            :order => "number asc")
  end
  def self.orderedListByDate
    find(:all,
        :order => "date asc")
  end
  def self.orderedList
    find(:all,
        :order => "story_id, number asc")
  end
  def to_param
    self.file
  end

  def date
    # We need to play a little game, see -- if the chapters released, then we want date to display the release date. If not, we want the upload date.
    if self.status == "released"
      return self.date_released
    else
      return self.date_uploaded
    end
  end

  def get_comments_unread_by(user)

    comments = self.paragraphs.collect { |p| p.pcomments }.flatten
    unread_comments = comments.collect { |c| c if ! c.read_by.include?(user) }.compact
    return unread_comments
  end

  def get_num_comments_unread_by(user)
    results = Chapter.find_by_sql(["SELECT c.id, count(pc.id) as total, sum(pc.read_by NOT LIKE ? and pc.flag !=2) as unread, sum(pc.acknowledged is null or pc.acknowledged like '') FROM pcomments pc LEFT JOIN paragraphs p on pc.paragraph_id = p.id LEFT JOIN chapters c on p.chapter_id = c.id WHERE c.id = ? GROUP BY c.id", "%- #{user}\n%", self.id]).first

    if results
      return results.unread.to_i
    else
      return 0
    end
#    comments = self.paragraphs.collect { |p| p.pcomments }.flatten
#    unread_comments = comments.collect { |c| c if ! c.read_by.include?(user) }.compact
#    return unread_comments.length
  end

  def get_unacknowledged_comments
    comments = self.paragraphs.collect { |p| p.pcomments }.flatten
    unacknowledged_comments = comments.collect {|c| c if c.acknowledged.blank?}.compact
    return unacknowledged_comments
  end

  def get_num_unacknowledged_comments
    results = Chapter.find_by_sql(["SELECT c.id, count(pc.id) as total, sum(pc.flag != 2 and (pc.acknowledged is null or pc.acknowledged like '')) as unacknowledged FROM pcomments pc LEFT JOIN paragraphs p on pc.paragraph_id = p.id LEFT JOIN chapters c on p.chapter_id = c.id WHERE c.id = ? GROUP BY c.id", self.id]).first

    if results
      return results.unacknowledged.to_i
    else
      return 0
    end

#    comments = self.paragraphs.collect { |p| p.pcomments }.flatten
#    unacknowledged_comments = comments.collect {|c| c if c.acknowledged.blank?}.compact
#    return unacknowledged_comments.length
  end

  private
  def check_release_status
    if self.status == "released"
      if self.last_status != "released"
        self.date_released = Time.now.strftime('%Y-%m-%d')
        if ! self.released? 
          if self.story.on_release
            self.story.on_release.split(/\n/).each do |command|
              if command.match(/^[a-zA-Z0-9_]+$/)
                # We make sure the filename is safe -- with only 
                # letters, digits, and underscores, it _shouldn't_ 
                # be possible to do anything nefarious with it. 
                # I think. Never underestimate the ingenuity of 
                # crackers.
                system "#{RAILS_ROOT}/release_scripts/#{command}", self.story.short_title, self.number.to_s # with story.short_title and number, the script can get anything else it needs
                logger.error "Return code from #{RAILS_ROOT}/release_scripts/#{command} #{self.short_title} #{self.number.to_s} was #{$?}!" if $?
              end
            end            
          end
          self.released = true
        end
      end
    elsif self.status == "draft" and self.last_status != "draft"
      self.released = false
    end
    self.last_status = self.status
  end

end
