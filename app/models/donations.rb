class Donations < ActiveRecord::Base
  def self.donations_for(year,month)
    month_start = DateTime.new(year,month)
    next_month = month+1
    year = year + 1 if next_month == 13
    next_month = 1 if next_month == 13
    month_end = DateTime.new(year,next_month,1,12,59,59) - 1
    donations = Donations.find(:all, :conditions => "donation_date between '#{month_start}' and '#{month_end}'")
  end
end
