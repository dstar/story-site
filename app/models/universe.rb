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
  
  def self.default_permissions
    return  { nil => {
        "destroy"             => [ "owner",],
        "update"              => [ "owner",],
        "edit"                => [ "owner",],
        "permissions"         => [ "owner",],
        "permissions_modify"  => [ "owner",],
        "permissions_destroy" => [ "owner",],
        "create_story" => [ "owner",],
        "new_story" => [ "owner",],
        "index" => [ "EVERYONE",],
        "list" => [ "EVERYONE",],
        "show" => [ "EVERYONE",],
        "story_owner_add"           => [ "owner", ],
        "story_owner_add_save"      => [ "owner", ],
        "create_universe"              => [ "admin", ],
        "new_universe"                 => [ "admin", ],
      }
    }
  end
end
