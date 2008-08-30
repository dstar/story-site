require File.join( File.dirname(__FILE__), "..", "spec_helper" )


describe "Stories" do

  (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob(File.join(Merb.root, 'test', 'fixtures', '*.{yml,csv}'))).each do |fixture_file|
    Fixtures.create_fixtures('test/fixtures', File.basename(fixture_file, '.*'))
  end

  before(:each) do
    @env = { :http_referer => "http://playground.pele.cx/blogposts/show",
      :http_host => "jaknis.playground.pele.cx"
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
      unauthed_action(Stories, :show, {:id => 1}, @env).should respond_successfully
    end

    it "should render the show action" do
      unauthed_action(Stories, :show, {:id => 1}, @env).should respond_successfully do
        self.should_receive(:render).with('show')
      end
    end

    it "should get the story" do
      story = Story.find(1)
      Story.should_receive(:find).with('1').and_return(story)
      unauthed_action(Stories, :show, {:id => 1}, @env)
    end
  end

  most_controllers_specs(Stories, {:id => 1, :story => {:universe_id => 1, :title => 'a', :short_title => 'a', :description => 'a'} }, "/stories/show/1", Story, nil, false)

end
