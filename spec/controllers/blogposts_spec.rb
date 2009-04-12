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

  describe "#show" do

    it "should respond correctly" do
      response = request("http://playground.playground.pele.cx/blogposts/show/1", :method => "GET")
      response.should be_successful
#      Merb.logger.debug "QQQ17: #{response.body.inspect}"
      response.should have_xpath("//div[@id='entry1'][@class='news']")

    end
  end

  describe "#index" do

    response = nil

    it "should respond correctly" do
      response = request("http://playground.playground.pele.cx/blogposts/index/", :method => "GET")
      response.should be_successful
    end

    it "should render the list view" do
      response.should have_xpath("//h1[text()='Listing blogposts']")
    end
  end

  describe "#list" do

    it "should respond correctly" do
      response = request("http://playground.playground.pele.cx/blogposts/list/", :method => "GET")
      response.should be_successful
      response.should have_xpath("//h1[text()='Listing blogposts']")

    end

  end


  #    it "should render the show view" do
  #      response.should have_xpath("//div#entry1[@class='news']")
  #    end

describe "#new" do

  it "Should not allow unauthed requests" do
    response = request("http://playground.playground.pele.cx/blogposts/new/", :method => "GET")
    response.should redirect_to("http://playground.playground.pele.cx/")
  end

  it "should allow authenticated requests" do
    request("http://playground.playground.pele.cx/login", :method => "PUT", :params => { :username => 'dstar', :password => 'test password' })
    response = request("http://playground.playground.pele.cx/blogposts/new/", :method => "GET")
    response.should be_successful
  end
end


end
