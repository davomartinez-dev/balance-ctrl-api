Rails.application.configure do
  config.after_initialize do
    Bullet.enable        = true
    Bullet.bullet_logger = true
    Bullet.console       = true
    Bullet.rails_logger  = true
    Bullet.add_footer    = true
  end

  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true

  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.cache_store = :redis_store, "redis://#{ENV['REDIS_ENDPOINT']}:6379/0"
    config.session_store :redis_store, servers: [
      { host: ENV['REDIS_ENDPOINT'], port: 6379, db: 1 }
    ], key: ENV['APP_SESSION_KEY']
    config.action_controller.perform_caching = true
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  config.active_storage.service = :local
  config.action_mailer.delivery_method = :test
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_deliveries = false
  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = { host: ENV['FRONTEND_HOST'] }
  config.active_job.queue_adapter = :async
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
