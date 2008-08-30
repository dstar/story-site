require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe "Chapter" do

  before(:each) do
    @env = { :http_referer => "http://playground.pele.cx/blogposts/show",
      :http_host => "jaknis.playground.pele.cx"
    }
  end

  it "should have working routes"

  it "should have view specs"

  describe "#show" do
    it "should respond correctly" do
      unauthed_action(Chapters, :show, {:id => 1}, @env).should respond_successfully
    end

    it "should render the show action" do
      unauthed_action(Chapters, :show, {:id => 1}, @env).should respond_successfully do
        self.should_receive(:render).with('show')
      end
    end

    it "should not allow unauthed access to draft chapters" do
      unauthed_action(Chapters, :show, {:id => 105}, @env).should redirect_to("http://playground.pele.cx/blogposts/show")
    end
  end

  describe "#show_draft" do

    it "should not allow unauthed access" do
      unauthed_action(Chapters, :show, {:id => 105}, @env).should redirect_to("http://playground.pele.cx/blogposts/show")
    end

    it "should allow authed access" do
      authed_action(Chapters, :show, {:id => 105}, @env).should respond_successfully do
        self.should_recieve(:render).with('show_draft')
      end
    end
  end

end
