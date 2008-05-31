require File.dirname(__FILE__) + '/../test_helper'
require 'blogposts_controller'

# Re-raise errors caught by the controller.
class BlogpostsController; def rescue_action(e) raise e end; end

class BlogpostsControllerTest < Test::Unit::TestCase

  include ApplicationHelper
  include ActionView::Helpers::UrlHelper

  fixtures :blogposts
  fixtures :users
  fixtures :groups
  fixtures :site_permissions
  fixtures :php_sessions


  def setup
    @controller = BlogpostsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.env["HTTP_REFERER"] = "http://playground.pele.cx/blogposts/show"
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

    assert_not_nil assigns(:blogposts)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:blogpost)
    assert assigns(:blogpost).valid?
  end

  def test_new_unauthed
    get :new

    assert_response :redirect
    assert_redirected_to :controller => 'blogposts', :action => 'show'
  end

  def test_new_authed

    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")    

    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:blogpost)
  end

  def test_create_unauthed
    num_blogposts = Blogpost.count

    post :create, :blogpost => {}

    assert_response :redirect
    assert_redirected_to :controller => 'blogposts', :action => 'show'
  end

  def test_create_authed
    num_blogposts = Blogpost.count

    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")    

    post :create, :blogpost => {:body_raw => "test"}

    assert_response :redirect
    assert_redirected_to :controller => 'site', :action => 'show'

    assert_equal num_blogposts + 1, Blogpost.count
  end

  def test_edit_unauthed
    get :edit, :id => 1
    assert_response :redirect
    assert_redirected_to :controller => 'blogposts', :action => 'show'
  end

  def test_edit_authed

    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")    

    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:blogpost)
    assert assigns(:blogpost).valid?
  end

  def test_update_unauthed
    @request.env["HTTP_REFERER"] = "http://playground.pele.cx/blogposts/list"
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'
  end

  def test_update_authed

    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")    

    post :update, :id => 1, :blogpost => {:body_raw => "test_update"}
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy_unauthed
    assert_not_nil Blogpost.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show'

  end

  def test_destroy_authed

    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")    

    assert_not_nil Blogpost.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Blogpost.find(1)
    }
  end
end
