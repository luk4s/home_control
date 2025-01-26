require "sidekiq"
require "sidekiq-cron"

redis_url = ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" }

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
  Sidekiq::Cron::Job.destroy_all!
  Rails.application.config.after_initialize do
    Sidekiq::Cron::Job.create(name: "Read data from duplex - every 1min", cron: "*/1 * * * *", class: "DuplexCronJob")
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end
