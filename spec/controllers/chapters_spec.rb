require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe "Chapter" do

  before(:each) do
    @authed_env = { :http_referer => "http://test.pele.cx/blogposts/show",
      :http_host => "jaknis.test.pele.cx",
      :jar => { :phpbb2mysql_sid => "" }
    }
    @unauthed_env = { :http_referer => "http://test.pele.cx/blogposts/show",
      :http_host => "jaknis.test.pele.cx",
      :jar => { :phpbb2mysql_sid => "test" }
    }
  end

  describe "#show" do
    response = nil
    it "should respond correctly" do
      response = request("http://playground.test.pele.cx/chapters/show/17")
      response.should be_successful
    end

    it "should have paragraphs" do
      response.should have_xpath("//div[@class='paragraph']")
    end

    it "should not allow unauthed access to draft chapters" do
       request("http://jaknis.test.pele.cx/chapters/show_draft/105").should redirect_to("http://playground.test.pele.cx/")
   end

    it "should allow authed access to draft chapters" do
      request("http://jaknis.test.pele.cx/login", :method => "PUT", :params => { :username => 'dstar', :password => 'test password' }).should redirect
      request("http://jaknis.test.pele.cx/chapters/show/105").should respond_successfully
    end

  end

  describe "#show_draft" do

    it "should not allow unauthed access" do
#      unauthed_action(Chapters, :show, {:id => 105}, @env).should redirect_to("http://test.pele.cx/blogposts/show")
       request("http://jaknis.test.pele.cx/chapters/show_draft/105").should redirect_to("http://playground.test.pele.cx/")
    end

    it "should allow authed access" do
      request("http://jaknis.test.pele.cx/login", :method => "PUT", :params => { :username => 'dstar', :password => 'test password' }).should redirect
      request("http://jaknis.test.pele.cx/chapters/show_draft/105").should respond_successfully
#      authed_action(Chapters, :show, {:id => 105}, @env).should respond_successfully do
#        self.should_recieve(:render).with('show_draft')
#      end
    end
  end

end
