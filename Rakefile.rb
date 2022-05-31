require 'rubygems'
  require 'rake/testtask'
  require 'parallel'
  require 'json'

  @browsers = JSON.load(open('browsers.json'))
  @test_folder = "single_test.rb"
  @parallel_limit = ENV["nodes"] || 1
  @parallel_limit = @parallel_limit.to_i

  task :minitest do
    current_browser = ""
    begin
      Parallel.map(@browsers, :in_threads => @parallel_limit) do |browser|
        current_browser = browser
        puts "Running Browser : #{browser.inspect}"
        ENV['LT_CAPS'] = browser.inspect
        ENV['LT_BROWSER']=browser['browserName']
        ENV['LT_VERSION']=browser['version']
        Dir.glob(@test_folder).each do |test_file|
          IO.popen("ruby #{test_file}") do |io|
            io.each do |line|
              puts line
            end
          end
        end
      end
    rescue SystemExit, Interrupt
      puts "User stopped script!"
      puts "Failed to run tests for #{current_browser.inspect}"
    end
  end

  task :default => [:minitest]