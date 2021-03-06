class Blogpost < ActiveRecord::Base

  #  validates_presence_of

  before_save :format_body

  def self.frontpagelist
    find(:all,
      :order => 'created_on desc, id desc',
      :limit => '10')
  end

  def format_body
    self.body = "<p>" + self.body_raw.dup + "</p>"
    #    self.body.gsub!(/_(\w+)_/) { |m| m.gsub!(/_/,''); "<em>#{m}<\/em>"}
    self.body.gsub!(/_([-\\{}?*A-Za-z0-9 .,;&:`'!\/"()]+)_/) { |m| m.gsub!(/_/,''); "<em>#{m}<\/em>"}
    self.body.gsub!(/--/,"&mdash;")
    self.body.gsub!(/\r\n(\r\n+)/,"</p>\n<p>")
  end

end
