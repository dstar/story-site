require File.dirname(__FILE__) + '/../test_helper'

class UserPermissionsTest < Test::Unit::TestCase
  fixtures :user_permissions
  fixtures :stories

  # Replace this with your real tests.
  def test_add_story_perm
    u = User.find(3)
    s = Story.find(8)
    up = UserPermission.create :user=> u, :permissionable => s, :permission => "Author"
    up.save
    up2 = UserPermission.find_by_user_id(3)
    assert_same up.id, up2.id  
  end
  def test_add_chapter_perm
    u = User.find(3)
    s = Story.find(8)
    up = UserPermission.create :user=> u, :permissionable => s, :permission => "Author"
    up.save
    up2 = UserPermission.find_by_user_id(3)
    assert_same up.id, up2.id  
  end

  def test_contains_perm
    u = User.find(3)
    s = Story.find(8)
    up = UserPermission.create :user=> u, :permissionable => s, :permission => "Author"
    up.save
    perms = u.user_permissions
    assert perms.each {|x| x.permissionable_id == s.id and x.permission == "Author" }
  end

end
