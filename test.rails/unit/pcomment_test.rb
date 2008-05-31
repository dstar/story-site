require File.dirname(__FILE__) + '/../test_helper'

class PcommentsTest < Test::Unit::TestCase
  fixtures :pcomments, :users, :pcomments_read_by, :chapters, :paragraphs

  # Replace this with your real tests.
  def test_read_by
    chapter = Chapter.find(17)
    user = User.find(3)
    num_unread = Pcomment.count_by_sql(["select count(p.id) from pcomments pc, paragraphs p where p.chapter_id = ? and pc.id not in (select prb.pcomment_id from pcomments_read_by prb where  prb.user_id = ?) and pc.paragraph_id = p.id", chapter.id, user.id])
    num_comments = chapter.num_comments
    assert num_unread == (num_comments - 1), "Should have #{num_comments - 1} unread comments, got #{num_unread} instead"
  end
end
