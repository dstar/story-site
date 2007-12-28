module PcommentsHelper
  def breadcrumbs
    story_index_url = index_url(:host => StoryHost('playground'))
    home_link = link_to 'Home', index_url(:host => story_index_url) 
    if params[:id] 
      universe_link = link_to @pcomment.paragraph.chapter.story.universe.name, "#{story_index_url}/universes/show/#{@pcomment.paragraph.chapter.story.universe.id} "
      story_link = link_to @pcomment.paragraph.chapter.story.title, "#{story_index_url}/stories/show/#{@pcomment.paragraph.chapter.story.id}"
      chapter_link = link_to @pcomment.paragraph.chapter.number, "#{story_index_url}/chapters/show/#{@pcomment.paragraph.chapter.id}"
    else 
      universe_link = link_to @paragraph.chapter.story.universe.name, "#{story_index_url}/universes/show/#{@paragraph.chapter.story.universe.id}"
      story_link = link_to @paragraph.chapter.story.title, "#{story_index_url}/stories/show/#{@paragraph.chapter.story.id}"
      chapter_link = link_to @paragraph.chapter.number, "#{story_index_url}/chapters/show/#{@paragraph.chapter.id}"
    end
    return "#{home_link} &gt; #{universe_link} &gt; #{story_link} &gt; #{chapter_link}"
  end
end
