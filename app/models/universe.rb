class Universe < ActiveRecord::Base
  has_many :stories

  has_many :universe_permissions

end
