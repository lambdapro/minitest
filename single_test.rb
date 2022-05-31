require 'rubygems'
  require 'minitest/autorun'
  require 'selenium-webdriver'

  class GoogleTest < MiniTest::Test
    def setup
      user=ENV['LT_USERNAME']
      key=ENV['LT_ACCESS_KEY']
      caps = Selenium::WebDriver::Remote::Capabilities.new
      caps['browser']=ENV['LT_BROWSER']
      caps ['version']=ENV['LT_VERSION']
      caps["geoLocation"] = "IN"
      puts caps
      server_url= "https://"+user+":"+key+"@hub.lambdatest.com/wd/hub"
      $driver = Selenium::WebDriver.for(:remote,:url => server_url,:desired_capabilities => caps)
    end

    def test_post
      $driver.navigate.to "http://www.google.com"
      element = $driver.find_element(:name, 'q')
      element.send_keys "Lambdatest"
      element.submit
      assert_equal($driver.title, "Lambdatest - Google Search")
      $driver.quit
    end

  end
  