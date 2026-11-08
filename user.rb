# frozen_string_literal: true

# Simple in‑memory user model.
# In a real application replace this with an ActiveRecord model or similar.
class User
  attr_reader :username, :password_hash

  # @param username [String] unique identifier
  # @param password [String] plain‑text password (will be hashed)
  def initialize(username, password)
    @username = username
    @password_hash = hash_password(password)
  end

  # Checks if the supplied password matches the stored hash.
  #
  # @param password [String] plain‑text password to verify
  # @return [Boolean] true if match
  def authenticate?(password)
    hash_password(password) == @password_hash
  end

  # Returns a hash representation suitable for JWT payload.
  #
  # @return [Hash] user data
  def to_payload
    { username: @username }
  end

  # In‑memory user store.
  # @return [Array<User>]
  def self.all
    @users ||= [
      User.new('alice', 'secret'),
      User.new('bob', 'password')
    ]
  end

  # Finds a user by username.
  #
  # @param username [String]
  # @return [User, nil]
  def self.find_by_username(username)
    all.find { |u| u.username == username }
  end

  private

  # Very simple SHA256 hashing (for demo only – use bcrypt in production!)
  #
  # @param password [String]
  # @return [String] hex digest
  def hash_password(password)
    Digest::SHA256.hexdigest(password)
  end
end