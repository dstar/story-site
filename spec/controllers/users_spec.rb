require File.join( File.dirname(__FILE__), "..", "spec_helper" )


describe "Users" do

  (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob(File.join(Merb.root, 'test', 'fixtures', '*.{yml,csv}'))).each do |fixture_file|
    Fixtures.create_fixtures('test/fixtures', File.basename(fixture_file, '.*'))
  end

  before(:each) do
    @env = { :http_referer => "http://test.pele.cx/blogposts/show",
      :http_host => "jaknis.test.pele.cx"
    }
  end

  describe "#show" do

    it "should respond correctly" do
      response = unauthed_action(Users, :show, 3)
      response.should respond_successfully
      response.should have_xpath("//p[text()='Username: dstar ']")
    end
  end
end
