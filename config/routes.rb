ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up ''
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

#  map.connect ':story', :controller => 'stories', :action => 'showByName', :id => nil
#  map.connect ':story/:chapter', :controller => 'chapters', :action => 'showByName', :id => nil

  map.chapter 'html/:chapter.html', :controller => 'chapters', :action => 'show'
  map.text 'text/:chapter.txt', :controller => 'chapters', :action => 'dumpByFile'
  map.blog 'blog/:action/:id', :controller => 'blogposts'
  map.style_action 'style/:action/:theme.:ext', :controller => 'style'
  map.style 'style/:theme', :controller => 'style', :action => 'show'
  map.site '', :controller => 'site', :action => 'show', :conditions => { :host => 'playground.playground.pele.cx'}
  map.index '', :controller => 'stories', :action => 'show'

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
end
