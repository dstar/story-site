require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe Chapter do
  test_files_dir = File.join( File.dirname(__FILE__), "..", "..", "features", "test_files" )
  regexps = [Regexp.new("^This is test paragraph 1\\."),
             Regexp.new("^This is _test paragraph 2_\\."),
             Regexp.new("^This is \\*test paragraph 3\\*\\."),
             Regexp.new("^This is _\\*test paragraph 4\\*_\\."),
             Regexp.new("^This is \\*\\*test paragraph 5\\*\\*\\."),
             Regexp.new("^This is __test paragraph 6__\\."),
            ]

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

  it "should process a text file correctly" do
    chapter = Chapter.new
    chapter.story = Story.find(:last)
    chapter.save
    file = File.open("#{test_files_dir}/test_chapter_1.txt",'r')
    chapter.process_file(file)
    chapter.paragraphs.length.should == 20
    for paragraph in (0..5)
      chapter.paragraphs[paragraph].body_raw.should match regexps[paragraph]
    end
  end

end
