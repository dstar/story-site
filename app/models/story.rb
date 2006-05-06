class Story < ActiveRecord::Base
  validates_presence_of :universe_id, :title, :short_title, :description

  belongs_to :universe

  has_many :chapters

  has_many :story_permissions

  #hack, because I can't figure out a way to make has_many :authors work
  has_many :credits
  has_many :users, :through => :credits
  def authors
    self.users.collect { |u| c = Credit.find_by_user_id_and_story_id(u.user_id,self.id); u if c.credit_type == 'Author' }.compact
  end

  def self.OrderedListByUniverse(universe_id)
    find(:all,
            :select => "stories.id, title, description, sum(chapters.words) as sort, universe_id",
            :joins => "left outer join chapters on chapters.story_id = stories.id",
            :conditions => ["universe_id = ?", universe_id],
            :group => "stories.id", :order => "sort desc")
  end
  def self.OrderedList()
    find(:all,
            :select => "stories.id, title, description, sum(chapters.words) as sort, universe_id",
            :joins => "left outer join chapters on chapters.story_id = stories.id",
            :group => "stories.id", :order => "sort desc")
  end
end
