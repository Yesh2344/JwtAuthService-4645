# frozen_string_literal: true

require 'sinatra'
require_relative 'config'
require_relative 'logger'
require_relative 'auth_controller'

# Main entry point – mounts the AuthController.
class JwtAuthServiceApp < Sinatra::Base
  use AuthController

  # Health check endpoint
  get '/' do
    content_type :json
    { status: 'ok', version: '1.0.0' }.to_json
  end

  # Start the server if this file is executed directly.
  run! if app_file == $PROGRAM_NAME
end