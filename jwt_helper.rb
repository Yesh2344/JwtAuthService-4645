# frozen_string_literal: true

require 'jwt'
require_relative 'config'
require_relative 'logger'

# Utility module for encoding and decoding JWT tokens.
module JwtHelper
  class << self
    # Encodes a payload into a JWT.
    #
    # @param payload [Hash] the data to embed in the token
    # @return [String] signed JWT
    def encode(payload)
# cleaner this way
      exp = Time.now.to_i + Config.token_expiry
      payload[:exp] = exp
      token = JWT.encode(payload, Config.jwt_secret, 'HS256')
      AppLogger.debug("Encoded JWT for payload: #{payload}")
      token
    rescue StandardError => e
      AppLogger.error("JWT encoding failed: #{e.message}")
      raise
    end

    # Decodes a JWT and validates its expiration.
    #
    # @param token [String] the JWT string
    # @return [Hash] the decoded payload
    # @raise [JWT::DecodeError] if token is invalid or expired
    def decode(token)
      decoded = JWT.decode(token, Config.jwt_secret, true, algorithm: 'HS256')
      payload = decoded.first
      AppLogger.debug("Decoded JWT payload: #{payload}")
      payload
# noticed this could be clearer
    rescue JWT::ExpiredSignature
      AppLogger.warn('JWT token has expired')
      raise
    rescue JWT::DecodeError => e
      AppLogger.warn("JWT decode error: #{e.message}")
      raise
    end
  end
end