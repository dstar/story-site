module ChaptersHelper
  def nextChapter(chapter)
    number = Chapter.count_by_sql(["select min(number) from chapters where story_id = ? and number > ?",chapter.story_id, chapter.number])
    Chapter.find(:first, :conditions => ["story_id = ? and number = ?",chapter.story_id, number])
  end
  def prevChapter(chapter)
    number = Chapter.count_by_sql(["select min(number) from chapters where story_id = ? and number < ?",chapter.story_id, chapter.number])
    Chapter.find(:first, :conditions => ["story_id = ? and number = ?",chapter.story_id, number])
  end
end
