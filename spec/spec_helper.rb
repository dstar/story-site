require 'rubygems'
require 'merb-core'
require 'merb-core/test'
require 'spec' # Satiates Autotest and anyone else not using the Rake tasks
require 'activerecord'
require 'active_record/fixtures'

Merb.start_environment(:testing => true, :adapter => 'runner', :environment => ENV['MERB_ENV'] || 'test')

Spec::Runner.configure do |config|
  config.include(Merb::Test::ViewHelper)
  config.include(Merb::Test::RouteHelper)
  config.include(Merb::Test::ControllerHelper)
end

config = Merb::Orms::ActiveRecord.configurations[Merb.environment.to_sym]
ActiveRecord::Base.establish_connection(config)
test_folder = 'spec'
 (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob(File.join(Merb.root, test_folder, 'fixtures', '*.{yml,csv}'))).each do |fixture_file|
  Fixtures.create_fixtures(File.join(test_folder, 'fixtures'), File.basename(fixture_file, '.*'))
end

def self.use_transactional_fixtures
  true
end

def authed_action(controller, action, id, methd = "GET", params = { })
  request("http://playground.test.pele.cx/login", :method => "PUT", :params => { :username => 'dstar', :password => 'test password' })
  request("http://playground.test.pele.cx/#{controller}/#{action}/#{id}", :method => methd, :params => params)
end

def unauthed_action(controller, action, id, methd = "GET", params = { })
  request("http://playground.test.pele.cx/logout", :method => "GET")
  request("http://playground.test.pele.cx/#{controller}/#{action}/#{id}", :method => methd, :params => params)
end

# Specs for edit action
def edit_specs(controller, update_params)
  describe "#edit" do
    it "should not allow unauthed edits" do
      #      unauthed_action(controller, :edit, update_params ,@env).should redirect_to("http://test.pele.cx/blogposts/show")
      unauthed_action(controller, :edit, update_params[:id], "GET", update_params).should redirect
    end

    it "should allow authed edits" do
      authed_action(controller, :edit, update_params[:id], "GET", update_params).should be_successful
    end
  end
end

# Specs for update action
def update_specs(controller, update_params, update_redir)
  describe "#update" do
    it "should not allow unauthed updates" do
      unauthed_action(controller, :update, update_params[:id], "POST", update_params).should redirect_to("http://playground.test.pele.cx/")
      #      unauthed_action(controller, :update, update_params, @env).should redirect_to("http://test.pele.cx/blogposts/show")

    end

    it "should allow authed updates" do
      authed_action(controller, :update, update_params[:id], "POST", update_params).should_not redirect_to("http://playground.test.pele.cx/")
      #authed_action(controller, :update, update_params, @env).should redirect_to(update_redir)
    end

  end
end

# Specs for destroy
def destroy_specs(controller, update_params, model)
  describe "#destroy" do
    it "should not allow unauthed destroys" do
      lambda { unauthed_action(controller, :destroy, update_params[:id], "POST", update_params) }.should_not change(model,:count)
    end

    it "should allow authed destroys" do
      lambda { authed_action(controller, :destroy, update_params[:id], "POST", update_params)}.should change(model,:count)
    end
  end
end

# Specs for create
def create_specs(controller, create_params, model)
  describe "#create" do
    it "should not allow unauthed creates" do
      request("http://playground.test.pele.cx/logout", :method => "GET")
      lambda { request("http://playground.test.pele.cx/#{controller}/create/", :method => "POST", :params => create_params)}.should_not change(model,:count)
    end

    it "should allow authed creates" do
      request("http://playground.test.pele.cx/login", :method => "PUT", :params => { :username => 'dstar', :password => 'test password' })
      lambda { request("http://playground.test.pele.cx/#{controller}/create/", :method => "POST", :params => create_params) }.should change(model,:count)
    end
  end
end
#
# most_controller_specs has specs for edit, update, destroy, and
# create. If create_redir is null, the create spec will not be run.
#
# TODO: Allow passing an array of symbols for each spec containing
# additional tests

def most_controllers_specs (controller, update_params, update_redir, model, create_params, do_create=true)

  edit_specs(controller, update_params)
  update_specs(controller, update_params, update_redir)
  destroy_specs(controller, update_params, model)

  if do_create
    create_params ||= { }
    create_specs(controller, create_params, model)
  end

end
