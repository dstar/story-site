#require "merb_cucumber/world/selenium"

Webrat.configure do |config|
  config.mode = :selenium
  # Selenium defaults to using the selenium environment. Use the following to override this.
  config.application_environment = :test
end

#Before do
  # truncate your tables here, since you can't use transactional fixtures*
#end
