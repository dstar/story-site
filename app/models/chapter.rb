class Chapter < ActiveRecord::Base
  belongs_to :story
  has_many :paragraphs

  after_save :check_release_status

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

  private
  def check_release_status
    if self.status == "released"
      if self.last_status != "released"
        if ! self.released? 
          if self.story.on_release
            self.story.on_release.each do |command|
              system "#{RAILS_ROOT}/release_scripts/#{command}"
            end
          end
        end
      end
    end
    self.last_status = self.status
  end

end
