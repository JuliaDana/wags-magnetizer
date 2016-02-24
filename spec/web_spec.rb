require "lib/magnetizer.rb"
require "lib/wags_site_driver.rb"

describe "The Web Driver" do
  it "should log in to the website" do
    driver = WagsSiteDriver.new
    driver.log_in({:username => "***REMOVED***", :password => "***REMOVED***"})
    expect(page).to have_content("Logout")
  end

  it "should load the magnet creation page" do
    driver = WagsSiteDriver.new
    # driver.log_in({:username => "***REMOVED***", :password => "***REMOVED***"})
    driver.go_to_magnet_creation_problem
    # driver.load_test_file __FILE__
  end
end
