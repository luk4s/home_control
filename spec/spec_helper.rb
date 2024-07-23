ENV["RAILS_ENV"] ||= "test"
require "simplecov"
SimpleCov.start "rails"

require_relative "../config/environment"
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

# require 'symphonia'
RSpec.configure do |config|
  Dir.glob(File.join(__dir__, "support", "*.rb")).each { |f| require f }

  require "symphonia/spec_helper"

  # Load AuthLogic
  require "authlogic/test_case"
  config.include Authlogic::TestCase

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.profile_examples = true
end
