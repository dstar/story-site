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

  def test_show_route
    opts_default = { :controller => 'chapters', :action => "show", :id=> '219' }
    assert_recognizes opts_default, "/chapters/show/219", { }, 'Should recognize /chapters/show/219'
    opts_special = { :controller => 'chapters', :action => "show", :chapter=> 'wos1' }
    assert_recognizes opts_special, "/html/wos1.html", { }, 'Should recognize /html/wos1.html'
  end

  def test_dumpByFile_route
    opts_default = { :controller => 'chapters', :action => "dumpByFile", :id=> '219' }
    assert_recognizes opts_default, "/chapters/dumpByFile/219", { }, 'Should recognize /chapters/dumpByFile/219'
    opts_special = { :controller => 'chapters', :action => "dumpByFile", :chapter=> 'wos1' }
    assert_recognizes opts_special, "/text/wos1.txt", { }, 'Should recognize /text/wos1.txt'

  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:chapter)
    assert assigns(:chapter).valid?
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
