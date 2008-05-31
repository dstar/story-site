require File.dirname(__FILE__) + '/../test_helper'
require 'paragraphs_controller'

# Re-raise errors caught by the controller.
class ParagraphsController; def rescue_action(e) raise e end; end

class ParagraphsControllerTest < Test::Unit::TestCase
  fixtures :paragraphs
  fixtures :universes
  fixtures :stories
  fixtures :users
  fixtures :groups
  fixtures :story_permissions
  fixtures :universe_permissions
  fixtures :site_permissions
  fixtures :php_sessions
  fixtures :pcomments

  def setup
    @controller = ParagraphsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.env["HTTP_REFERER"] = "http://playground.pele.cx/pcomments/show"
  end

  def test_new_unauthed
    get :new, 'chapter_id' => 17

    assert_response :redirect
    assert_redirected_to :controller => 'pcomments', :action => 'show'
  end

  def test_create_unauthed
    num_paragraphs = Paragraph.count

    post :create, :paragraphs => {'chapter_id' => 17}
    assert_response :redirect
    assert_redirected_to :controller => 'pcomments', :action => 'show'

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
    assert_not_nil Paragraph.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :controller => 'pcomments', :action => 'show'
  end

  def test_new_authed
    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")
    get :new, 'chapter_id' => 17

    assert_response :success, "result was #{@response.inspect}"
    assert_template 'new'

    assert_not_nil assigns(:paragraphs)
  end

  def test_create_authed
    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")
    num_paragraphs = Paragraph.count

    post :create, :paragraphs => {'body_raw' => "test1", 'chapter_id' => 17}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_paragraphs + 1, Paragraph.count
  end

  def test_edit_authed
    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:paragraphs)
    assert assigns(:paragraphs).valid?
  end

  def test_update_authed
    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")
    post :update, :id => 1, :paragraphs => {'body_raw' => "test1"}
    assert_response :redirect
    assert_redirected_to :action => 'show_draft', :controller => 'chapters'
  end

  def test_destroy_authed
    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")
    assert_not_nil Paragraph.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show_draft', :controller => 'chapters'

    assert_raise(ActiveRecord::RecordNotFound) {
      Paragraph.find(1)
    }
  end

  def test_move_comments_unauthed
    assert_not_nil Paragraph.find(4)

    post :move_comments_next, :id => 4
    assert_response :redirect
    assert_redirected_to :controller => 'pcomments', :action => 'show'

    post :move_comments_prev, :id => 4
    assert_response :redirect
    assert_redirected_to :controller => 'pcomments', :action => 'show'

  end

  def test_move_comments_authed

    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")

    assert_not_nil Paragraph.find(4)

    old_position = Paragraph.find(4).position

    comment = Paragraph.find(4).pcomments.first

    assert_not_nil comment
    assert_not_nil comment.paragraph
    assert_not_nil comment.paragraph.position

    post :move_comments_next, :id => 4
    assert_response :redirect
    assert_redirected_to :controller => 'chapters', :action => 'show_draft'

    assert_equal old_position + 1, Pcomment.find(comment.id).paragraph.position, "Expected position to be #{ old_position + 1}, but it was #{Pcomment.find(comment.id).paragraph.position}"

    post :move_comments_prev, :id => Pcomment.find(comment.id).paragraph.id
    assert_response :redirect
    assert_redirected_to :controller => 'chapters', :action => 'show_draft'

    assert_equal old_position, Pcomment.find(comment.id).paragraph.position, "Expected position to be #{ old_position + 1}, but it was #{Pcomment.find(comment.id).paragraph.position}"

  end

end
