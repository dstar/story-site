class InitializeReadBy < ActiveRecord::Migration
  require "#{RAILS_ROOT}/app/models/pcomment.rb"
  def self.up
	Pcomment.find_all.each {|p| p.read_by = Array.new; p.save }
  end

  def self.down
  end
end
