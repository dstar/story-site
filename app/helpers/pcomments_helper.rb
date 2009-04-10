module Merb
module PcommentsHelper
  def breadcrumbs
    story_index_url = "http://#{StoryHost(@pcomment.paragraph.chapter.story)}/"
    home_link = link_to 'Home', "http://#{StoryHost('playground')}/"
    if params[:id]
      story = @pcomment.paragraph.chapter.story
      author_link = link_to story.authors.first.username, "/authors/show/#{story.authors.first.id}"
      story_link = link_to story.title, "/stories/show/#{story.id}"
      chapter_link = link_to @pcomment.paragraph.chapter.number, "#{story_index_url}chapters/show/#{@pcomment.paragraph.chapter.id}"
    else
      story = @paragraph.chapter.story
      author_link = link_to story.authors.first.username, "/authors/show/#{story.authors.first.id}"
      story_link = link_to story.title, "/stories/show/#{story.id}"
      chapter_link = link_to @paragraph.chapter.number, "/chapters/show/#{@paragraph.chapter.id}"
    end
    return "#{home_link} &gt; #{author_link} &gt; #{story_link} &gt; #{chapter_link}"
  end
end
end
