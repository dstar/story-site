class Story < ActiveRecord::Base
  validates_presence_of :universe_id, :title, :short_title, :description
  belongs_to :universe
  has_many :chapters
  has_and_belongs_to_many :authors,
  :class_name => "AuthorStory",
  :join_table =>
    "authors_stories",
  :association_foreign_key =>
    "user_id"

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
