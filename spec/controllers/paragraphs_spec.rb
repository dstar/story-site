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
      unauthed_action(Paragraphs, :move_comments_prev, {:id=>4},@env).should redirect_to("http://playground.pele.cx/blogposts/show")

    end

    it "should allow authed moves" do
      Pcomment.find(1).paragraph.id.should == 4
      authed_action(Paragraphs, :move_comments_prev, {:id => 4},@env).should redirect_to("/chapters/show_draft/17#pcomment4")
      Pcomment.find(1).paragraph.id.should == 3
    end
  end

  describe "#move_comments_next" do
    it "should not allow unauthed moves" do
      unauthed_action(Paragraphs, :move_comments_next, {:id=>3},@env).should redirect_to("http://playground.pele.cx/blogposts/show")

    end

    it "should allow authed moves" do
      Pcomment.find(1).paragraph.id.should == 3
      authed_action(Paragraphs, :move_comments_next, {:id => 3},@env).should redirect_to("/chapters/show_draft/17#pcomment3")
      Pcomment.find(1).paragraph.id.should == 4
    end
  end


end
