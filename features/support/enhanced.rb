#gem "selenium-client", '=1.2.14'
#require "selenium/client"
require "merb_cucumber/world/base"
require 'webrat'
require 'webrat/selenium'

Webrat.configure do |config|
  config.mode = :selenium
  # Selenium defaults to using the selenium environment. Use the following to override this.
  config.application_environment = :test
  config.application_framework = :merb
  config.application_port = 4000
  config.application_address = 'playground.test.pele.cx'
  config.selenium_browser_key = '*firefox3 /usr/lib/firefox-3.0.8/firefox'
  #  config.selenium_server_port = 4444
end

World do
  session = Webrat::SeleniumSession.new
#  session.selenium.remote_control_command("allowNativeXpath", [false,])
#  session.selenium.remote_control_command("UseXPathLibrary", ["javascript-xpath",])
#  Merb.logger.debug %Q|#{session.selenium.get_eval("this.browserbot.xpathLibrary='javascript-xpath'; this.browserbot.xpathLibrary")}|
  session
end

World(Webrat::Methods)
World(Webrat::Selenium::Methods)
World(Webrat::Selenium::Matchers)


#World do
#  session = Webrat::SeleniumSession.new
#  session.extend(Webrat::Methods)
#  session.extend(Webrat::Selenium::Methods)
#  session.extend(Webrat::Selenium::Matchers)
#  session.selenium.allow_native_xpath(true)
#  session.selenium.remote_control_command("useXPathLibrary", ["javascript-xpath",])
  #  session.selenium.use_xpath_library("javascript-xpath")
#  session
#end


#Webrat::Selenium::SeleniumRCServer.boot
#Webrat::Selenium::ApplicationServer.boot

#Before do
  # truncate your tables here, since you can't use transactional fixtures*
#end
#module Merb
#  module Test
#    module World
#      class WebratSelenium
#        include Base
#        include ::Webrat::Methods
#        include ::Webrat::Selenium::Methods
#        include ::Webrat::Selenium::Matchers
#      end
#    end
#  end
#end

#World do
#  Merb::Test::World::WebratSelenium.new
#end

