require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :stories
  fixtures :users

  # Replace this with your real tests.
  def test_story_permissions_with_id
    u = User.find(3)
    s = Story.find(2)

    is_author = u.has_story_permission(s,'author')
    assert_equal is_author, false, "is_author should be false, was #{is_author}"

    story_permission=StoryPermission.new
    story_permission.permission_holder = u
    story_permission.permission='author'
    story_permission.story_id=s.id      
    story_permission.save

    u.story_permissions << story_permission
    u.save
    
    assert u.has_story_permission(s,'author');

  end
end
