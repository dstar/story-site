require File.join( File.dirname(__FILE__), "..", "spec_helper" )


describe "Paragraphs" do

  before(:each) do
    @env = { :http_referer => "http://playground.pele.cx/blogposts/show",
      :http_host => "jaknis.playground.pele.cx"
    }
  end

  most_controllers_specs(Paragraphs, {:id => 2, :paragraphs => {:body_raw => " a"} }, "/chapters/show_draft/17#pcomment2", Paragraph, nil, false)

  describe "#move_comments_prev" do
    it "should not allow unauthed moves" do

      response = request("http://playground.playground.pele.cx/paragraphs/move_comments_prev/4", :method => "POST")
      response.should redirect_to("http://playground.playground.pele.cx/")

    end

    it "should allow authed moves" do
      Pcomment.find(1).paragraph.id.should == 4

      request("http://playground.playground.pele.cx/login", :method => "PUT", :params => { :username => 'dstar', :password => 'test password' })
      response = request("http://playground.playground.pele.cx/paragraphs/move_comments_prev/4", :method => "POST")
      response.should redirect_to("/chapters/show_draft/17#pcomment4")

      Pcomment.find(1).paragraph.id.should == 3
    end
  end

  describe "#move_comments_next" do
    it "should not allow unauthed moves" do
      response = request("http://playground.playground.pele.cx/paragraphs/move_comments_next/3", :method => "POST")
      response.should redirect_to("http://playground.playground.pele.cx/")

    end

    it "should allow authed moves" do
      Pcomment.find(1).paragraph.id.should == 3

      request("http://playground.playground.pele.cx/login", :method => "PUT", :params => { :username => 'dstar', :password => 'test password' })
      response = request("http://playground.playground.pele.cx/paragraphs/move_comments_next/3", :method => "POST")
      response.should redirect_to("/chapters/show_draft/17#pcomment3")

      Pcomment.find(1).paragraph.id.should == 4
    end
  end


end
