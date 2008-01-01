require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :stories
  fixtures :users

  # Replace this with your real tests.
  def test_story_permissions_with_id
    u = User.find(3)
    s = Story.find(2)

    is_author = u.has_story_permission(s,'author')
    assert_equals is_author, "false"

    universe_permissions=StoryPermission.new
    universe_permissions.permission_holder = u
    universe_permissions.permission='author'
    universe_permissions.story_id=s.id      
    universe_permissions.save

    assert u.has_story_permission(s,'author');

  end
end
