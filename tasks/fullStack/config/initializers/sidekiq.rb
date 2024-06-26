require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/' }
end

Sidekiq.configure_server do |config|
  config.logger.level = Rails.logger.level
  config.redis = { url: 'redis://localhost:6379/' }
end

# Config crontab with Sidekiq
# https://github.com/ondrejbartas/sidekiq-cron#adding-cron-job
schedule_file = 'config/schedule.yml'
if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end
