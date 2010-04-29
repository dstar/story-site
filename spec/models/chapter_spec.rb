require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe Chapter do
  test_files_dir = File.join( File.dirname(__FILE__), "..", "..", "features", "test_files" )

  def verify_file_processing(file_type,raw=nil)
    marked_down = [Regexp.new("^This is test paragraph 1\\."),
                   Regexp.new("^This is <em>test paragraph 2</em>\\."),
                   Regexp.new("^This is <em>test paragraph 3</em>\\."),
                   Regexp.new("^This is <em>test </em>paragraph<em> 4</em>\\."),
                   Regexp.new("^This is <strong>test paragraph 5</strong>\\."),
                   Regexp.new("^This is <strong>test paragraph 6</strong>\\."),
                  ]

    raw ||=      [Regexp.new("^This is test paragraph 1\\."),
                   Regexp.new("^This is _test paragraph 2_\\."),
                   Regexp.new("^This is _test paragraph 3_\\."),
                   Regexp.new("^This is _test _paragraph_ 4_\\."),
                   Regexp.new("^This is \\*\\*test paragraph 5\\*\\*\\."),
                   Regexp.new("^This is \\*\\*test paragraph 6\\*\\*\\."),
                  ]

    chapter = Chapter.new
    chapter.story = Story.find(:last)
    chapter.number = chapter.story.chapters.length + 1
    chapter.save
    file = File.open(file_type[:filename],'r')
    file_hash = { :tempfile => file, :content_type => file_type[:mime]}
    chapter.process_file(file_hash)
    chapter.paragraphs.length.should == 20
    for paragraph in (0..raw.length-1)
      chapter.paragraphs[paragraph].body_raw.should match raw[paragraph]
      chapter.paragraphs[paragraph].body.should match marked_down[paragraph]
    end
  end

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
    raw = [Regexp.new("^This is test paragraph 1\\."),
           Regexp.new("^This is _test paragraph 2_\\."),
           Regexp.new("^This is \\*test paragraph 3\\*\\."),
           Regexp.new("^This is _test _paragraph_ 4_\\."),
           Regexp.new("^This is \\*\\*test paragraph 5\\*\\*\\."),
           Regexp.new("^This is __test paragraph 6__\\."),
          ]

    text_file = { :mime => "text/plain", :filename => "#{test_files_dir}/test_chapter_1.txt"}
    verify_file_processing(text_file,raw)
  end

  it "should process an HTML file correctly" do
    text_file = { :mime => "text/html", :filename => "#{test_files_dir}/test_chapter_1.html"}
    verify_file_processing(text_file)
  end

  it "should process a Word file correctly" do
    text_file = { :mime => "application/ms-word", :filename => "#{test_files_dir}/test_chapter_1.doc"}
    verify_file_processing(text_file)
  end

end
