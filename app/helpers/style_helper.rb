module StyleHelper
  def breadcrumbs
    return "#{link_to 'Home', index_url(:host => StoryHost('playground'))} &gt; Edit Theme"
  end
end
