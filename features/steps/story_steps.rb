def get_current_chapter
  if webrat.respond_to? 'selenium'
    story_id = selenium.location.gsub(/.*\//,'')
  else
    story_id = current_url.gsub(/.*\//,'')
  end
  Story.find(story_id).chapters.last
end

Then /I should see "(.*)" in the (\d+)(?:st|nd|rd|th) paragraph's text/ do |text,paragraph_number| #'
  if webrat.respond_to? 'selenium'
    chapter_id = selenium.location.gsub(/.*\//,'')
    paragraph_id = Chapter.find(chapter_id).paragraphs[paragraph_number.to_i - 1].id
    p_xpath = "//div[@id='parabody#{paragraph_id}']/p[contains(text(),'#{text}')]"
    Merb.logger.debug "QQQ42: xpath is #{p_xpath}"
    @response.should(have_xpath(p_xpath))

#    paragraph = selenium.text("xpath=//div[@id='parabody#{paragraph_id}']")
  else
    paragraph = webrat.dom.xpath("/html/body/div[@class='full']/div[@class='paragraph'][#{paragraph_number.to_i}]")
    paragraph.to_s.should =~ /#{text}/m
  end
end

Then /I should not see "(.*)" in the (\d+)(?:st|nd|rd|th) paragraph's text/ do |text,paragraph_number| #'
  if webrat.respond_to? 'selenium'
    chapter_id = selenium.location.gsub(/.*\//,'')
    paragraph_id = Chapter.find(chapter_id).paragraphs[paragraph_number.to_i - 1].id
    p_xpath = "//div[@id='parabody#{paragraph_id}']/p[contains(text(),'#{text}')]"
    Merb.logger.debug "QQQ42: xpath is #{p_xpath}"
    @response.should_not(have_xpath(p_xpath))
  else
    paragraph = webrat.dom.xpath("/html/body/div[@class='full']/div[@class='paragraph'][#{paragraph_number.to_i}]")
    paragraph.to_s.should_not =~ /#{text}/m
  end
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
