require File.dirname(__FILE__) + '/../test_helper'
require 'stories_controller'

# Re-raise errors caught by the controller.
class StoriesController; def rescue_action(e) raise e end; end

class StoriesControllerTest < Test::Unit::TestCase
  fixtures :stories
  fixtures :users
  fixtures :groups
  fixtures :story_permissions
  fixtures :universe_permissions
  fixtures :php_sessions
  fixtures :universes
  fixtures :stories

  def setup
    @controller = StoriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.env["HTTP_REFERER"] = "http://playground.pele.cx/pcomments/show"
  end

  def test_index
    get :index, :id => 7
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list, :id => 7

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:stories)
  end

  def test_show
    get :show, :id => 7

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:story)
    assert assigns(:story).valid?
  end

  def test_new_unauthed
    get :new, :universe_id => 1
    assert_response :redirect
    assert_redirected_to :controller => 'pcomments', :action => 'show'
  end

  def test_new_auth
    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")    
    get :new, :universe_id => 1

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:story)
  end

  def test_create_unauthed

    post :create, :story => {:universe_id => 1, :title => 'a', :short_title => 'a', :description => 'a'}, :universe_id => 1

    assert_response :redirect
    assert_redirected_to :controller => 'pcomments', :action => 'show'
  end

  def test_create_authed
    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")    
    num_stories = Story.count

    post :create, :story => {:universe_id => 1, :title => 'a', :short_title => 'a', :description => 'a'}, :universe_id => 1

    assert_response :redirect
    assert_redirected_to :controller => 'stories', :action => 'list'

    assert_equal num_stories + 1, Story.count
  end

  def test_edit_unauthed
    get :edit, :id => 7
    assert_response :redirect
    assert_redirected_to :controller => 'pcomments', :action => 'show'
  end

  def test_edit_authed
    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")    
    get :edit, :id => 7

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:story)
    assert assigns(:story).valid?
  end

  def test_update_unauthed
    post :update, :id => 7
    assert_response :redirect
    assert_redirected_to :controller => 'pcomments', :action => 'show'
  end

  def test_update_authed
    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")    
    post :update, :id => 7
    assert_response :redirect
    assert_redirected_to :controller => 'stories', :action => 'show', :id => 7
  end

  def test_destroy_unauthed
    post :destroy, :id => 7
    assert_response :redirect
    assert_redirected_to :controller => 'pcomments', :action => 'show'
  end

  def test_destroy_authed
    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")    
    assert_not_nil Story.find(7)

    post :destroy, :id => 7
    assert_response :redirect
    assert_redirected_to :controller => 'stories', :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Story.find(7)
    }
  end
end
