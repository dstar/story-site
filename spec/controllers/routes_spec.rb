require File.join( File.dirname(__FILE__), "..", "spec_helper" )


describe "Stories" do

  before(:each) do
    @env = { :http_referer => "http://playground.pele.cx/blogposts/show",
      :http_host => "jaknis.playground.pele.cx"
    }
  end

  it "Routes get of / to the story specified by the hostname" do
    request_to("/", :get, @env).should route_to(Stories, :show).with(:short_title => 'jaknis')
  end
end

describe "Sites" do

  before(:each) do
    @env = { :http_referer => "http://playground.pele.cx/blogposts/show",
      :http_host => "playground.playground.pele.cx"
    }
  end

  it "Routes get of / to the site page" do
    request_to("/", :get, @env).should route_to(Site, :show)
  end
end

describe "Chapters" do

  before(:each) do
    @env = { :http_referer => "http://playground.pele.cx/blogposts/show",
      :http_host => "oops.playground.pele.cx"
    }
  end

  it "Routes get of /html/<name><chapter_number>.html to the appropriate chapter" do
    request_to("/html/oops1.html", :get, @env).should route_to(Chapters, :show).with(:short_title => 'oops', :chapter => "oops1")
  end

  it "Routes get of /text/<name><chapter_number>.txt to the appropriate chapter" do
    request_to("/text/oops1.txt", :get, @env).should route_to(Chapters, :show).with(:short_title => 'oops', :chapter => "oops1", :format => "text")
  end

end
