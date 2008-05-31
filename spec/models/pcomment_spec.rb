require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe Pcomment do
#  fixtures :pcomments, :users, :pcomments_read_by, :chapters, :paragraphs

  it "should find the right number of unread comments" do
    chapter = Chapter.find(17)
    user = User.find(3)
    num_unread = Pcomment.count_by_sql(["select count(p.id) from pcomments pc, paragraphs p where p.chapter_id = ? and pc.id not in (select prb.pcomment_id from pcomments_read_by prb where  prb.user_id = ?) and pc.paragraph_id = p.id", chapter.id, user.id])
    num_comments = chapter.num_comments
    num_unread.should eql(num_comments - 1)
  end

end
