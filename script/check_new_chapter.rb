#! /usr/bin/ruby

RAILS_ENV = 'production'
require File.dirname(__FILE__) + '/../config/environment'

title = ARGV[0]

@story = Story.find_by_short_title(title)
unless @story
  puts "0"
  Kernel::exit 1
end

@chapter = Chapter.find_by_story_id_and_status(@story.id, 'released', :order=> 'number desc')
if @chapter 
  if Date.today - @chapter.date_released < 7
    puts "1"
  else
    puts "0"
  end
else
  puts "0"
end
