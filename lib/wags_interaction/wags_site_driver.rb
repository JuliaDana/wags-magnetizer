require 'capybara'
include Capybara::DSL

class WagsSiteDriver

  WAGS_URL = "http://www.cs.appstate.edu/wags/beta"
  PATH_TO_PHANTOMJS = File.expand_path("../../etc/phantomjs/bin/phantomjs", 
    __FILE__)

  def initialize driver = :selenium
    self.send("initialize_#{driver}")

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
      options[:js_errors] = false
      Capybara::Poltergeist::Driver.new(app, options)
    end
  end

  def log_in credentials
    visit("")
    page.find(:xpath, '//input[@placeholder="Username"]').set(credentials[:username])
    page.find(:xpath, '//input[@placeholder="Password"]').set(credentials[:password])
    click_link("Sign in")
  end

  def go_to_magnet_creation_problem
    visit("#magnetpc")
    page.find_field("title");
  end

  def load_class_area text

  end

  def load_functions_area text

  end

  def load_statements_area text

  end

  def load_test_file path_to_file
    puts page.find_field('testClass')
    page.attach_file('testClass', path_to_file)
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
