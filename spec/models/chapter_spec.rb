require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe Chapter do
#  fixtures :chapters, :paragraphs, :pcomments, :users

  it "should find the right number of comments" do
    chapter = Chapter.find(17)
    paragraphs = Paragraph.find(:all, :conditions => "chapter_id = 17")

    pcomments_count = paragraphs.inject(0) { |i, p| i += p.pcomments.length}

    chapter.num_comments.should eql(pcomments_count)
  end

  it "should find the right number of unread comments" do
    chapter = Chapter.find(17)
    paragraphs = chapter.paragraphs
    user = User.find(3)

    pcomments = paragraphs.collect { |p| p.pcomments }.compact.flatten
    pcomments_unread_count = pcomments.inject(0) { |i, p| unless p.readers.include?(user) then i += 1 else i end}

    chapter.num_unread_comments(user).should eql(pcomments_unread_count)
  end

end
