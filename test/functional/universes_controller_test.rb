require File.dirname(__FILE__) + '/../test_helper'
require 'universes_controller'

# Re-raise errors caught by the controller.
class UniversesController; def rescue_action(e) raise e end; end

class UniversesControllerTest < Test::Unit::TestCase
  fixtures :universes
  fixtures :stories
  fixtures :users
  fixtures :groups
  fixtures :story_permissions
  fixtures :universe_permissions
  fixtures :site_permissions
  fixtures :php_sessions
  fixtures :required_permissions

  def setup
    @controller = UniversesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.env["HTTP_REFERER"] = "http://playground.pele.cx/pcomments/show"
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:universes)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:universe)
    assert assigns(:universe).valid?
  end

  def test_edit_unauthed
    get :edit, :id => 1
    assert_response :redirect
    assert_redirected_to :controller => 'pcomments', :action => 'show'

  end

  def test_update_unauthed
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :controller => 'pcomments', :action => 'show'

  end

  def test_destroy_unauthed
    assert_not_nil Universe.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :controller => 'pcomments', :action => 'show'

  end

  def test_edit_authed
    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")    
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:universe)
    assert assigns(:universe).valid?
  end

  def test_update_authed
    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")    
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :controller => 'universes', :action => 'show', :id => 1
  end

  def test_destroy_authed
    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")    
    assert_not_nil Universe.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :controller => 'universes', :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Universe.find(1)
    }
  end

end
