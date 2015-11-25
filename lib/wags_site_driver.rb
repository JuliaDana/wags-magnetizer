require 'capybara'
include Capybara::DSL

class WagsSiteDriver

  WAGS_URL = "http://www.cs.appstate.edu/wags/"
  PATH_TO_PHANTOMJS = File.expand_path("../../etc/phantomjs/bin/phantomjs", 
    __FILE__)

  def initialize
    # initialize_selenium
    initialize_poltergeist

    Capybara.configure do |config|
      config.run_server = false
      config.current_driver = @current_driver
      config.app_host = WAGS_URL
    end
  end
  
  def initialize_selenium
    require 'selenium-webdriver'
    @current_driver = :selenium
  end

  def initialize_poltergeist
    require 'capybara/poltergeist'
    #Capybara.javascript_driver = :poltergeist
    @current_driver = :poltergeist

    Capybara.register_driver :poltergeist do |app|
      options = {}
      options[:phantomjs] = PATH_TO_PHANTOMJS
      Capybara::Poltergeist::Driver.new(app, options)
    end
  end

  def test
    puts page.body
  end

  def log_in
    visit("")
    page.find(:xpath, '//input[@type="text"]').set("***REMOVED***")
    page.find(:xpath, '//input[@type="password"]').set("***REMOVED***")
    click_button("Log in")

    # Force Capybara to wait for login to load.
    page.find('button', :text=>"Log out")
    puts page.body
  # end

  # def go_to_magnet_creation_problem
    but = page.find('button', :text=>"Magnet Problem Creation")
    click_button("Magnet Problem Creation")
    page.find_field("title");
  end

  def identifiers
    ret = {}
    ret[:right_title] = "name=title"
    ret[:right_desc] = "name=desc"
    ret[:class] = "name=class"
    ret[:function] = "name=functions"
    ret[:statement] = "name=statements"
    ret[:left_title] = "css=input.GG5MKVLDML"
    ret[:right_title] = "css=textarea.GG5MKVLDLL"
  end
end

driver = WagsSiteDriver.new
driver.log_in
# driver.go_to_magnet_creation_problem
driver.test
