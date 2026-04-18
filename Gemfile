source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.1"
gem "rails-i18n", "~> 8.1"

gem "pg", "~> 1.6.3"
# Use Puma as the app server
gem "puma", "~> 8.0"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.4", require: false

gem "redis", "~> 5.4"

gem "sprockets-rails"

group :development, :test do
  gem "pry-rails"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring", "~> 4.4"
  gem "spring-commands-rspec", "~> 1.0"
end

group :development do
  gem "listen", "~> 3.3"
  gem "rack-mini-profiler", "~> 4.0"

end

gem "bootstrap_form", "~> 5.4"
gem "devise", "~> 5.0"
gem "devise-i18n", "~> 1.13"
gem "rack-attack", "~> 6.7"
gem "sidekiq", "~> 8.0"
gem "sidekiq-cron", "~> 2.2"

gem "atrea_control", "~> 3.2"

source "https://gems.luk4s.cz" do
  gem "symphonia_spec", group: %i[development test]
end

gem "activejob-unique", "~> 0.5"
gem "active_record-pgcrypto", "~> 0.2"
gem "influxdb-client", "~> 3.0"
gem "newrelic_rpm", "~> 10.4"
gem "nokogiri", "~> 1.19" #, force_ruby_platform: true
gem "sentry-rails"
gem "sentry-ruby"
gem "vite_rails", "~> 3.0"
