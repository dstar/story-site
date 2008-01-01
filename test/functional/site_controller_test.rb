require File.dirname(__FILE__) + '/../test_helper'
require 'site_controller'

# Re-raise errors caught by the controller.
class SiteController; def rescue_action(e) raise e end; end

class SiteControllerTest < Test::Unit::TestCase
  def setup
    @controller = SiteController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_new_unauthed
    get :new
    assert_response :redirect
    assert_redirected_to :controller => 'site', :action => 'show'

  end

  def test_create_unauthed
    num_universes = Universe.count

    post :create, :universe => {}
    assert_response :redirect
    assert_redirected_to :controller => 'site', :action => 'show'

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

    post :create_universe, :universe => { :id => 20}

    assert_response :redirect
    assert_redirected_to :controller => 'universes', :action => 'show', :id => 4

    assert_equal num_universes + 1, Universe.count
  end
  
  def test_site_page
    get :show
    
    assert_response :success
    assert_template 'show'
    
    #Check to make sure that the Prudence link and header show up in the right place.
    assert_tag :tag => "a", 
      :content => "Prudence, TX Population 1276",
      :attributes => {:href => "http://prudence.playground.pele.cx/"},
      :parent => { 
      :tag => "h4", 
      :parent => { 
        :tag => "li", 
        :parent => { 
          :tag => "div", 
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
  end
  
end
