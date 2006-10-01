class Universe < ActiveRecord::Base
  has_many :stories

  has_many :universe_permissions

  def self.OrderedListByStoryCount
    find(:all,
            :select => "name, universes.description, count(stories.id) as sort, universes.id",
            :joins => "left outer join stories on story.universe_id = universes.id",
            :group => "universes.id", :order => "sort asc")
  end

end
