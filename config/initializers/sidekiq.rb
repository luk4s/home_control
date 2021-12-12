require "sidekiq"
require "sidekiq-cron"

redis_url = ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" }

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
  # schedule_file = Rails.root.join("config/schedule.yml")
  #
  # if schedule_file.exist? && Sidekiq.server?
  #   Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  # end
  Rails.application.reloader.to_prepare do
    Sidekiq::Cron::Job.create(name: 'Read data from duplex - every 1min', cron: '*/1 * * * *', class: 'DuplexCronJob')
  end

end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end
