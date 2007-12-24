class Universe < ActiveRecord::Base
  has_many :stories

  has_many :universe_permissions
  has_many :required_permissions, :as => :permissionable

  def self.OrderedListByStoryCount
    find(:all,
      :select => "name, universes.description, count(stories.id) as sort, universes.id",
      :joins => "left outer join stories on stories.universe_id = universes.id",
      :group => "universes.id", :order => "sort desc")
  end
  
  def required_permission(action)
    return self.required_permissions.find(:first, :conditions => "status = '#{self.status}' and action = '#{action}'")
  end
end
