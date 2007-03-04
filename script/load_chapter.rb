class LoadChapter
  def LoadChapter.process_file(file, chapter_id, filename)
    @chapter = Chapter.find(chapter_id)

    @chapter.paragraphs.each {|para| para.pcomments.each { |p| p.destroy } } #kill any pre-existing comments
    @chapter.paragraphs.each {|p| p.destroy} #kill any pre-existing paras

    paragraph_buffer = String.new
    para_count = 1
    word_count = 0
    file_string = file.read
    file_string.gsub!(/\r/,'')
    lines = file_string.split(/\n\n/)
    lines.each { |line|
      line.gsub!(/^\n/,' ')
      line.gsub!(/(\w)\n(\w)/,'\1 \2')
      line.gsub!(/\n/,'')
      line.gsub!(/^\s*|\s*$/,'')
      line.gsub!(/#/,'***') if line == "#"
      line.gsub!(/\s+--/, "--")
      word_count += line.split.length
      
      para = Paragraph.new()
      para.body = line
      para.position = para_count
      para.chapter_id = chapter_id
      
      para.save
      
      para_count += 1
    }
    
    @chapter.words = word_count
    html_filename1 = filename
    html_filename2 = html_filename1.gsub(/.*\//, "")
    html_filename3 = html_filename2.gsub(/\..*/, ".html")
    @chapter.file = html_filename3
    @chapter.save
  end
  
end


RAILS_ENV = 'production'
require File.dirname(__FILE__) + '/../config/environment'

title = ARGV[0]
chapter_num = ARGV[1]
date = ARGV[2]
filename = ARGV[3]

@story = Story.find_by_short_title(title)
unless @story
  puts "Could not find story!"
  Kernel::exit 1
end

@chapter = Chapter.find_by_story_id_and_number(@story.id, chapter_num)
@chapter = Chapter.new() unless @chapter

@chapter.date_uploaded = date
@chapter.story_id = @story.id
@chapter.number = chapter_num
@chapter.status = 'released'

file = File.new(filename)

if @chapter.save
  LoadChapter.process_file(file,@chapter.id,filename)
else
  puts "Could not save chapter!"
  Kernel::exit 1
end

