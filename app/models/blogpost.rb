class Blogpost < ActiveRecord::Base

  validates_presence_of :posted

  def self.frontpagelist
    find(:all,
      :order => 'posted desc',
      :limit => '10')
  end
end
