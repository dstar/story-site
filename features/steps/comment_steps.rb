When /^I comment on the (\d+)(?:st|nd|rd|th) paragraph/ do |paragraph_number|
#  paragraph =  xpath_search("/html/body/div[@class='full']/div[@class='paragraph'][#{paragraph_number.to_i}]")
  paragraph =  webrat.dom.xpath("/html/body/div[@class='full']/div[@class='paragraph'][#{paragraph_number.to_i}]")
#  comment_link = xpath_search("a[text()='Comment on this paragraph']",paragraph).first
  comment_link = paragraph.xpath("a[text()='Comment on this paragraph']").first
  Merb.logger.debug "QQQ28: comment_link is #{comment_link.inspect}"
  Merb.logger.debug "QQQ28: comment_link is #{comment_link.attributes}"
  @response = click_link(comment_link['id'])
end

Then /I should see "(.*)" in the (\d+)(?:st|nd|rd|th) paragraph's comment block/ do |text,paragraph_number| #'
#  paragraph = xpath_search("/html/body/div[@class='full']/div[@class='paragraph'][#{paragraph_number.to_i}]")
  paragraph = webrat.dom.xpath("/html/body/div[@class='full']/div[@class='paragraph'][#{paragraph_number.to_i}]")
#  comment_block = xpath_search("div[@class*='comments']",paragraph)
  comment_block = paragraph.xpath("div[@class*='comments']")
  comment_block.to_s.should =~ /#{text}/m
end

Then /I should not see "(.*)" in the (\d+)(?:st|nd|rd|th) paragraph's comment block/ do |text,paragraph_number| #'
#  paragraph = xpath_search("/html/body/div[@class='full']/div[@class='paragraph'][#{paragraph_number.to_i}]")
#  comment_block = xpath_search("div[@class*='comments']",paragraph)
  paragraph = webrat.dom.xpath("/html/body/div[@class='full']/div[@class='paragraph'][#{paragraph_number.to_i}]")
  comment_block = paragraph.xpath("div[@class*='comments']")
  comment_block.to_s.should_not =~ /#{text}/m
end
