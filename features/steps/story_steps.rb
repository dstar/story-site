def get_current_chapter

  Merb.logger.debug "QQQ44: Getting current chapter"

  if webrat.respond_to? 'selenium'
    this_url = selenium.location
    Merb.logger.debug "QQQ44: selenium.location is #{selenium.location}"
  else
    this_url = current_url
  end

  path = URI.parse(this_url).path

  first_element_regexp = Regexp.new("^/(.*?)/")
  last_element_regexp = Regexp.new("/([^/]*?)$")

  first_element = path.match(first_element_regexp)[1]
  last_element = path.match(last_element_regexp)[1]

  Merb.logger.debug "QQQ44: Url is #{this_url}, first element is #{first_element}, last element is #{last_element}"
  if first_element.match(/stories/)
    Merb.logger.debug "QQQ44: doing Story.find(#{last_element}).chapters.last"
    Story.find(last_element).chapters.last
  else
    if last_element.match(/\./)
      Merb.logger.debug "QQQ46: doing Chapter.find_by_file(#{last_element}), resulting in #{Chapter.find_by_file(last_element)}"
      Chapter.find_by_file(last_element)
    else
      Merb.logger.debug "QQQ46: doing Chapter.find(#{last_element}), resulting in #{Chapter.find(last_element)}"
      Chapter.find(last_element)
    end
  end
end

Then /I should see "(.*)" in the (\d+)(?:st|nd|rd|th) paragraph's text/ do |text,paragraph_number| #'
  if webrat.respond_to? 'selenium'
    Merb.logger.debug "QQQ45: current_url is: #{webrat.method(:selenium)}"
  end
  chapter = get_current_chapter
  Merb.logger.debug "QQQ46: chapter is #{chapter.inspect}"
  paragraph_id = chapter.paragraphs[paragraph_number.to_i - 1].id
  p_xpath = "//div[@id='parabody#{paragraph_id}']/p[contains(text(),'#{text}')]"
  @response.should(have_xpath(p_xpath))
end

Then /I should not see "(.*)" in the (\d+)(?:st|nd|rd|th) paragraph's text/ do |text,paragraph_number| #'
  paragraph_id = get_current_chapter.paragraphs[paragraph_number.to_i - 1].id
  p_xpath = "//div[@id='parabody#{paragraph_id}']/p[contains(text(),'#{text}')]"
  @response.should_not(have_xpath(p_xpath))
end

Then /I should see a link to the chapter I just uploaded/ do
  current_chapter = get_current_chapter
  @response.should(have_xpath("//a[text()='Part #{current_chapter.number}'][@href='/html/TS2_#{current_chapter.number}.html']"))
end

Then /I should see a draft link to the chapter I just uploaded/ do
  current_chapter = get_current_chapter
  @response.should(have_xpath("//a[@id='chapter_#{current_chapter.number}_draft'][@href='/chapters/show_draft/#{current_chapter.id}']"))
end

When /I follow the (.*) link to the chapter I just uploaded/ do |link_type|
  current_chapter = get_current_chapter
  case link_type
    when "reading": Then %Q|I follow "Part #{current_chapter.number}"|
    when "draft"  : Then %Q|I follow "chapter_#{current_chapter.number}_draft"|
  end
end

Then /^"([^\"]*)" in the (\d+)(?:st|nd|rd|th) paragraph's text should be (.*)$/ do |text,paragraph_number,markup_id|#'
  tag = case markup_id
          when "bolded": "b"
          when "bolded": "b"
        end
  paragraph_id = get_current_chapter.paragraphs[paragraph_number.to_i - 1].id
  p_xpath = "//div[@id='parabody#{paragraph_id}']/p//#{tag}[contains(text(),'#{text}')]"
  @response.should(have_xpath(p_xpath))
end
