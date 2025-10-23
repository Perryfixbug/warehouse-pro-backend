class User < ApplicationRecord
  has_secure_password
  attr_accessor :remember_token

  def remember
    @remember_token = User.new_token
    update_column(:remember_digest, User.digest(@remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")  # Metaprogramming lấy giá trị digest từ db
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  # Begin class method
  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ?
              BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end
  # End class method
end
