# spec/rails_helper.rb
require 'simplecov'
SimpleCov.start 'rails' do
  add_filter '/spec/'
  add_filter '/config/'
  add_filter '/vendor/'

  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Services', 'app/services'
  add_group 'Helpers', 'app/helpers'
  add_group 'Mailers', 'app/mailers'
  add_group 'Jobs', 'app/jobs'

  # Set minimum coverage percentage
  minimum_coverage 90
end

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

# Add additional test framework requires
require 'capybara/rails'
require 'capybara/rspec'
require 'selenium-webdriver'
require 'webdrivers'
require 'database_cleaner/active_record'

# Configure webdrivers gem
Webdrivers::Chromedriver.required_version = '114.0.5735.90'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # Include FactoryBot methods
  config.include FactoryBot::Syntax::Methods

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # Include Capybara for feature tests
  config.include Capybara::DSL, type: :feature
  config.include Capybara::RSpecMatchers, type: :feature

  # Include Rails route helpers
  config.include Rails.application.routes.url_helpers

  # Database Cleaner configuration
  config.before(:suite) do
    DatabaseCleaner.allow_remote_database_url = true
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.allow_remote_database_url = true
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :feature) do
    DatabaseCleaner.allow_remote_database_url = true
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each, js: true) do
    DatabaseCleaner.allow_remote_database_url = true
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

# Configure Chrome driver for visible browser
Capybara.register_driver :selenium_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new

  # Configure Chrome for visible mode
  options.add_argument('--window-size=1920,1080')
  options.add_argument('--start-maximized')

  service = Selenium::WebDriver::Service.chrome(
    path: Webdrivers::Chromedriver.driver_path
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options,
    service: service
  )
end

# Capybara configuration
Capybara.configure do |config|
  config.default_driver = :rack_test
  config.javascript_driver = :selenium_chrome
  config.default_max_wait_time = 10
  config.server = :puma
  config.server_port = 3001
  config.app_host = 'http://localhost:3001'
end

# Configure Shoulda Matchers
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
