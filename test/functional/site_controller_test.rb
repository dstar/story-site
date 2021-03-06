require File.dirname(__FILE__) + '/../test_helper'
require 'site_controller'

# Re-raise errors caught by the controller.
class SiteController; def rescue_action(e) raise e end; end

class SiteControllerTest < Test::Unit::TestCase
  def setup
    @controller = SiteController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.env["HTTP_REFERER"] = "http://playground.pele.cx/pcomments/show"
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def test_new_unauthed
    get :new
    assert_response :redirect
    assert_redirected_to :controller => 'pcomments', :action => 'show'

  end

  def test_create_unauthed
    num_universes = Universe.count

    post :create, :universe => {}
    assert_response :redirect
    assert_redirected_to :controller => 'pcomments', :action => 'show'

  end

  def test_new_universe_authed
    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")
    get :new_universe

    assert_response :success
    assert_template 'new_universe'

    assert_not_nil assigns(:universe)
  end

  def test_create_universe_authed
    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")
    num_universes = Universe.count

    post :create_universe, :universe => { :id => 20, :name => 'test name', :description => "test description"}

    assert_response :redirect
    assert_redirected_to :controller => 'universes', :action => 'show', :id => 4

    u = Universe.find(4)
    assert_equal "test name", u.name
    assert_equal "test description", u.description
    assert_equal num_universes + 1, Universe.count
  end

  def test_site_page

    @request.host = "playground.playground.pele.cx"

    get :show

    assert_response :success, "Getting the main page should succeed, not redirect"
    assert_template 'show', "The main page should use the show template"

    #Check to make sure that the Prudence link and header show up in the right place.
    prudence_tag_hash = { :tag => "a",
      :content => "Prudence, TX Population 1276",
      :attributes => {:href => "http://prudence.playground.pele.cx/"},
      :parent => {
        :tag => "h4",
        :parent => {
          :tag => "div",
          :parent => {
            :tag => "li",
            :parent => {
              :tag => "ul",
             :parent => {
                :tag => "div",
                :attributes => {
                  :class => "world"
                },
                :child => {
                  :tag =>"h2",
                  :attributes => {
                    :class => "worldtitle"
                  },
                 :child => {
                    :tag => "a",
                    :content => "Demon's Dream"
                  }
                }
              }
            }
          }
        }
      }
    }


    #    prudence_tag_hash = { :tag => "a",
    #      :content => "Prudence, TX Population 1276",
    #      :attributes => {:href => "http://prudence.playground.pele.cx/"},
    #    }

    assert_tag prudence_tag_hash
  end

end
