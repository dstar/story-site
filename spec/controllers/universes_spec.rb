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
      unauthed_action(Universes, :show, {:id => 1}, @env).should respond_successfully
    end

    it "should render the show action" do
      unauthed_action(Universes, :show, {:id => 1}, @env).should respond_successfully do
        self.should_receive(:render).with('show')
      end
    end

    it "should get the universes" do
      universe = Universe.find(1)
      Universe.should_receive(:find).with('1').at_least(1).and_return(universe)
      unauthed_action(Universes, :show, {:id => 1}, @env)
    end
  end

  most_controllers_specs(Universes, {:id => 1, :universe => {:name => 'a', :description => 'a'} }, "/universes/show/1", Universe, nil, false)

end
