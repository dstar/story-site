module TargetsHelper
  def DaysinMonth ( month, year )
    Chapter.count_by_sql ["select if( ?=month(curdate()), day(curdate()),day(last_day('?-?-1')))",
      month, year, month]
  end
  def StoryWords (story_id, month, year )
    Chapter.sum('words', :conditions => ["story_id = ? and date between '?-?-1' and if(?=month(curdate()),curdate(),last_day('?-?-1'))",
      story_id, year, month, month, year, month])
  end
  def MonthlyGoal ( month, year, weekly_words )
    weekly_words * DaysinMonth(month, year) / 7
  end
  def Overage (month, year, story_id, weekly_words)
    StoryWords(story_id, month, year) - MonthlyGoal(month, year, weekly_words)
  end
  def MonthStr( month, year )
    Target.find_by_sql(["select matcoltitle( ?, ?) as MonthStr", year, month ])
  end
end
