require File.dirname(__FILE__) + '/../test_helper'

class ChapterTest < Test::Unit::TestCase
  fixtures :chapters, :paragraphs, :pcomments, :users

  # Replace this with your real tests.
  def test_num_comments
    chapter = Chapter.find(17)
    paragraphs = Paragraph.find(:all, :conditions => "chapter_id = 17")

    pcomments_count = paragraphs.inject(0) { |i, p| i += p.pcomments.length}

    assert_equal chapter.num_comments, pcomments_count, "verify num_comments"
  end

  def test_num_unread_comments
    chapter = Chapter.find(17)
    paragraphs = chapter.paragraphs
    user = User.find(3)

    pcomments = paragraphs.collect { |p| p.pcomments }.compact.flatten
    pcomments_unread_count = pcomments.inject(0) { |i, p| unless p.readers.include?(user) then i += 1 else i end}

    assert_equal chapter.num_unread_comments(user), pcomments_unread_count, "chapter.num_unread_comments was #{chapter.num_unread_comments(user)}, pcomments_unread_count was #{pcomments_unread_count}"

  end

end
