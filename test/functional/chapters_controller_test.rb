require File.dirname(__FILE__) + '/../test_helper'
require 'chapters_controller'

# Re-raise errors caught by the controller.
class ChaptersController; def rescue_action(e) raise e end; end

class ChaptersControllerTest < Test::Unit::TestCase
  fixtures :chapters
  fixtures :users
  fixtures :groups
  fixtures :story_permissions
  fixtures :php_sessions
  fixtures :universes
  fixtures :stories

  def setup
    @controller = ChaptersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.env["HTTP_REFERER"] = "http://playground.pele.cx/chapters/show"
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

    assert_not_nil assigns(:chapters)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:chapter)
    assert assigns(:chapter).valid?
  end

  def test_new_unauthed
#    post :new, :story_id => 7
    post :new, :story_id => 7

    assert_response :redirect
    assert_redirected_to :controller => 'chapters', :action => 'show'
  end

  def test_new_authed

    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")    

#    post :new, :story_id => 7
    post :new, :story_id => 7

    assert_response :success#, "#{pp_s @response.inspect}"
    assert_template 'new'

    assert_not_nil assigns(:chapter)
  end

  def test_create_unauthed
    @request.env["HTTP_REFERER"] = "http://playground.pele.cx/chapters/list"
    num_chapters = Chapter.count

    post :create, :chapter => { :story_id => 7}

    assert_response :redirect
    assert_redirected_to :controller => 'chapters', :action => 'list'
  end

  def test_create_authed
    @request.env["HTTP_REFERER"] = "http://playground.pele.cx/chapters/list"
    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")    

    num_chapters = Chapter.count

    post :create, :chapter => {:story_id => 7}

    assert_response :redirect
    assert_redirected_to :action => 'show'

    assert_equal num_chapters + 1, Chapter.count
  end

  def test_edit_unauthed
    get :edit, :id => 1

    assert_response :redirect
    assert_redirected_to :controller => 'chapters', :action => 'show'
  end

  def test_edit_authed

    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")    

    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:chapter)
    assert assigns(:chapter).valid?
  end

  def test_update_unauthed
    @request.env["HTTP_REFERER"] = "http://playground.pele.cx/chapters/list"
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'
  end

  def test_update_authed
    @request.env["HTTP_REFERER"] = "http://playground.pele.cx/chapters/list"

    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")    

    post :update, :id => 1, :chapter => { :status => 'draft' }
    assert_response :redirect
    assert_redirected_to :action => 'show', :controller => 'stories'
  end

  def test_destroy_unauthed
    assert_not_nil Chapter.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :controller => 'chapters', :action => 'show'
  end

  def test_destroy_authed

    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")    

    assert_not_nil Chapter.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Chapter.find(1)
    }
  end
end
