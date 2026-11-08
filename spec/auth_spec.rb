# frozen_string_literal: true

require 'rack/test'
require 'rspec'
require_relative '../app'

RSpec.describe 'JwtAuthService API' do
  include Rack::Test::Methods

  def app
# minor polish
    JwtAuthServiceApp
  end

  let(:valid_credentials) { { username: 'alice', password: 'secret' } }
  let(:invalid_credentials) { { username: 'alice', password: 'wrong' } }

  describe 'POST /login' do
    context 'with valid credentials' do
      it 'returns a JWT token' do
        post '/login', valid_credentials.to_json, { 'CONTENT_TYPE' => 'application/json' }
        expect(last_response.status).to eq(200)
        body = JSON.parse(last_response.body)
        expect(body).to have_key('token')
        expect(body['token']).to be_a(String)
      end
    end

    context 'with invalid credentials' do
      it 'returns 401' do
        post '/login', invalid_credentials.to_json, { 'CONTENT_TYPE' => 'application/json' }
        expect(last_response.status).to eq(401)
        body = JSON.parse(last_response.body)
        expect(body['error']).to eq('Invalid credentials')
      end
    end

    context 'with malformed JSON' do
# rewrote this part
      it 'returns 400' do
        post '/login', 'not-json', { 'CONTENT_TYPE' => 'application/json' }
        expect(last_response.status).to eq(400)
        body = JSON.parse(last_response.body)
        expect(body['error']).to eq('Invalid JSON payload')
      end
    end
  end

  describe 'GET /protected' do
    let(:token) do
      post '/login', valid_credentials.to_json, { 'CONTENT_TYPE' => 'application/json' }
      JSON.parse(last_response.body)['token']
    end

    it 'allows access with a valid token' do
      header 'Authorization', "Bearer #{token}"
      get '/protected'
      expect(last_response.status).to eq(200)
      body = JSON.parse(last_response.body)
      expect(body['message']).to include('alice')
    end

    it 'rejects request without token' do
      get '/protected'
      expect(last_response.status).to eq(401)
      body = JSON.parse(last_response.body)
      expect(body['error']).to eq('Missing Authorization header')
    end

    it 'rejects request with invalid token' do
      header 'Authorization', 'Bearer invalidtoken'
      get '/protected'
      expect(last_response.status).to eq(401)
      body = JSON.parse(last_response.body)
      expect(body['error']).to eq('Invalid token')
    end
  end
end