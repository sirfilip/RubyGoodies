# play with irb
require 'capybara'

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

session = Capybara::Session.new(:selenium_chrome)
session.visit('https://google.com')
session.find('input[title=Search]').set("Capybara Rocks")
