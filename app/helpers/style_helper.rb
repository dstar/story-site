module StyleHelper
  def breadcrumbs
    return "#{link_to 'Home', StoryHost('playground')} &gt; Edit Theme"
  end
end
