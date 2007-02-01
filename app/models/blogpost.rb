class Blogpost < ActiveRecord::Base

#  validates_presence_of :posted

  def self.frontpagelist
    find(:all,
      :order => 'created_on desc, id asc', 
      :limit => '10')
  end
end
