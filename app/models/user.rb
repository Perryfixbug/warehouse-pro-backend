class User < ApplicationRecord
  attr_accessor :remember_token
  has_many :orders, dependent: :destroy
  has_many :notifications, dependent: :destroy

  devise :database_authenticatable,
        :registerable,
        :recoverable,
        :rememberable,
        :validatable,
        :jwt_authenticatable,
        jwt_revocation_strategy: JwtDenylist

  USER_PARAMS = %w(fullname email phone address role password password_confirmation).freeze
  
  def remember
    @remember_token = User.new_token
    update_column(:remember_digest, User.digest(@remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")  # Metaprogramming lấy giá trị digest từ db
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def admin?
    return role == "admin"
  end

  def manager?
    return role == "manager"
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

    def ransackable_attributes(auth_object = nil)
      [
        "fullname",
        "email",
        "role",
        "created_at"
      ].freeze
    end

    def ransackable_associations(auth_object = nil)
      [
        "notifications",
        "orders"
      ].freeze
    end
  end
  # End class method
end
