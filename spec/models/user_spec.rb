require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe User do
#  fixtures :stories, :users

  it "should not find permissions it doesn't have" do
    u = User.find(3)
    s = Story.find(2)

    u.has_story_permission(s,'author').should be_false
end

  it "should find permissions it has" do
    u = User.find(3)
    s = Story.find(2)

    story_permission=StoryPermission.new
    story_permission.permission_holder = u
    story_permission.permission='author'
    story_permission.story_id=s.id
    story_permission.save

    u.story_permissions << story_permission
    u.save

    u.has_story_permission(s,'author').should be_true
  end

end

