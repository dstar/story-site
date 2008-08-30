require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe "Site" do

  (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob(File.join(Merb.root, 'test', 'fixtures', '*.{yml,csv}'))).each do |fixture_file|
    Fixtures.create_fixtures('test/fixtures', File.basename(fixture_file, '.*'))
  end

  before(:each) do
    @env = { :http_referer => "http://playground.pele.cx/blogposts/show",
      :http_host => "jaknis.playground.pele.cx"
    }
  end

  describe "#new_universe" do
    it "should not allow unauthed new" do
      unauthed_action(Site, :new_universe, { }, @env).should redirect_to("http://playground.pele.cx/blogposts/show")
    end

    it "should allow authed new" do
      authed_action(Site, :new_universe, { }, @env).should respond_successfully
    end
  end

  describe "#create_universe" do

    def self.use_transactional_fixtures
      true
    end

    it "should not allow unauthed creates" do
      lambda { unauthed_action(Site, :create_universe, {:universe => { :name => "test", :description => "test"} }, @env)}.should_not change(Universe, :count)
    end

    it "should allow authed creates" do
      lambda { authed_action(Site, :create_universe, {:universe => { :name => "test", :description => "test"} }, @env)}.should change(Universe, :count)
    end
  end

  describe "#universe_add_owner" do
    it "should not allow unauthed owner additions" do
      unauthed_action(Site, :universe_add_owner, {:id => 1 }, @env).should redirect_to("http://playground.pele.cx/blogposts/show")
    end

    it "should allow authed owner additions" do
      authed_action(Site, :universe_add_owner, {:id => 1 }, @env).should respond_successfully
    end
  end

  describe "#universe_owner_add_save" do
    it "should not allow unauthed owner addition saves" do
      unauthed_action(Site, :universe_owner_add_save, {:universe_id => 1, :type => 'user', :permission_holder => "Velvet Wood", :permission => "test" }, @env).should redirect_to("http://playground.pele.cx/blogposts/show")
    end

    it "should allow authed owner addition saves" do
      authed_action(Site, :universe_owner_add_save, {:universe_id => 1, :type => 'user', :permission_holder => "Velvet Wood", :permission => "test" }, @env).should respond_successfully
    end
  end

  describe "#expire_cache" do
    it "should not allow unauthed expires" do
      unauthed_action(Site, :expire_cache, {}, @env).should redirect_to("http://playground.pele.cx/blogposts/show")
    end

    it "should allow authed expires" do
      authed_action(Site, :expire_cache, {}, @env).should redirect_to("http://jaknis.playground.pele.cx/")
    end
  end


end
