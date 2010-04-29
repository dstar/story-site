require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe "Site" do

   (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob(File.join(Merb.root, 'test', 'fixtures', '*.{yml,csv}'))).each do |fixture_file|
    Fixtures.create_fixtures('test/fixtures', File.basename(fixture_file, '.*'))
  end

  before(:each) do
    @env = { :http_referer => "http://test.pele.cx/blogposts/show",
      :http_host => "jaknis.test.pele.cx"
    }
  end

  describe "#show" do
    it "should allow unauthed requests" do
      request("http://playground.test.pele.cx/logout", :method => "GET")
      response = request("http://playground.test.pele.cx/", :method => "GET")
      response.should be_successful
    end

    it "should allow unauthed requests" do
      request("http://playground.test.pele.cx/login", :method => "PUT", :params => { :username => 'dstar', :password => 'test password' })
      response = request("http://playground.test.pele.cx/", :method => "GET")
      response.should be_successful
    end

    it "should respond correctly" do
      response = request("http://playground.test.pele.cx/", :method => "GET")
      response.should have_xpath("//a[@href='http://jaknis.test.pele.cx/']")
    end

  end

  describe "#new_universe" do

    it "Should not allow unauthed requests" do
      response = request("http://playground.test.pele.cx/site/new_universe/", :method => "GET")
      response.should redirect_to("http://playground.test.pele.cx/")
    end

    it "should allow authenticated requests" do
      request("http://playground.test.pele.cx/login", :method => "PUT", :params => { :username => 'dstar', :password => 'test password' })
      response = request("http://playground.test.pele.cx/site/new_universe/", :method => "GET")
      response.should be_successful
    end
  end

  describe "#create_universe" do

    def self.use_transactional_fixturesfreedos emm386
      true
    end

    it "should not allow unauthed creates" do
      request("http://playground.test.pele.cx/logout", :method => "GET")
      lambda { request("http://playground.test.pele.cx/site/create_universe/", :method => "POST", :params => {:universe => { :name => "test", :description => "test"}})}.should_not change(Universe,:count)
    end

    it "should allow authed creates" do
      request("http://playground.test.pele.cx/login", :method => "PUT", :params => { :username => 'dstar', :password => 'test password' })
      lambda { request("http://playground.test.pele.cx/site/create_universe/", :method => "POST", :params => {:universe => { :name => "test", :description => "test"}}) }.should change(Universe,:count)
    end
  end

  describe "#universe_add_owner" do
    it "should not allow unauthed owner additions" do
      unauthed_action("site", :universe_add_owner, 1, "GET").should redirect_to("http://playground.test.pele.cx/")
    end

    it "should allow authed owner additions" do
      authed_action("site", :universe_add_owner, 1, "GET").should respond_successfully
    end
  end

  describe "#universe_owner_add_save" do
    it "should not allow unauthed owner addition saves" do
      unauthed_action("site", :universe_owner_add_save, nil, "POST",  {:universe_id => 1, :type => 'user', :permission_holder => "Velvet Wood", :permission => "test" }).should redirect_to("http://playground.test.pele.cx/")
    end

    it "should allow authed owner addition saves" do
      authed_action("site", :universe_owner_add_save, nil, "POST", {:universe_id => 1, :type => 'user', :permission_holder => "Velvet Wood", :permission => "test" }).should redirect_to("/universes/permissions/1")
    end
  end

  describe "#expire_cache" do

    it "should not allow unauthed expires" do
      Merb::Cache[:default].fetch("expire_test") do
        "testing"
      end
      Merb::Cache[:default].read("expire_test").should_not be_nil
      unauthed_action("site", :expire_cache, nil).should redirect_to("http://playground.test.pele.cx/")
      Merb::Cache[:default].read("expire_test").should_not be_nil
    end

    it "should allow authed expires" do
      Merb::Cache[:default].fetch("expire_test") do
        "testing"
      end
      Merb::Cache[:default].read("expire_test").should_not be_nil
      authed_action("site", :expire_cache, nil).should redirect_to("http://playground.test.pele.cx/")
      Merb::Cache[:default].read("expire_test").should be_nil
    end
  end
end
