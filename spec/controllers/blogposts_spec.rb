require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe Blogposts do


  (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob(File.join(Merb.root, 'test', 'fixtures', '*.{yml,csv}'))).each do |fixture_file|
    Fixtures.create_fixtures('test/fixtures', File.basename(fixture_file, '.*'))
  end

  before(:each) do
    @env = { :http_referer => "http://playground.pele.cx/blogposts/show"}
    Blogpost.connection.begin_db_transaction
  end

  after(:each) do
    Blogpost.connection.rollback_db_transaction
  end


  most_controllers_specs(Blogposts, { :id => 2, :blogpost => {:body_raw => ""} }, "/show/2", Blogpost, { :blogpost => {:body_raw => ""} } )

  describe "#index" do

    it "should respond correctly" do
      unauthed_action(Blogposts, :index, {}, @env).should respond_successfully
    end

    it "should render the list action" do
      unauthed_action(Blogposts, :index, {}, @env).should respond_successfully do
        self.should_receive(:render).with('list')
      end
    end
  end

  describe "#list" do

    it "should respond correctly" do
      unauthed_action(Blogposts, :list, {}, @env).should respond_successfully
    end

    it "should render the list action" do
      unauthed_action(Blogposts, :list, {}, @env).should respond_successfully do
        self.should_receive(:render).with('list')
      end
    end

    it "should get all blog posts" do
      Blogpost.should_receive(:find).with(:all,:order => 'created_on desc')
      unauthed_action(Blogposts, :list, {}, @env)
    end

  end

  describe "#show" do

    it "should respond correctly" do
      unauthed_action(Blogposts, :show, {:id => 1}, @env).should respond_successfully
    end

    it "should render the show action" do
      unauthed_action(Blogposts, :show, {:id => 1}, @env).should respond_successfully do
        self.should_receive(:render).with('show')
      end
    end

    it "should get the blog post" do
      blogpost = Blogpost.find(1)
      Blogpost.should_receive(:find).with('1').and_return(blogpost)
      unauthed_action(Blogposts, :show, {:id => 1}, @env)
    end
  end

  describe "#new" do

    it "Should not allow unauthed requests" do
      unauthed_action(Blogposts, :new, {:id => 1}, @env).should redirect_to("http://playground.pele.cx/blogposts/show")
    end

    it "should allow authenticated requests" do
      authed_action(Blogposts, :new, {:id => 1}, @env).should respond_successfully {
        self.should_receive(:render).with('new')
      }
    end
  end


end
