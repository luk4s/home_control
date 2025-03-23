ENV["RAILS_ENV"] ||= "test"
require "simplecov"
SimpleCov.start "rails"

require_relative "../config/environment"
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require "rspec/rails"
require "database_cleaner"
require "factory_bot_rails"
require "faker"

require "devise"
# require 'symphonia'
RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :request
  config.include Devise::Test::ControllerHelpers, type: :view

  Dir.glob(File.join(__dir__, "support", "*.rb")).each { |f| require f }

  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation, except: %w[ar_internal_metadata])
  end

  config.before do
    DatabaseCleaner.strategy = :transaction
    # Symphonia::User.current = nil
  end

  config.before(:each, type: :feature) do
    # :rack_test driver's Rack app under test shares database connection
    # with the specs, so continue to use transaction strategy for speed.
    unless Capybara.current_driver == :rack_test
      # Driver is probably for an external browser with an app
      # under test that does *not* share a database connection with the
      # specs, so use truncation strategy.
      DatabaseCleaner.strategy = :truncation
    end
  end

  config.before do
    DatabaseCleaner.start
  end

  config.after(:suite) do
    FileUtils.rm_rf(Dir[Rails.root.join("spec/test_files/").to_s])
  end

  config.append_after do
    DatabaseCleaner.clean
  end

  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.profile_examples = true

  ActiveJob::Uniqueness.test_mode!
  ActiveJob::Base.queue_adapter = :test

  config.extend ControllerMacros, type: :controller
  config.extend ControllerMacros, type: :request
  config.extend ControllerMacros, type: :view
end
