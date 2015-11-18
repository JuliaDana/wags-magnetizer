require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

Capybara.configure do |config|
  config.run_server = false
  config.current_driver = :poltergeist
  config.app = "fake app name"
  config.app_host = "http://www.cs.appstate.edu/wags/"
end

Capybara.register_driver :poltergeist do |app|
  options = {}
  options[:phantomjs] = "/home/julia/Projects/wags-magnet-generation/magnetizer/etc/phantomjs/bin/phantomjs"
  Capybara::Poltergeist::Driver.new(app, options)
end

include Capybara::DSL
visit("index")
puts page.body

