require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :stories

  # Replace this with your real tests.
  def test_story_permissions_with_id
    u = User.find(3)
    s = Story.find(8)
    up = UserPermission.create :user=> u, :permissionable => s, :permission => "Author"
    up.save
    perms = u.permissions_for_story(8)
    assert perms[0].id == up.id
  end
end
