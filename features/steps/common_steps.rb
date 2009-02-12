Given /^I am unauthenticated/ do
  @response = request("http://playground.playground.pele.cx/logout")
end

Given /^I am logged in as "(.*)" with password "(.*)"/ do |username, password|
  @response = request("http://playground.playground.pele.cx/login", :method => "PUT", :params => { :username => 'dstar', :password => 'test password' })
end

Given /^I have an author "(.*)"/ do |author|
  Merb.logger.debug "QQQ24: Finding 'author'"
  user = User.find_by_username!(author)
  Merb.logger.debug "QQQ24: Author is #{user.inspect}"
  Merb.logger.debug "QQQ24: Checking for permission"
  unless user.has_site_permission("author")
    Merb.logger.debug "QQQ24: #{user.username} does not have author permission, attempting to create."
    sp = SitePermission.new
    sp.permission = "author"
    sp.permission_holder = user
    sp.save
    Merb.logger.debug "QQQ24: Created permission, author permissions are #{user.site_permissions}"
  end
end

Given /I have a story "(.*)"/ do |story|
  begin
    Story.find_by_title!(story)
 rescue ActiveRecord::RecordNotFound
   s = Story.new
   s.id = 100
   s.title = story
   s.short_title = story
   s.description = story
   s.file_prefix = story
   s.save
  end
end

Given /I do not have a story named "(.*)"/ do |story|
  begin
    s = Story.find_by_title!(story)
    s.destroy
  rescue ActiveRecord::RecordNotFound
  end
end


Given /I have a universe "(.*)"/ do |universe|
  Merb.logger.debug "QQQ22: Attempting to ensure universe #{universe} exists"
  begin
    u = Universe.find_by_name!(universe)
    Merb.logger.debug "QQQ22: Found universe. Details: #{u.inspect}"
  rescue ActiveRecord::RecordNotFound
    Merb.logger.debug "QQQ22: Did not find universe. Attempting to create."
    u = Universe.new
    u.id = 100
    u.name = universe
    u.description = universe
    u.save

    universe_permissions=UniversePermission.new
    universe_permissions.permission_holder = User.find(3)
    universe_permissions.permission="owner"
    universe_permissions.universe_id=100
    universe_permissions.save

#    up_test = UniversePermissions.find(universe_permissions.id)
#    puts "QQQ22: saved permission ID is #{universe_permissions.id}, permission is #{up_test.inspect} "

  end
end

Then /^I should see an? level (\d) header that says "(.*)"/ do |header_level,message|
#  @response.should(have_xpath("//h#{header_level}[text()='#{message}']")) || @response.should(have_xpath("//h#{header_level}/*[text()='#{message}']"))
  @response.should(have_xpath("//h#{header_level}/*[text()='#{message}']"))
end

Then /^I should see a link named "(.*)" which points to "(.*)"/ do |name,href|
  @response.should(have_xpath("//a[text()='#{name}']"))
  @response.should(have_xpath("//a[@href='#{href}']"))
end

Then /^I should see an? (.*) with attribute "(.*)" set to "(.*)"/ do |tag,attribute,value|
  @response.should(have_xpath("//#{tag}[@#{attribute}='#{value}']"))
end

Then /^the (.*) ?request should succeed/ do |_|
  @response.should be_successful
end
