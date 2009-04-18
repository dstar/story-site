Then /^I should see "(.*)"$/ do |text|
#Merb.logger.debug "QQQ37: response is #{@response}"
  Merb.logger.debug "QQQ37: checking response"
  @response.should  contain(/#{text}/m)
  Merb.logger.debug "QQQ37: checked response"
  #  response.should  contain(/#{text}/m)
end

Then /^I should not see "(.*)"$/ do |text|
  @response.should_not contain(/#{text}/m)
end

Then /^I should see an? (\w+) message$/ do |message_type|
  @response.should have_xpath("//*[@class='#{message_type}']")
end

Then /^the (.*) ?request should fail/ do |_|
#  @response.should_not be_successful
end
