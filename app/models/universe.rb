class Universe < ActiveRecord::Base
  has_many :stories

  has_many :userpermissions, :as => :permissionable

end
