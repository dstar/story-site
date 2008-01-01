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
#    assert_valid assigns(:story)
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
#    assert_valid assigns(:story)
  end

  def test_update_unauthed
    post :update, :id => 7
    assert_response :redirect
    assert_redirected_to :controller => 'pcomments', :action => 'show'
  end

  def test_update_authed
    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")    
    post :update, :id => 7, :story => {:universe_id => 1, :title => 'a', :short_title => 'a', :description => 'a'}
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
  
    def test_new_chapter_unauthed
#    post :new, :story_id => 7
    post :new_chapter, :id => 7

    assert_response :redirect
    assert_redirected_to :controller => 'pcomments', :action => 'show'
  end

  def test_new_chapter_authed

    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")    

#    post :new, :story_id => 7
    post :new_chapter, :id => 7

    assert_response :success#, "#{pp_s @response.inspect}"
    assert_template 'new_chapter'

    assert_not_nil assigns(:chapter)
  end

  def test_create_story_unauthed
    @request.env["HTTP_REFERER"] = "http://playground.pele.cx/chapters/list"
    num_chapters = Chapter.count

    post :create_chapter, :chapter => { :story_id => 7}, :id => 7

    assert_response :redirect
    assert_redirected_to :controller => 'pcomments', :action => 'show'
  end

  def test_create_story_authed
    @request.env["HTTP_REFERER"] = "http://playground.pele.cx/chapters/list"
    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")    

    num_chapters = Chapter.count

    post :create_chapter, :chapter => {:story_id => 7}, :id => 7

    assert_response :redirect
    assert_redirected_to :controller => 'chapters', :action => 'show_draft'

    assert_equal num_chapters + 1, Chapter.count
  end

  
end
