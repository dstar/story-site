Given /^I am not authenticated/ do
  @response = request("http://playground.playground.pele.cx/logout")
end

Given /^I am logged in as "(.*)" with password "(.*)"/ do |username, password|
  @response = request("http://playground.playground.pele.cx/login", :method => "PUT", :params => { :username => username, :password => password })
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

Given /^I have a beta-reader "(.*)"/ do |author|
  user = User.find_by_username!(author)
  unless user.has_site_permission("beta-reader")
    sp = SitePermission.new
    sp.permission = "beta-reader"
    sp.permission_holder = user
    sp.save
  end
end

Given /I have a story "(.*)(\d+)"/ do |story,number|
  begin
    Story.find_by_title!(story)
 rescue ActiveRecord::RecordNotFound
    s = Story.new
    s.id = 100 + number.to_i
    s.title = story + number
    s.short_title = story.split(/ /).collect { |w| w[0,1]}.join('') + number
    s.description = story
    s.file_prefix = story.gsub!(/[^0-9A-Za-z.\-_]/, '_')
    s.save
  end
  user = User.find(3)
  unless user.has_story_permission(100+number.to_i,"author")
    story_permissions=StoryPermission.new
    story_permissions.permission_holder = User.find(3)
    story_permissions.permission="author"
    story_permissions.story_id=100+number.to_i
    story_permissions.save
  end
end

Given /the story "(.*)" has a chapter with the text in the file at "(.*)"/ do |title, filename|
  story = Story.find_by_title(title)
  if story.chapters.first
    story.chapters.first.destroy
#    story.chapters.first.save
  end
  chapter = Chapter.new
  chapter.story = story
  chapter.number = 1
  chapter.file = "#{chapter.story.short_title}_#{chapter.number}.html"
  chapter.date_uploaded = Time.now.strftime('%Y-%m-%d %H:%M:%S') unless chapter.date_uploaded
  chapter.save
  chapter.process_file(File.new(filename,"r"))
end


Given /I do not have a story named "(.*)(\d+)"/ do |story,number|
  begin
    s = Story.find_by_title!(story+number)
    s.destroy
  rescue ActiveRecord::RecordNotFound
  end

  id = 100 + number.to_i
  short_title = story.split(/ /).collect { |w| w[0,1]}.join('') + number
  file_prefix = story.gsub!(/[^0-9A-Za-z.\-_]/, '_')

  s = Story.find_by_id(id)
  s.destroy if s
  s = Story.find_by_short_title(short_title)
  s.destroy if s
  s = Story.find_by_file_prefix(file_prefix)
  s.destroy if s

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
  @universe = u
end

Then /^I should see an? level (\d) header that says "(.*)"/ do |header_level,message|
#  @response.should(have_xpath("//h#{header_level}[text()='#{message}']")) || @response.should(have_xpath("//h#{header_level}/*[text()='#{message}']"))
  @response.should(have_xpath("//h#{header_level}/*[text()='#{message}']"))
end

Then /^I should see a link named "(.*)" which points to "(.*)"/ do |name,href|
  filename = href.match(/\#\{(.*)\}/)
  if filename && filename[1]
    chapter = Chapter.find_by_file(filename[1])
    href.gsub!(/\#\{(.*)\}/,chapter.id.to_s)
  end

  begin
    @response.should(have_xpath("//a[text()='#{name}'][@href='#{href}']"))
  rescue Spec::Expectations::ExpectationNotMetError
    @response.should(have_xpath("//a[@id='#{name}'][@href='#{href}']"))
  end

end

Then /^I should see comment links for "(.*)"/ do |name|

  chapter = Chapter.find_by_file(name)
  para_id = chapter.paragraphs.first.id
  @response.should(have_xpath("//a[text()='Comment on this paragraph'][@href='/pcomments/new/?paragraph_id=#{para_id}']"))

  @response.should(have_selector("a:contains('\302\266')"))

end

Then /^I should not see a link named "(.*)" which points to "(.*)"/ do |name,href|
  begin
    @response.should_not(have_xpath("//a[text()='#{name}'][@href='#{href}']"))
  rescue Spec::Expectations::ExpectationNotMetError
    @response.should_not(have_xpath("//a[@id='#{name}'][@href='#{href}']"))
  end
end

Then /^I should see an? (.*) with attribute "(.*)" set to "(.*)"/ do |tag,attribute,value|
  @response.should(have_xpath("//#{tag}[@#{attribute}='#{value}']"))
end

Then /^the (.*) ?request should succeed/ do |_|
  @response.should be_successful
end
