require "lib/magnetizer.rb"
require "lib/wags_interaction/wags_site_driver.rb"

describe "The Web Driver" do
  it "should log in to the website" do
    driver = WagsSiteDriver.new :poltergeist
    driver.log_in({:username => "***REMOVED***", :password => "***REMOVED***"})
    sleep 2
    expect(page).to have_content("Logout")
  end

  xit "should load the magnet creation page" do
    driver = WagsSiteDriver.new
    driver.log_in({:username => "***REMOVED***", :password => "***REMOVED***"})
    sleep 2
    driver.go_to_magnet_problem_creation
    # driver.load_test_file __FILE__
  end

  it "should load a source file into the magnet creation page" do
    magnetizer = Magnetizer.new("spec/java_complex/RayTracer.java", "Java")

    driver = WagsSiteDriver.new :poltergeist
    #driver.log_in({:username => "***REMOVED***", :password => "***REMOVED***"})
    sleep 2
    driver.go_to_magnet_problem_creation

    t = Time.new.strftime("%F %r")
    driver.load_title "Julia RSpec #{t}"
    driver.load_description "Automated at #{t}"

    trans = MagnetTranslator.new
    driver.load_class_area trans.translate_to_wags_magnets(magnetizer.emitter.classMagnets)
    driver.load_functions_area trans.translate_to_wags_magnets(magnetizer.emitter.methodMagnets)
    driver.load_statements_area trans.translate_to_wags_magnets(magnetizer.emitter.preambleMagnets + magnetizer.emitter.statementMagnets)

    driver.submit_magnet_problem
  end
end
