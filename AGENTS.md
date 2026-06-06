# AGENTS.md

## Stack
- Rails 8.1 app on Ruby 4.0.5; Dockerfile uses `ruby:4.0.5-alpine`.
- Frontend assets use Vite Ruby, Yarn 1.22.22, Stimulus, Turbo, and Rails UJS.
- PostgreSQL is required for dev/test; Redis is required for Sidekiq and production ActionCable.

## Commands
- Setup/update local env: `bin/setup --skip-server`.
- Start app: `bin/rails server`; `bin/dev` does same despite `Procfile.dev` listing Vite.
- Full local CI: `bin/ci` runs setup, `bin/rubocop`, `yarn audit`, then `bin/rspec`.
- Focused Ruby style: `bin/rubocop`.
- Full specs: `bin/rspec`.
- Single spec: `bin/rspec spec/path/to_spec.rb` or `bin/rspec spec/path/to_spec.rb:LINE`.
- Prepare test DB: `bin/rails db:test:prepare`.

## Runtime / Env
- DB config reads `DATABASE_HOST`, `DATABASE_PORT`, `POSTGRES_USER`, and `POSTGRES_PASSWORD`; `.env.example` only documents user/password/timezone.
- CI creates `.env.test` with `DATABASE_HOST=localhost`, Postgres credentials, `RAILS_MASTER_KEY`, and `VITE_RUBY_AUTO_BUILD=false`.
- Redis URL defaults to `redis://localhost:6379/1`; docker-compose overrides it to `redis://redis:6379/1`.
- Production Docker `start` runs migrations before Puma via `bin/docker-entrypoint.sh`.

## Architecture
- Root route is `HomesController#show`; users authenticate through Devise.
- `Home#duplex` wraps `lib/atrea_duplex.rb`, which talks to `atrea_control` and persists auth tokens.
- `DuplexReadDataJob` reads Atrea data, broadcasts via `DuplexChannel`, and optionally writes InfluxDB line protocol.
- Sidekiq cron is registered in `config/initializers/sidekiq.rb` every minute as `DuplexCronJob`; initializer destroys/recreates cron jobs on server boot.
- Vite source dir is `app/javascript`; alias `@` maps to `/app/javascript`.

## Testing Notes
- Specs use RSpec, FactoryBot, DatabaseCleaner, SimpleCov, and Devise controller helpers.
- `spec/spec_helper.rb` forces ActiveJob uniqueness test mode and `ActiveJob::Base.queue_adapter = :test`.
- Controller/request/view specs can use `login_user` / `login_admin` from `spec/support/controller_macros.rb`.
- Avoid real Atrea/Influx calls in specs; existing job specs stub `home.duplex`.

## CI / Deploy
- GitHub CI builds and pushes Docker image before running tests inside that image.
- Deploy aliases image tags only on `master` after build and tests pass.
