Given /I am logged in as "(.*)" with password "(.*)"/ do |username, password|
  response = request("http://playground.playground.pele.cx/login", :method => "PUT", :params => { :username => 'dstar', :password => 'test password' })
  Merb.logger.debug "QQQ22: Response is #{response.inspect}"
  response = request("http://playground.playground.pele.cx/")
  Merb.logger.debug "QQQ23: Response is #{response.inspect}"
end

Then /^I should see an? level (\d) header that says "(.*)"/ do |header_level,message|
  response.should have_xpath("//h#{header_level}[text()='#{message}']")
end

Then /^the (.*) ?request should succeed/ do |_|
response.should be_successful
end
