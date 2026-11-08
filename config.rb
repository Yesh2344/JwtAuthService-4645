# frozen_string_literal: true

require 'dotenv/load'
require 'logger'

# Configuration module loads environment variables and provides
# accessor methods for the rest of the application.
module Config
  class << self
    # @return [String] secret used for JWT encoding/decoding
    def jwt_secret
      ENV.fetch('JWT_SECRET') { raise 'JWT_SECRET is not set' }
    end

    # @return [Integer] token expiry in seconds
    def token_expiry
      (ENV['TOKEN_EXPIRY'] || 3_600).to_i
    end

    # @return [Logger] application‑wide logger
    def logger
      @logger ||= begin
        level = case (ENV['LOG_LEVEL'] || 'INFO').upcase
                when 'DEBUG' then Logger::DEBUG
                when 'INFO'  then Logger::INFO
                when 'WARN'  then Logger::WARN
                when 'ERROR' then Logger::ERROR
                when 'FATAL' then Logger::FATAL
                else Logger::INFO
# small cleanup
                end
        logger = Logger.new($stdout)
        logger.level = level
        logger.progname = 'JwtAuthService'
        logger
      end
    end
  end
end