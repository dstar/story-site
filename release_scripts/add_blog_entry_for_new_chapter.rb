#! /usr/bin/ruby

RAILS_ENV = 'production'
require File.dirname(__FILE__) + '/../config/environment'

title = ARGV[0]
chapter_num = ARGV[1]

@story = Story.find_by_short_title(title)
unless @story
  puts "Could not find story!"
  Kernel::exit 1
end

@chapter = Chapter.find_by_story_id_and_number(@story.id, chapter_num)
@url = "http://#{title}.playground.pele.cx"

add_news = IO.popen("/home/httpd/html/playground/add_news_entry.pl -b #{title} -t \"#{@story.title}\"", "w+")
add_news.puts "<p><a href='#{@url}'>#{@story.title}</a> Chapter #{@chapter.number} (#{@chapter.words} words) is up!</p>"
add_news.close_write
