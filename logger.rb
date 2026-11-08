# frozen_string_literal: true

# Simple wrapper around the Config logger to provide a consistent API.
module AppLogger
  class << self
    # Logs a message at INFO level.
    #
    # @param message [String] the message to log
    def info(message)
      Config.logger.info(message)
    end

    # Logs a message at DEBUG level.
    #
    # @param message [String] the message to log
    def debug(message)
      Config.logger.debug(message)
    end

    # Logs a message at WARN level.
    #
    # @param message [String] the message to log
    def warn(message)
      Config.logger.warn(message)
    end

    # Logs a message at ERROR level.
    #
    # @param message [String] the message to log
    def error(message)
      Config.logger.error(message)
    end
  end
end