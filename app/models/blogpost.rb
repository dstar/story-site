class Blogpost < ActiveRecord::Base

#  validates_presence_of :posted

  def self.frontpagelist
    find(:all,
      :order => 'posted_on desc',
      :limit => '10')
  end
end
