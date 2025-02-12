redis_config = {
  url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1'),
  ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE },
  timeout: ENV.fetch('REDIS_TIMEOUT', 1).to_i,
  reconnect_attempts: ENV.fetch('REDIS_RECONNECT_ATTEMPTS', 2).to_i,
  driver: :ruby  # Using the pure Ruby driver for better compatibility
}

# Configure Rails cache store
Rails.application.config.cache_store = :redis_cache_store, {
  url: redis_config[:url],
  pool_size: ENV.fetch('REDIS_POOL_SIZE', 5).to_i,
  pool_timeout: ENV.fetch('REDIS_POOL_TIMEOUT', 5).to_i,
  connect_timeout: redis_config[:timeout],
  reconnect_attempts: redis_config[:reconnect_attempts],
  error_handler: -> (method:, returning:, exception:) {
    Rails.logger.error(
      "Redis error: #{exception.class}: #{exception.message}\n"\
      "Method: #{method}, Returning: #{returning}"
    )
  }
}