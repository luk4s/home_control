source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.4"

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
  # Call "byebug" anywhere in the code to stop execution and get a debugger console
  gem "pry-rails"
end

group :development do
  # Access an interactive console on exception pages or by calling "console" anywhere in the code.
  gem "web-console", ">= 4.1.0"
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem "listen", "~> 3.3"
  gem "rack-mini-profiler", "~> 3.3"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
end

gem "atrea_control", "~> 2.3.0"
gem "symphonia", "~> 6.0.2"

source "https://gems.luk4s.cz" do
  gem "symphonia_spec", group: %i[development test]
end

gem "active_record-pgcrypto", "~> 0.2.6"
gem "influxdb-client", "~> 3.0"

gem "nokogiri", "~> 1.16", ">= 1.16.8", force_ruby_platform: true
gem "vite_rails", "~> 3.0"

gem "newrelic_rpm", "~> 9.11"
