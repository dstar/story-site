require File.join( File.dirname(__FILE__), "..", "spec_helper" )


describe "Universes" do

  (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob(File.join(Merb.root, 'test', 'fixtures', '*.{yml,csv}'))).each do |fixture_file|
    Fixtures.create_fixtures('test/fixtures', File.basename(fixture_file, '.*'))
  end

  before(:each) do
    @env = { :http_referer => "http://playground.pele.cx/blogposts/show",
      :http_host => "jaknis.playground.pele.cx"
    }
  end

  describe "#show" do

    it "should respond correctly" do
      unauthed_action(Universes, :show, 1).should respond_successfully
    end

    it "should render the show action" do
      story_count = Universe.find(1).stories.length
      response = unauthed_action(Universes, :show, 1)
      response.should have_xpath("//li[position()='#{story_count}']")
    end
  end

  most_controllers_specs(Universes, {:id => 1, :universe => {:name => 'a', :description => 'a'} }, "/universes/show/1", Universe, nil, false)

end
