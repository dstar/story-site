# Merb::Router is the request routing mapper for the merb framework.
#
# You can route a specific URL to a controller / action pair:
#
#   r.match("/contact").
#     to(:controller => "info", :action => "contact")
#
# You can define placeholder parts of the url with the :symbol notation. These
# placeholders will be available in the params hash of your controllers. For example:
#
#   r.match("/books/:book_id/:action").
#     to(:controller => "books")
#
# Or, use placeholders in the "to" results for more complicated routing, e.g.:
#
#   r.match("/admin/:module/:controller/:action/:id").
#     to(:controller => ":module/:controller")
#
# You can also use regular expressions, deferred routes, and many other options.
# See merb/specs/merb/router.rb for a fairly complete usage sample.

Merb.logger.info("Compiling routes...")
Merb::Router.prepare do |r|

  r.match("/html/:chapter.html").defer_to do |request,params|
    params.merge :controller => 'chapters', :action => 'show', :short_title => request.subdomains[0]
  end.name(:chapter)

  r.match("/text/:chapter.txt").defer_to do |request,params|
    params.merge :controller => 'chapters', :action => 'show', :short_title => request.subdomains[0], :format => "text"
  end.name(:text)

  r.match('/').defer_to do |request, params|
    if request.subdomains[0] != 'playground'
    Merb.logger.debug "QQQ6: request.subdomains[0] is #{request.subdomains[0]}"
    params.merge :controller => 'stories', :action => 'show', :short_title => request.subdomains[0]
    else
    Merb.logger.debug "QQQ7: request.subdomains[0] is #{request.subdomains[0]}"
    params.merge :controller => 'site', :action => 'show'
    end

  end

  # RESTful routes
#  r.resources :chapters
#  r.resources :stories
#  r.resources :universes

  # This is the default route for /:controller/:action/:id
  # This is fine for most cases.  If you're heavily using resource-based
  # routes, you may want to comment/remove this line to prevent
  # clients from calling your create or destroy actions with a GET
  r.default_routes

  # Change this for your home page to be available at /
  # r.match('/').to(:controller => 'whatever', :action =>'index')

end
