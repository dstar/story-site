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

  #add_slice FiverunsTuneupMerb
  slice(:MerbAuthSlicePassword, :name_prefix => nil, :path_prefix => "auth", :default_routes => false )

  r.match("/html/:chapter.html").defer_to do |request,params|
    params[:controller] = 'chapters'
    params[:action] = 'show'
    params[:short_title] = request.subdomains[0] if request.subdomains[0]
    params
    #    Merb.logger.debug "QQQ32: params are #{params.inspect}"
  end.name(:chapter)

  r.match("/text/:chapter.txt").defer_to do |request,params|
    params.merge :controller => 'chapters', :action => 'show', :format => "text"
    params.merge :short_title => request.subdomains[0] if request.subdomains[0]
  end.name(:text)

  r.match('/').defer_to do |request, params|
    if request.subdomains[0] != 'playground' && request.subdomains[0].to_i != 127
    Merb.logger.debug "QQQ6: :request is #{request.domain.inspect}"
    Merb.logger.debug "QQQ6: :request is #{request.subdomains.inspect}"
    params.merge :controller => 'stories', :action => 'show', :short_title => request.subdomains[0]
    else
#    Merb.logger.debug "QQQ7: :subdomain[1] is #{:subdomain[1]}"
    params.merge :controller => 'site', :action => 'show'
    end

  end

  r.match('/blogposts/archive/:page').to(:controller => :blogposts, :action => 'archive')

  r.resources :blogposts

  # This is the default route for /:controller/:action/:id
  # This is fine for most cases.  If you're heavily using resource-based
  # routes, you may want to comment/remove this line to prevent
  # clients from calling your create or destroy actions with a GET

  r.default_routes

  # RESTful routes
  r.resources :chapters
  r.resources :stories
  r.resources :universes
  r.resources :paragraphs
  r.resources :pcomments
  r.resources :users

  # Change this for your home page to be available at /
  # r.match('/').to(:controller => 'whatever', :action =>'index')

end
