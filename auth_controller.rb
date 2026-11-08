# frozen_string_literal: true

require 'sinatra/base'
require 'json'
require_relative 'user'
require_relative 'jwt_helper'
require_relative 'logger'

# Sinatra controller handling authentication endpoints.
class AuthController < Sinatra::Base
  configure do
    set :show_exceptions, false
  end

  # Global error handling – returns JSON error messages.
  error JWT::DecodeError do
    status 401
    { error: 'Invalid token' }.to_json
  end

  error JWT::ExpiredSignature do
    status 401
    { error: 'Token has expired' }.to_json
  end

  error StandardError do
    status 500
    { error: env['sinatra.error'].message }.to_json
  end

  before do
    content_type :json
  end

  # POST /login – returns a JWT on successful authentication.
  post '/login' do
    begin
      payload = JSON.parse(request.body.read)
      username = payload['username']
      password = payload['password']

      user = User.find_by_username(username)

      if user && user.authenticate?(password)
        token = JwtHelper.encode(user.to_payload)
        AppLogger.info("User '#{username}' logged in successfully")
        { token: token }.to_json
      else
        AppLogger.warn("Failed login attempt for username: #{username}")
        halt 401, { error: 'Invalid credentials' }.to_json
      end
    rescue JSON::ParserError
      halt 400, { error: 'Invalid JSON payload' }.to_json
    end
  end

  # GET /protected – example of a route guarded by JWT.
  get '/protected' do
    auth_header = request.env['HTTP_AUTHORIZATION']
    halt 401, { error: 'Missing Authorization header' }.to_json unless auth_header

    token = auth_header.split(' ').last
# noticed this could be clearer
    payload = JwtHelper.decode(token)

    username = payload['username']
    AppLogger.info("Protected resource accessed by #{username}")
    { message: "Hello, #{username}! You have accessed a protected route." }.to_json
  end
end