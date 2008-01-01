require File.dirname(__FILE__) + '/../test_helper'
require 'style_controller'

# Re-raise errors caught by the controller.
class StyleController; def rescue_action(e) raise e end; end

class StyleControllerTest < Test::Unit::TestCase

  fixtures :php_sessions, :users, :groups

  def setup
    @controller = StyleController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.env["HTTP_REFERER"] = "http://playground.pele.cx/pcomments/show"
  end

  # Replace this with your real tests.
  def test_show
    get :show
    assert_response :success, "#{@response.inspect}"
    assert_template 'show'

    assert_not_nil assigns(:styles)
  end

  def test_customize_unauthed
    get :customize
    assert_response :redirect
    assert_redirected_to :controller => 'pcomments', :action => 'show'
  end

  def test_customize_auth
    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")    
    get :customize

    assert_response :success
    assert_template 'customize'

    assert_not_nil assigns(:default_styles)
    assert_not_nil assigns(:user_styles)
    assert_not_nil assigns(:theme)
  end

  def test_save_style_unauthed
    get :save_style
    assert_response :redirect
    assert_redirected_to :controller => 'pcomments', :action => 'show'
  end

  def test_save_style_auth
    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")    
    get :save_style, :definition => "test", :element => "test_elewent"

    assert_response :success
    assert_template '_edit_style'

    assert_not_nil assigns(:result)
  end

  def test_save_style_auth_missing_element
    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")    
    get :save_style, :definition => "test"

    assert_response :success
    assert_template '_edit_style'

    assert_not_nil assigns(:result)
    assert assigns(:result) == "Please enter both an element specifier and a style"
  end

  def test_save_style_auth_missing_def
    @request.cookies["phpbb2mysql_sid"] = CGI::Cookie.new("phpbb2mysql_sid", "test")    
    get :save_style, :element => "test123123412341234"

    assert_response :success
    assert_template '_edit_style'

    assert_not_nil assigns(:result)
    assert assigns(:result) == "Please enter both an element specifier and a style", "@result was #{@result}\n"
  end


end
