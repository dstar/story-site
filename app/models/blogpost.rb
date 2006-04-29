class Blogpost < ActiveRecord::Base
  def self.frontpagelist
    find(:all,
      :order => 'posted desc',
      :limit => '10')
  end
end
