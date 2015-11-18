require 'capybara/poltergeist'
class WagsSiteDriver
  include Capybara::DSL

  WAGS_URL = "http://www.cs.appstate.edu/wags/"
  PATH_TO_PHANTOMJS = File.expand_path("../../etc/phantomjs/bin/phantomjs", 
    __FILE__)
  
  def initialize
    Capybara.javascript_driver = :poltergeist


    Capybara.configure do |config|
      config.run_server = false
      config.current_driver = :poltergeist
      config.app_host = WAGS_URL
    end

    Capybara.register_driver :poltergeist do |app|
      options = {}
      options[:phantomjs] = PATH_TO_PHANTOMJS
      Capybara::Poltergeist::Driver.new(app, options)
    end
  end

  def test
    visit("")
    puts page.body
  end
end

WagsSiteDriver.new.test

