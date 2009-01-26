require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe "Pcomments" do

   (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob(File.join(Merb.root, 'test', 'fixtures', '*.{yml,csv}'))).each do |fixture_file|
    Fixtures.create_fixtures('test/fixtures', File.basename(fixture_file, '.*'))
  end

  before(:each) do
    @env = { :http_referer => "http://playground.pele.cx/blogposts/show",
      :http_host => "jaknis.playground.pele.cx"
    }
  end

  most_controllers_specs(Pcomments, {:id => 8, :pcomment => {:body_raw => " a"} }, "/chapters/show_draft/17#pcomment5", Pcomment,{ :pcomment => {:body_raw => "test", :paragraph_id => 4} })

  describe "#move_prev" do
    it "should not allow unauthed moves" do
      response = request("http://playground.playground.pele.cx/pcomments/move_prev/1", :method => "POST")
      response.should redirect_to("http://playground.playground.pele.cx/")

    end

    it "should allow authed moves" do
      Pcomment.find(1).paragraph.id.should == 4

      request("http://playground.playground.pele.cx/login", :method => "PUT", :params => { :username => 'dstar', :password => 'test password' })
      response = request("http://playground.playground.pele.cx/pcomments/move_prev/1", :method => "POST")
      response.should redirect_to("/chapters/show_draft/17#pcomment3")

      Pcomment.find(1).paragraph.id.should == 3
    end
  end

  describe "#move_next" do
    it "should not allow unauthed moves" do
      response = request("http://playground.playground.pele.cx/pcomments/move_next/1", :method => "POST")
      response.should redirect_to("http://playground.playground.pele.cx/")

    end

    it "should allow authed moves" do
      Pcomment.find(1).paragraph.id.should == 3

      request("http://playground.playground.pele.cx/login", :method => "PUT", :params => { :username => 'dstar', :password => 'test password' })
      response = request("http://playground.playground.pele.cx/pcomments/move_next/1", :method => "POST")
      response.should redirect_to("/chapters/show_draft/17#pcomment4")

      Pcomment.find(1).paragraph.id.should == 4
    end
  end

  describe "#mark_unread" do
    it "should not allow unauthed marks" do
      response = request("http://playground.playground.pele.cx/pcomments/markread/1", :method => "POST")
      response.should redirect_to("http://playground.playground.pele.cx/")
    end

    it "should allow authed marks" do
      user = User.find(3)
      Pcomment.find(1).readers.include?(user).should be_true

      request("http://playground.playground.pele.cx/login", :method => "PUT", :params => { :username => 'dstar', :password => 'test password' })
      response = request("http://playground.playground.pele.cx/pcomments/markunread/1", :method => "POST")
      response.should redirect_to("/chapters/show_draft/17#pcomment4")

      Pcomment.find(1).readers.include?(user).should be_false
    end
  end

  describe "#markread" do
    it "should not allow unauthed marks" do
      response = request("http://playground.playground.pele.cx/pcomments/markunread/1", :method => "POST")
      response.should redirect_to("http://playground.playground.pele.cx/")
    end

    it "should allow authed marks" do
      user = User.find(3)
      Pcomment.find(1).readers.include?(user).should be_false

      request("http://playground.playground.pele.cx/login", :method => "PUT", :params => { :username => 'dstar', :password => 'test password' })
      response = request("http://playground.playground.pele.cx/pcomments/markread/1", :method => "POST")
      response.should redirect_to("/chapters/show_draft/17#pcomment4")


      Pcomment.find(1).readers.include?(user).should be_true
    end
  end

  describe "#acknowledge" do
    it "should not allow unauthed acknowledgement" do
      response = request("http://playground.playground.pele.cx/pcomments/acknowledge/1", :method => "POST")
      response.should redirect_to("http://playground.playground.pele.cx/")
    end

    it "should allow authed acknowledgement" do
      Pcomment.find(1).acknowledged.should be_nil

      request("http://playground.playground.pele.cx/login", :method => "PUT", :params => { :username => 'dstar', :password => 'test password' })
      response = request("http://playground.playground.pele.cx/pcomments/acknowledge/1", :method => "POST")
      response.should redirect_to("/chapters/show_draft/17#pcomment4")

      Pcomment.find(1).acknowledged.should_not be_nil
    end
  end

  describe "#unacknowledge" do
    it "should not allow unauthed unacknowledgement" do
      response = request("http://playground.playground.pele.cx/pcomments/unacknowledge/1", :method => "POST")
      response.should redirect_to("http://playground.playground.pele.cx/")
    end

    it "should allow authed unacknowledgement" do
      Pcomment.find(1).acknowledged.should_not be_nil

      request("http://playground.playground.pele.cx/login", :method => "PUT", :params => { :username => 'dstar', :password => 'test password' })
      response = request("http://playground.playground.pele.cx/pcomments/unacknowledge/1", :method => "POST")
      response.should redirect_to("/chapters/show_draft/17#pcomment4")

      Pcomment.find(1).acknowledged.should be_nil

      # Mark it read, so that we're in the state expected by the pcomment spec. Ugly hack -- need transactional tests.
      response = request("http://playground.playground.pele.cx/pcomments/markunread/1", :method => "POST")

    end
  end


end
