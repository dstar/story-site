class Chapter < ActiveRecord::Base
  belongs_to :story
  has_many :paragraphs
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
end
