require File.join( File.dirname(__FILE__), "..", "spec_helper" )


describe "Stories" do

  (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob(File.join(Merb.root, 'test', 'fixtures', '*.{yml,csv}'))).each do |fixture_file|
    Fixtures.create_fixtures('test/fixtures', File.basename(fixture_file, '.*'))
  end

  before(:each) do
    @env = { :http_referer => "http://test.pele.cx/blogposts/show",
      :http_host => "jaknis.test.pele.cx"
    }
    begin
      Story.find(1)
      story_permissions=StoryPermission.new
      story_permissions.permission_holder = User.find(3)
      story_permissions.permission='author'
      story_permissions.story_id=1
      story_permissions.save
    rescue ActiveRecord::RecordNotFound
    end

  end

  describe "#show" do

    it "should respond correctly" do
      response = request("http://playground.test.pele.cx/stories/show/7", :method => "GET")
      response.should have_xpath("//h1[text()='Jason and Kylie, Naked in School Web Archive']")
    end

    it "should should have a link for each chapter in the story" do
      num_chapters = Story.find(7).chapters.length
      response = request("http://playground.test.pele.cx/stories/show/7", :method => "GET")
      response.should have_xpath("//div[@class='chaptercolumn']/a[position()=#{num_chapters}]")
    end
  end

  most_controllers_specs(Stories, {:id => 1, :story => {:universe_id => 1, :title => 'a', :short_title => 'a', :description => 'a'} }, "/stories/show/1", Story, nil, false)

end
