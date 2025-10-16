source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.2", ">= 7.2.2.2"

gem "pg", "~> 1.5.4"
# Use Puma as the app server
gem "puma", "~> 6.4"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.4", require: false

gem "redis", "~> 5.4"

gem "sprockets-rails"

group :development, :test do
  gem "pry-rails"
end

group :development do
  gem "listen", "~> 3.3"
  gem "rack-mini-profiler", "~> 4.0", ">= 4.0.0"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
end

gem "bootstrap_form", "~> 5.4"
gem "devise", "~> 4.9"
gem "devise-i18n", "~> 1.14", ">= 1.14.0"
gem "rack-attack", "~> 6.8", ">= 6.8.0"
gem "rails-i18n", "~> 8.0", ">= 8.0.0"
gem "sidekiq", "~> 8.0", ">= 8.0.2"
gem "sidekiq-cron", "~> 2.3", ">= 2.3.0"

gem "atrea_control", "~> 3.0"

source "https://gems.luk4s.cz" do
  gem "symphonia_spec", group: %i[development test]
end

gem "activejob-uniqueness", "~> 0.4"
gem "active_record-pgcrypto", "~> 0.2"
gem "influxdb-client", "~> 3.0"
gem "newrelic_rpm", "~> 9.11"
gem "nokogiri", "~> 1.16", force_ruby_platform: true
gem "sentry-rails", ">= 5.24.0"
gem "sentry-ruby"
gem "vite_rails", "~> 3.0"

