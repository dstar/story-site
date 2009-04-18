When /^I comment on the (\d+)(?:st|nd|rd|th) paragraph/ do |paragraph_number|
  if webrat.respond_to? 'selenium'
    Merb.logger.debug "QQQ40: In selenium"
    begin
      selenium.click("xpath=/html/body/div[@class='full']/div[@class='paragraph'][#{paragraph_number.to_i}]/div[2]/div/p/a[text()='Comment on this paragraph']")
      selenium.wait_for_page 10
    rescue Selenium::CommandError
    end
    @response = webrat.response
  else
    paragraph =  webrat.dom.xpath("/html/body/div[@class='full']/div[@class='paragraph'][#{paragraph_number.to_i}]")
    comment_link = paragraph.xpath("a[text()='Comment on this paragraph']").first
    @response = click_link(comment_link['id'])
  end

end

Then /I should see "(.*)" in the (\d+)(?:st|nd|rd|th) paragraph's comment block/ do |text,paragraph_number| #'
  if webrat.respond_to? 'selenium'
#    comment_block =selenium.text("xpath=/html/body/div[@class='full']/div[@class='paragraph'][#{paragraph_number.to_i}]/div[@class*='comments']")
    comment_block =selenium.text("xpath=/html/body/div[@class='full']/div[@class='paragraph'][#{paragraph_number.to_i}]/div[contains(@class,'comments')]")
  else
    paragraph = webrat.dom.xpath("/html/body/div[@class='full']/div[@class='paragraph'][#{paragraph_number.to_i}]")
    comment_block = paragraph.xpath("div[@class*='comments']")
  end
  comment_block.to_s.should =~ /#{text}/m
end


Then /I should not see "(.*)" in the (\d+)(?:st|nd|rd|th) paragraph's comment block/ do |text,paragraph_number| #'
  if webrat.respond_to? 'selenium'
#    comment_block =selenium.text("xpath=/html/body/div[@class='full']/div[@class='paragraph'][#{paragraph_number.to_i}]/div[@class*='comments']")
    comment_block =selenium.text("xpath=/html/body/div[@class='full']/div[@class='paragraph'][#{paragraph_number.to_i}]/div[contains(@class,'comments')]")
  else
    paragraph = webrat.dom.xpath("/html/body/div[@class='full']/div[@class='paragraph'][#{paragraph_number.to_i}]")
    comment_block = paragraph.xpath("div[@class*='comments']")
  end
  comment_block.to_s.should_not =~ /#{text}/m
end

Then /^I should see a comment link for the (\d+)(?:st|nd|rd|th) paragraph/ do |paragraph_number|
  @response.should(have_xpath("/html/body/div[@class='full']/div[@class='paragraph'][#{paragraph_number.to_i}]/descendant::a[text()='Comment on this paragraph']"))
#  @response.should(have_xpath("/html/body/div[@class='full']/div[@class='paragraph'][#{paragraph_number.to_i}]/div[2]/div/p/a[text()='Comment on this paragraph']"))
end
