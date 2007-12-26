class Story < ActiveRecord::Base
  validates_presence_of :universe_id, :title, :short_title, :description
  validates_uniqueness_of :title, :short_title
  validates_format_of :on_release, :with => /[a-zA-Z0-9_]*/

  belongs_to :universe

  has_many :chapters

  has_many :story_permissions
  has_many :required_permissions, :as => :permissionable

  serialize :on_release
  serialize :required_permissions

  #hack, because I can't figure out a way to make has_many :authors work
  has_many :credits
  has_many :users, :through => :credits
  def authors
    self.users.collect { |u| c = Credit.find_by_user_id_and_story_id(u.user_id,self.id); u if c.credit_type == 'Author' }.compact
  end

  def self.OrderedListByUniverse(universe_id)
    find(:all,
      :select => "stories.id, title, description, sum(chapters.words) as sort, universe_id, keywords",
      :joins => "left outer join chapters on chapters.story_id = stories.id",
      :conditions => ["universe_id = ?", universe_id],
      :group => "stories.id", :order => "sort desc")
  end
  def self.OrderedList()
    find(:all,
      :select => "stories.id, title, description, sum(chapters.words) as sort, universe_id, keywords",
      :joins => "left outer join chapters on chapters.story_id = stories.id",
      :group => "stories.id", :order => "sort desc")
  end

  def required_permission(action)
    return self.required_permissions.find(:first, :conditions => "status = '#{self.status}' and action = '#{action}'")
  end
  
  def self.default_permissions
    return { 'draft' => {
        "destroy" => [ "author", ],
        "update"  => [ "author",],
        "edit"    => [ "author",],
        "expire_cache" => [ "author",],
        "owner_add_save" => [ "author",],
        "permissions_modify" => [ "author",],
        "permissions" => [ "author",],
        "new_chapter" => [ "author",],
        "create_chapter" => [ "author",],
        "permissions_destroy" => [ "author",],
        "index"    => [ "author","beta-reader"],
        "list"    => [ "author","beta-reader"],
        "show"    => [ "author","beta-reader"],
        "showByName"    => [ "author","beta-reader"],
        "showBySubD"    => [ "author","beta-reader"],
      },
      'released' => {
        "destroy" => [ "author", ],
        "update"  => [ "author",],
        "edit"    => [ "author",],
        "expire_cache" => [ "author",],
        "owner_add_save" => [ "author",],
        "permissions_modify" => [ "author",],
        "permissions" => [ "author",],
        "new_chapter" => [ "author",],
        "create_chapter" => [ "author",],
        "permissions_destroy" => [ "author",],
        "index"    => [ "EVERYONE"],
        "list"    => [ "EVERYONE"],
        "show"    => [ "EVERYONE"],
        "showByName"    => [ "EVERYONE"],
        "showBySubD"    => [ "EVERYONE"],
      } 
    }
  end
  
end
