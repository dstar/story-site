# Commonly used webrat steps
# http://github.com/brynary/webrat

When /^I go to (.*)$/ do |path|
  @response = visit path
#  Merb.logger.debug "QQQ38: response is #{@response.inspect}"
  if Webrat.configuration.mode == :selenium
    begin
      selenium.wait_for_page 1
    rescue Selenium::CommandError
    end
  end
  @response = webrat.response
end

When /^I press "(.*)"$/ do |button|
  @response = click_button(button)
#  Merb.logger.debug "QQQ38: webrat.response is #{@response.inspect}"
  if Webrat.configuration.mode == :selenium
    begin
      selenium.wait_for_page 1
    rescue Selenium::CommandError
    end
  end
  @response = webrat.response
end

When /^I follow "(.*)"$/ do |link|
#  link_by_id =  have_xpath("//a[@id='#{link}']").matches?(response)
#  Merb.logger.debug "QQQQQQQQQQQQQQQQ: webrat is #{webrat.class}"
    @response = click_link(link)
#  Merb.logger.debug "QQQ38: webrat.response is #{@response.inspect}"
    if Webrat.configuration.mode == :selenium
    begin
      selenium.wait_for_page 1
    rescue Selenium::CommandError
    end
  end
  @response = webrat.response
end

When /^I fill in "(.*)" with "(.*)"$/ do |field, value|
  @response = fill_in(field, :with => value)
  if webrat.respond_to? :response
    @response = webrat.response
  end
end

When /^I fill in "(.*)" with$/ do |field, value|
  @response = fill_in(field, :with => value)
  if webrat.respond_to? :response
    @response = webrat.response
  end
end

When /^I select "(.*)" from "(.*)"$/ do |value, field|
  @response = select(value, :from => field)
  if webrat.respond_to? :response
    @response = webrat.response
  end
end

When /^I check "(.*)"$/ do |field|
  @response = check(field)
  if webrat.respond_to? :response
    @response = webrat.response
  end
end

When /^I uncheck "(.*)"$/ do |field|
  @response = uncheck(field)
  if webrat.respond_to? :response
    @response = webrat.response
  end
end

When /^I choose "(.*)"$/ do |field|
  @response = choose(field)
  if webrat.respond_to? :response
    @response = webrat.response
  end
end

When /^I attach the file at "(.*)" to "(.*)" *$/ do |path, field|
  if webrat.respond_to? 'attach_file'
    @response = attach_file(field, path)
  else
    @response = selenium.attach_file("label=#{field}","file://#{File.expand_path(path)}")
  end

  if webrat.respond_to? :response
    @response = webrat.response
  end
end
