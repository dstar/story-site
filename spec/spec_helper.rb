require 'rubygems'
require 'merb-core'
require 'spec' # Satiates Autotest and anyone else not using the Rake tasks
require 'activerecord'
require 'active_record/fixtures'

Merb.start_environment(:testing => true, :adapter => 'runner', :environment => ENV['MERB_ENV'] || 'test')

Spec::Runner.configure do |config|
  config.include(Merb::Test::ViewHelper)
  config.include(Merb::Test::RouteHelper)
  config.include(Merb::Test::ControllerHelper)
end

def self.use_transactional_fixtures
  true
end

def authed_action(controller, action, params = { }, env = { })
  dispatch_to(controller, action, params, env) { |c|
    c.cookies[:phpbb2mysql_sid] = "test"
  }
end

def unauthed_action(controller, action, params = { }, env = { })
  dispatch_to(controller, action, params, env)
end

def unauthed_create(controller, model, action, params = { }, env = { }, destination = "")
  lambda {
    unauthed_action(controller, action, params, env).should redirect_to(destination) {
      self.should_not_receive(:create)
    }
  }.should_not change(controller, :count)
end

def authed_create(controller, model, action, params = { }, env = { }, redirect = "")
  lambda {
    authed_action(controller, action, params, env).should redirect_to(redirect) {
      self.should_receive(:create)
    }
  }.should change(controller, :count)
end

# Specs for edit action
def edit_specs(controller, update_params)
  describe "#edit" do
    it "should not allow unauthed edits" do
      unauthed_action(controller, :edit, update_params ,@env).should redirect_to("http://playground.pele.cx/blogposts/show")
    end

    it "should allow authed edits" do
      authed_action(controller, :edit, update_params,@env).should respond_successfully
    end
  end
end

# Specs for update action
def update_specs(controller, update_params, update_redir)
  describe "#update" do
    it "should not allow unauthed updates" do
      unauthed_action(controller, :update, update_params, @env).should redirect_to("http://playground.pele.cx/blogposts/show")

    end

    it "should allow authed updates" do
      authed_action(controller, :update, update_params, @env).should redirect_to(update_redir)
    end

  end
end

# Specs for destroy
def destroy_specs(controller, update_params, model)
  describe "#destroy" do
    it "should not allow unauthed destroys" do
      lambda { unauthed_action(controller, :destroy, update_params, @env) }.should_not change(model,:count)

    end

    it "should allow authed destroys" do
      lambda{ authed_action(controller, :destroy, update_params, @env)}.should change(model,:count)
    end
  end
end

# Specs for create
def create_specs(controller, create_params, model)
  describe "#create" do
    it "should not allow unauthed creates" do
      lambda { unauthed_action(controller, :create, create_params, @env)}.should_not change(model,:count)

    end

    it "should allow authed creates" do
      lambda { authed_action(controller, :create, create_params, @env)}.should change(model,:count)
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
