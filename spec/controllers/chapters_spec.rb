require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe "Chapter" do

  before(:each) do
    @authed_env = { :http_referer => "http://playground.pele.cx/blogposts/show",
      :http_host => "jaknis.playground.pele.cx",
      :jar => { :phpbb2mysql_sid => "" }
    }
    @unauthed_env = { :http_referer => "http://playground.pele.cx/blogposts/show",
      :http_host => "jaknis.playground.pele.cx",
      :jar => { :phpbb2mysql_sid => "test" }
    }
  end

  it "should have view specs"

  describe "#show" do
    response = nil
    it "should respond correctly" do
      response = request("http://playground.playground.pele.cx/chapters/show/17")
      response.should be_successful
    end

    it "should have paragraphs" do
      response.should have_xpath("//div[@class='paragraph']")
    end

    it "should not allow unauthed access to draft chapters" do
       request("http://jaknis.playground.pele.cx/chapters/show_draft/105").should redirect_to("http://playground.playground.pele.cx/")
   end

    it "should allow authed access to draft chapters" do
      request("http://jaknis.playground.pele.cx/login", :method => "PUT", :params => { :username => 'dstar', :password => 'test password' }).should redirect
      request("http://jaknis.playground.pele.cx/chapters/show/105").should respond_successfully
    end

  end

  describe "#show_draft" do

    it "should not allow unauthed access" do
#      unauthed_action(Chapters, :show, {:id => 105}, @env).should redirect_to("http://playground.pele.cx/blogposts/show")
       request("http://jaknis.playground.pele.cx/chapters/show_draft/105").should redirect_to("http://playground.playground.pele.cx/")
    end

    it "should allow authed access" do
      request("http://jaknis.playground.pele.cx/login", :method => "PUT", :params => { :username => 'dstar', :password => 'test password' }).should redirect
      request("http://jaknis.playground.pele.cx/chapters/show_draft/105").should respond_successfully
#      authed_action(Chapters, :show, {:id => 105}, @env).should respond_successfully do
#        self.should_recieve(:render).with('show_draft')
#      end
    end
  end

end
