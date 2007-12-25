require File.dirname(__FILE__) + '/../test_helper'
require 'site_controller_controller'

# Re-raise errors caught by the controller.
class SiteControllerController; def rescue_action(e) raise e end; end

class SiteControllerControllerTest < Test::Unit::TestCase
  def setup
    @controller = SiteControllerController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
