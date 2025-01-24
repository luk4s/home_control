if ENV["GLITCHTIP_DSN"]
  Sentry.init do |config|
    config.dsn = ENV["GLITCHTIP_DSN"]
    config.breadcrumbs_logger = %i[active_support_logger http_logger]
    config.environment = "production"
  end
end
