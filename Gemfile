source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1"

gem "pg", "~> 1.5.4"
# Use Puma as the app server
gem "puma", "~> 6.4"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.4", require: false

gem "redis", "~> 5.0"

gem "sprockets-rails"

group :development, :test do
  gem "pry-rails"
end

group :development do
  gem "listen", "~> 3.3"
  gem "rack-mini-profiler", "~> 3.3"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
end

gem "atrea_control", "~> 3.0"
gem "symphonia", "~> 6.0.2"

source "https://gems.luk4s.cz" do
  gem "symphonia_spec", group: %i[development test]
end

gem "activejob-uniqueness", "~> 0.4.0"
gem "active_record-pgcrypto", "~> 0.2.6"
gem "influxdb-client", "~> 3.0"
gem "newrelic_rpm", "~> 9.11"
gem "nokogiri", "~> 1.16", force_ruby_platform: true
gem "sentry-rails"
gem "sentry-ruby"
gem "vite_rails", "~> 3.0"
