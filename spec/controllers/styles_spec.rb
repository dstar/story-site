require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe "Styles" do

  (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob(File.join(Merb.root, 'test', 'fixtures', '*.{yml,csv}'))).each do |fixture_file|
    Fixtures.create_fixtures('test/fixtures', File.basename(fixture_file, '.*'))
  end

  before(:each) do
    @env = { :http_referer => "http://playground.pele.cx/blogposts/show",
      :http_host => "jaknis.playground.pele.cx"
    }
  end

  describe "#style_dropdown" do
    it "should allow unauthed access" do
      unauthed_action(Styles, :style_dropdown, { }, @env).should respond_successfully
    end
  end

  describe "#style_links" do
    it "should allow unauthed access" do
      unauthed_action(Styles, :style_links, { }, @env).should respond_successfully
    end
  end

  describe "#show" do
    it "should allow unauthed access" do
      unauthed_action(Styles, :show, { }, @env).should respond_successfully
    end

    it "should display the default theme when none is passed" do
      unauthed_action(Styles, :show, { }, @env).should respond_successfully do
        @theme.should == 'default'
      end
    end

    it "should display a specific theme when one is specified" do
      unauthed_action(Styles, :show, {:theme=> 'light.css' }, @env).should respond_successfully do
        @theme.should == 'light'
      end
    end
  end

  describe "#edit_theme" do
    it "should not allow unauthed access" do
      unauthed_action(Styles, :edit_theme, { },@env).should redirect_to("http://playground.pele.cx/blogposts/show")

    end

    it "should allow authed access" do
      authed_action(Styles, :edit_theme, { },@env).should respond_successfully
    end
  end

  describe "#customize" do
    it "should not allow unauthed access" do
      unauthed_action(Styles, :customize, { },@env).should redirect_to("http://playground.pele.cx/blogposts/show")

    end

    it "should allow authed access" do
      authed_action(Styles, :customize, { },@env).should respond_successfully
    end
  end

  describe "#save_style" do
    it "should not allow unauthed access" do
      unauthed_action(Styles, :save_style, { },@env).should redirect_to("http://playground.pele.cx/blogposts/show")

    end

    it "should allow authed access" do
      authed_action(Styles, :save_style, { },@env).should respond_successfully
    end
  end

  describe "#save_theme_style" do
    it "should not allow unauthed access" do
      unauthed_action(Styles, :save_theme_style, { },@env).should redirect_to("http://playground.pele.cx/blogposts/show")

    end

    it "should allow authed access" do
      authed_action(Styles, :save_theme_style, { },@env).should respond_successfully
    end
  end

end
