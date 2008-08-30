require File.join( File.dirname(__FILE__), "..", "spec_helper" )


describe "Users" do

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
      unauthed_action(Users, :show, {:id => 3}, @env).should respond_successfully
    end

    it "should render the show action" do
      unauthed_action(Users, :show, {:id => 3}, @env).should respond_successfully do
        self.should_receive(:render).with('show')
      end
    end

    it "should get the users" do
      user = User.find(3)
      unauthed_action(Users, :show, {:id => 3}, @env) { |c|
        c.user.should_equal user
      }
    end
  end

end
