require File.dirname(__FILE__) + '/../test_helper'
require 'pcomments_controller'

# Re-raise errors caught by the controller.
class PcommentsController; def rescue_action(e) raise e end; end

class PcommentsControllerTest < Test::Unit::TestCase
  fixtures :pcomments
  fixtures :users
  fixtures :groups
  fixtures :story_permissions
  fixtures :php_sessions
  fixtures :universes
  fixtures :stories
  fixtures :chapters
  fixtures :paragraphs

  def setup
    @controller = PcommentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.env["HTTP_REFERER"] = "http://playground.pele.cx/pcomments/show"
  end

  def test_new_unauthed
    get :new, :paragraph_id => 4

    assert_response :redirect
    assert_redirected_to :controller => 'pcomments', :action => 'show'

  end

  def test_new_authed

    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")

    get :new, :paragraph_id => 4

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:pcomment)
  end

  def test_create_unauthed
    @request.env["HTTP_REFERER"] = "http://playground.pele.cx/pcomments/list"
    num_pcomments = Pcomment.count

    post :create, :pcomments => {}, :paragraph_id => 4

    assert_response :redirect
    assert_redirected_to :action => 'list'

  end

  def test_create_authed
    @request.env["HTTP_REFERER"] = "http://playground.pele.cx/pcomments/list"
    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")

    num_pcomments = Pcomment.count

    post :create, :pcomment => {:body_raw => "test"}, :paragraph_id => 4

    assert_response :redirect
    assert_redirected_to :controller => 'chapters', :action => 'show_draft'

    assert_equal num_pcomments + 1, Pcomment.count
  end

  def test_edit_unauthed
    get :edit, :id => 1
    assert_response :redirect
    assert_redirected_to :controller => 'pcomments', :action => 'show'
  end

  def test_edit_authed

    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")

    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:pcomment)
    assert assigns(:pcomment).valid?
  end

  def test_update_unauthed
    @request.env["HTTP_REFERER"] = "http://playground.pele.cx/pcomments/list"
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :controller => 'pcomments', :action => 'list'
  end

  def test_update_authed
    @request.env["HTTP_REFERER"] = "http://playground.pele.cx/pcomments/list"
    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")

    post :update, :id => 1, :pcomment => {:body_raw => "test"}
    assert_response :redirect
    assert_redirected_to :controller => 'chapters', :action => 'show_draft'
  end

  def test_markread_unread
    @request.env["HTTP_REFERER"] = "http://playground.pele.cx/pcomments/list"
    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")

    user = User.find(3)

    comment = Pcomment.find(2)

    assert_equal 0, comment.readers.length

    post :markread, :id => 1

    assert_response :redirect
    assert_redirected_to :controller => 'chapters', :action => 'show_draft'

    comment_read = Pcomment.find(1)

    assert_not_nil comment_read.readers, "read by should not be nil after marking read"
    assert comment_read.readers.include?(user), "read_by should include 'dstar' after marking read"

    post :markunread, :id => 1

    comment_unread = Pcomment.find(1)

    assert_not_nil comment_unread.readers, "read_by should not be nil after marking unread"
    assert ! comment_unread.readers.include?(user), "read_by should not include 'dstar' after marking unread"

  end


  def test_destroy_unauthed
    assert_not_nil Pcomment.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :controller => 'pcomments', :action => 'show'
  end

  def test_destroy_authed

    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")

    assert_not_nil Pcomment.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :controller => 'chapters', :action => 'show_draft'

    assert Pcomment.find(1).flag == 2

  end

  def test_move_unauthed
    assert_not_nil Pcomment.find(1)

    post :move_next, :id => 1
    assert_response :redirect
    assert_redirected_to :controller => 'pcomments', :action => 'show'

    post :move_prev, :id => 1
    assert_response :redirect
    assert_redirected_to :controller => 'pcomments', :action => 'show'

  end

  def test_move_authed

    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")

    assert_not_nil Pcomment.find(1)

    old_position = Pcomment.find(1).paragraph.position

    post :move_next, :id => 1
    assert_response :redirect
    assert_redirected_to :controller => 'chapters', :action => 'show_draft'

    assert_equal  old_position + 1, Pcomment.find(1).paragraph.position, "Expected position to be #{ old_position + 1}, but it was #{Pcomment.find(1).paragraph.id}"

    post :move_prev, :id => 1
    assert_response :redirect
    assert_redirected_to :controller => 'chapters', :action => 'show_draft'

    assert_equal old_position, Pcomment.find(1).paragraph.position

  end

end
