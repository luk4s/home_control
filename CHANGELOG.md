# Changelog

This application uses release dates from the `version` file instead of semantic versions.

## 2026-06-13

- Applied security updates to dependencies.
- Updated Sentry to 6.6.2.
- Updated redis-client to 0.30.0.
- Updated RuboCop Rails and RSpec extensions.
- Updated json, msgpack, and net-imap.

## 2026-06-05

- Updated Ruby to 4.0.5.
- Updated Vite to 8.0.13.
- Updated Vite to 8.0.9.
- Updated Turbo to 8.0.23.

## 2026-04-18

- Upgraded Ruby, Rails, and Vite.

## 2026-04-17

- Upgraded Devise.
- Fixed Rails Action Cable configuration.

## 2026-04-16

- Added Devise token-based authentication.
- Added Rack::Attack fail2ban protection for API tokens.
- Hardened token validation by hashing cache keys and caching only valid tokens.
- Added API documentation link to account edit form.
- Updated Font Awesome and related dependencies.

## 2025-11-16

- Upgraded to Rails 8.
- Updated Ruby to 3.4.7.
- Updated Vite to 5.4.20.
- Updated Turbo to 8.0.20.
- Updated Rails UJS to 7.1.600.
- Updated Sass to 1.95.0.

## 2025-03-23

- Removed Symphonia dependency.
- Improved Atrea login retry flow.
- Refactored Docker entrypoint.
- Updated production SMTP configuration.
- Fixed Rack::Attack variable typo.

## 2025-01-27

- Improved ActiveJob uniqueness handling.

## 2025-01-24

- Updated `atrea_control` for optimized login process.
- Adjusted Symphonia spec for development gems.
- Improved test database compatibility checks.

## 2025-01-19

- Upgraded Ruby and dependencies.
- Marked last Selenium-based release.

## 2024-12-22

- Updated Vite assets setup.
- Updated Font Awesome to 6.7.2.
- Applied security dependency updates.
- Enabled exception notifications.
- Updated Rails UJS to 7.1.501.

## 2024-11-23

- Updated Rails Action Cable to 7.2.200.
- Updated Rails UJS to 7.1.500.
- Applied dependency security updates.

## 2024-10-20

- Updated `atrea_control`.
- Applied dependency security updates.

## 2024-08-24

- Updated dependencies for security fixes.

## 2024-07-22

- Disabled Turbo on login form.
- Updated dependencies.

## 2024-02-11

- Added dark theme.
- Fixed WebSocket behavior after login.
- Added missing login action.
- Split build and run jobs.
- Updated GitHub build-push action.

## 2024-02-10

- Updated dependencies.
- Shared Vite directory for assets.
- Fixed missing build output.

## 2023-11-01

- Added iReset button.
- Added missing Redis gem.

## 2023-10-16

- Upgraded to Rails 7.
- Replaced Webpacker with Vite Ruby.
- Updated Dockerfile for Ruby 3.2.
- Replaced Bootstrap `float-right` with `float-end`.
- Added reset button.

## 2023-03-01

- Removed unused Somfy code.
- Upgraded Symphonia and other dependencies.
- Cleaned database schema and factories.
- Updated CI workflow and dependency setup.
- Updated jQuery, Font Awesome, InfluxDB client, Bootsnap, Rails HTML Sanitizer, Loofah, and Nokogiri.

## 2022-09-26

- Upgraded Symphonia gem to version 5.
- Removed Sprockets/Symphonia from precompile flow.
- Fixed webpack compilation issues.

## 08-21

- Added manual ventilation control with slider.
- Added app version file.
- Cleaned unused JavaScript.
- Bulk-updated dependencies.
- Updated Stimulus and Webpack dev server.

## 1.1.0

- Initial version file release.
- Added app version definition.
- Cleaned unused JavaScript.
