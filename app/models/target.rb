class Target < ActiveRecord::Base
    def self.OrderedList()
      find(:all, :order => "year, month asc")
    end
end
