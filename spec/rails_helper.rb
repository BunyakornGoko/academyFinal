# spec/rails_helper.rb
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

# Add these Capybara requires
require 'capybara/rails'
require 'capybara/rspec'
require 'database_cleaner/active_record'

# Your existing configuration...

RSpec.configure do |config|
  # Your existing RSpec configuration...
  
  # Add Capybara configuration
  config.include Capybara::DSL, type: :feature
  config.include Capybara::DSL, type: :system
  
  # If you're using FactoryBot
  # config.include FactoryBot::Syntax::Methods
  
  # Your existing config...

  # Database Cleaner configuration
  config.use_transactional_fixtures = false
  
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :feature) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

# Capybara configuration
Capybara.configure do |config|
  config.default_driver = :rack_test
  config.javascript_driver = :selenium_chrome_headless
  config.default_max_wait_time = 5
  config.server_port = 3001 # Avoid conflicts with development server
end

# Custom Chrome driver for JavaScript tests
Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--disable-gpu')
  options.add_argument('--window-size=1920,1080')
  
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options
  )
end